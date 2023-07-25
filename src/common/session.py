from pyspark.sql import SparkSession
from delta import configure_spark_with_delta_pip


def get_spark_session(session_name: str = "test") -> SparkSession:
    builder = SparkSession.builder.appName(session_name)
    builder = builder.config(
        "spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension"
    ).config(
        "spark.sql.catalog.spark_catalog",
        "org.apache.spark.sql.delta.catalog.DeltaCatalog",
    )
    builder = configure_spark_with_delta_pip(builder)

    spark = builder.getOrCreate()
    return spark
