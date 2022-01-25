install:
	pip install -r requirements/dev.txt

clean: ## remove generated byte code and build artifacts
	find . -name '__pycache__' -exec rm -rf {} +
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

upgrade: export CUSTOM_COMPILE_COMMAND=make upgrade
upgrade: ## update the requirements/*.txt files with the latest packages satisfying requirements/*.in
	pip install -qr requirements/pip-tools.txt
	pip-compile --rebuild --upgrade --allow-unsafe --rebuild -o requirements/pip.txt requirements/pip.in
	pip-compile --rebuild --upgrade -o requirements/pip-tools.txt requirements/pip-tools.in
	pip-compile --rebuild --upgrade -o requirements/dev.txt requirements/dev.in

requirements: ## install development environment requirements
	pip install -qr requirements/pip.txt
	pip install -qr requirements/pip-tools.txt
	pip install -qr requirements/dev.txt --exists-action w
	pip-sync requirements/dev.txt requirements/private.*
