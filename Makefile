SHELL=/bin/bash -x
PLUGINS=flowers grass forest water
REPOS=server server-api

build: build-base
	docker build \
		-t konstructs-package \
		--build-arg PLUGINS="${PLUGINS}" \
		--build-arg REPOS="${REPOS}" \
		.

build-base:
	docker build -t konstructs-package-base -f Dockerfile-base .

out:
	mkdir out

extract: build out
	for proj in ${REPOS} $$(for p in ${PLUGINS}; do echo server-plugin-$$p; done); do \
		FILES="$$(docker run -ti konstructs-package find $$proj -type f -name *$${proj}*.jar | tr -d '\r')"; \
		for file in $$FILES; do \
			if [ ! -z $$file ]; then \
				docker run -ti konstructs-package cat $$file > out/$${file##*/}; \
			fi; \
		done; \
	done;
