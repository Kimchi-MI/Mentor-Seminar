import os
import json
from pyspark.sql.functions import current_date, max as _max
from spark_session import create_spark_session

PIPELINE = "orders_incremental"
TARGET = "s3a://test-bucket/raw/postgres/orders_incremental/"
WM_PATH = "s3a://test-bucket/_meta/orders_incremental_watermark.json"
EPOCH = "1970-01-01 00:00:00"


def read_watermark(spark):
    try:
        raw = spark.read.text(WM_PATH).collect()[0][0]
        return json.loads(raw)["last_updated_at"]
    except Exception:
        return EPOCH


def write_watermark(spark, value):
    payload = json.dumps({"pipeline": PIPELINE, "last_updated_at": str(value)})
    spark.createDataFrame([(payload,)], ["value"]) \
        .write.mode("overwrite").text(WM_PATH)


def main():
    spark = create_spark_session("08-incremental-load")

    wm = read_watermark(spark)

    df = (
        spark.read.format("jdbc")
        .option("url", os.getenv("POSTGRES_URL"))
        .option("dbtable", f"(SELECT * FROM orders WHERE updated_at > '{wm}') t")
        .option("user", os.getenv("POSTGRES_USER"))
        .option("password", os.getenv("POSTGRES_PASSWORD"))
        .option("driver", "org.postgresql.Driver")
        .load()
        .withColumn("load_date", current_date())
    )

    rows = df.count()

    if rows == 0:
        print("Nothing to load")
        spark.stop()
        return

    df.write.mode("append").partitionBy("load_date").parquet(TARGET)

    new_wm = df.agg(_max("updated_at")).collect()[0][0]
    write_watermark(spark, new_wm)

    spark.stop()


if __name__ == "__main__":
    main()