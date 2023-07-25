test_setup:
	docker exec spark-training-cluster spark-submit spark-hello-world.py

setup_env:
	pip install -r requirements.txt