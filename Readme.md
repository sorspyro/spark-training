## Environment Setup

To setup training environmen do following steps:
```
1. python -m venv .venv
2. source ./venv/bin/activate
3. make setup_env
4. docker-compose up -d
```


To test if everything was set up correctly type:
```
make test_setup
```

Hello World dataframe should appear in a prompt and data/hallo directory should be created inside src folder.