import os

from spark_session import create_spark_session


def main():
    spark = create_spark_session("01-read-postgres")

    df = (
        spark.read.format("jdbc")
        .option("url", os.getenv("POSTGRES_URL"))
        .option("dbtable", "orders")
        .option("user", os.getenv("POSTGRES_USER"))
        .option("password", os.getenv("POSTGRES_PASSWORD"))
        .option("driver", "org.postgresql.Driver")
        .load()
    )

    df.printSchema()
    df.show(20, truncate=False)

    spark.stop()


if __name__ == "__main__":
    main()

