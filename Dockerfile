FROM python:3.10-slim

# For multi platform build. Get value from --platform flag or set current platform if not given in docker build command.
ARG TARGETPLATFORM

# Suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# (Required) Install utilities required by Spark scripts.
RUN apt update && apt install -y procps tini wget g++


# Spark dependencies

# Default values can be overridden at build time.

ARG spark_version="3.3.1"
ARG hadoop_version="3"
ARG scala_version="2.13"
ARG openjdk_version="17"

ENV SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

# Install Java Platform (required for PySpark).

RUN apt-get update --yes && \
    apt-get install --yes ca-certificates-java && \
    apt-get install --yes --no-install-recommends \
    "openjdk-${openjdk_version}-jre-headless" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Pyspark.

RUN wget -qO /tmp/spark.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${scala_version}.tgz && \
    tar xzf /tmp/spark.tgz -C /usr/local && \
    rm /tmp/spark.tgz


ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=${PYTHONPATH}:/usr/local/spark/python/lib/py4j-0.10.9.5-src.zip:/usr/local/spark/python/lib/pyspark.zip
ENV PATH=${PATH}:${SPARK_HOME}/bin

RUN ln -s "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${scala_version}" "${SPARK_HOME}"

RUN wget https://repo1.maven.org/maven2/org/apache/sedona/sedona-python-adapter-3.0_2.13/1.3.1-incubating/sedona-python-adapter-3.0_2.13-1.3.1-incubating.jar -P ${SPARK_HOME}/jars \
    && wget https://repo1.maven.org/maven2/org/datasyslab/geotools-wrapper/1.3.0-27.2/geotools-wrapper-1.3.0-27.2.jar -P ${SPARK_HOME}/jars \
    && wget https://repo1.maven.org/maven2/io/delta/delta-core_2.13/2.3.0/delta-core_2.13-2.3.0.jar -P ${SPARK_HOME}/jars \
    && wget https://repo1.maven.org/maven2/io/delta/delta-storage/2.3.0/delta-storage-2.3.0.jar -P ${SPARK_HOME}/jars \
    && wget https://jdbc.postgresql.org/download/postgresql-42.5.4.jar -P ${SPARK_HOME}/jars


# Spark-python dependencies
RUN pip install delta-spark==2.3.0 apache-sedona==1.3.1

# Delta standalone for playground
RUN pip install deltalake

RUN mkdir -p /usr/local/work
WORKDIR /usr/local/work