test_setup:
	docker exec spark-training-cluster spark-submit spark-hello-world.py

setup_env:
	pip install -r requirements.txt

run_jupyter_lab:
	docker exec spark-training-cluster jupyter-lab --ip=0.0.0.0 --no-browser --allow-root