.PHONY: test test-all upload register clean bootstrap

test: bootstrap
	_virtualenv/bin/py.test tests

upload: jq.c
	python setup.py sdist upload
	make clean

register:
	python setup.py register

clean:
	rm -f MANIFEST
	rm -rf dist

bootstrap: _virtualenv jq.c
ifneq ($(wildcard test-requirements.txt),)
	_virtualenv/bin/pip install -r test-requirements.txt
endif
	make clean

_virtualenv:
	python3 -m venv _virtualenv
	# Don't upgrade pip on GraalPy, see https://github.com/oracle/graalpython/blob/master/docs/contributor/IMPLEMENTATION_DETAILS.md#patching-of-packages
ifneq ($(wildcard _virtualenv/bin/graalpy),)
	_virtualenv/bin/pip install --upgrade pip
	_virtualenv/bin/pip install --upgrade setuptools
	_virtualenv/bin/pip install --upgrade wheel
endif

jq.c: _virtualenv jq.pyx
	_virtualenv/bin/pip install -e .
