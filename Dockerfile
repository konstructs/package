FROM konstructs-package-base

ARG PLUGINS
ARG REPOS

# clone plugins
RUN bash -c ' \
	for plugin in $PLUGINS; do \
		git clone https://github.com/konstructs/server-plugin-${plugin}.git; \
	done'
RUN bash -c ' \
	for repo in $REPOS; do \
		git clone https://github.com/konstructs/${repo}.git; \
	done'

# Build sbt projects
RUN bash -xc ' \
	for sbt_proj in */build.sbt; do \
		build=${sbt_proj%/*}; \
		([[ $build != \* ]] \
			&& cd $build \
			&& sbt test package \
			&& git checkout $(git describe --abbrev=0) \
			&& sbt test package \
		); \
	done'

## Build gradle projects
RUN bash -xc ' \
	for gradle_proj in */build.gradle; do \
		build=${gradle_proj%/*}; \
		([[ $build != \* ]] \
			&& cd $build \
			&& ./gradlew build \
			&& mv build/libs/$build{.jar,-SNAPSHOT.jar} \
			&& git checkout $(git describe --abbrev=0) \
			&& ./gradlew build \
		); \
	done'
