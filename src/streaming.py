from common.session import get_spark_session

spark = get_spark_session("streaming_test")

table_path = "/usr/local/work/data/delta_crud1"
df = spark.readStream.format("delta").option("readChangeFeed", "true").load(table_path)

stream = df.writeStream.format("console").start()

# checkpointLocation = "/home/spark/spark_jobs/playground/checkpoints/"
# stream = df.writeStream.format("console").option("checkpointLocation", checkpointLocation).start()

stream.awaitTermination()

# for each sink / foreachBatch
# Triggers - default, avilable-now, contunuous
# maxBytesPerTrigger / maxFilesPerTrigger
