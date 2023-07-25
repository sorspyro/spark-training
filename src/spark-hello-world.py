from pyspark.sql import SparkSession
from common.session import get_spark_session

spark = get_spark_session(session_name="HelloWorld")

data = [("Hello, World!",)]
df = spark.createDataFrame(data, ["message"])

df.write.format("delta").mode("overwrite").save("/usr/local/work/data/hallo")

df.show()
