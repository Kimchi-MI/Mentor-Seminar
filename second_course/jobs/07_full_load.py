import os
from pyspark.sql.functions import current_date
from spark_session import create_spark_session


def main():
    spark = create_spark_session("07-full-load")

    df = (
        spark.read.format("jdbc")
        .option("url", os.getenv("POSTGRES_URL"))
        .option("dbtable", "orders")
        .option("user", os.getenv("POSTGRES_USER"))
        .option("password", os.getenv("POSTGRES_PASSWORD"))
        .option("driver", "org.postgresql.Driver")
        .load()
        .withColumn("load_date", current_date())
    )

    src = df.count()

    df.write.mode("overwrite") \
        .partitionBy("load_date") \
        .parquet("s3a://test-bucket/raw/postgres/orders/")

    dst = spark.read.parquet("s3a://test-bucket/raw/postgres/orders/").count()

    assert src == dst, f"MISMATCH: {src} != {dst}"

    spark.stop()


if __name__ == "__main__":
    main()