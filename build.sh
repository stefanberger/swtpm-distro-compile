#!/usr/bin/env bash

# to build without cache: build.sh --no-cache
# to force a re-build of libtpms and swtpm: DATE=$(date) build.sh

if [ -c /dev/vtpmx ]; then
	# This creates test failures when using --privileged
	echo "Remove tpm_vtpm_proxy from kernel."
	exit 1
fi

for img in \
	alpine \
	quay.io/centos/centos:stream8 \
	quay.io/centos/centos:stream9 \
	debian \
	fedora \
	opensuse/tumbleweed \
	ubuntu;
do
	echo "------------------------------------"
	echo ">>>>>> Running tests in $df <<<<<<"
	set -x
	docker run \
		--env LIBTPMS_BRANCH=${LIBTPMS_BRANCH:-master} \
		--env SWTPM_BRANCH=${SWTPM_BRANCH:-master} \
		--env DATE="${DATE:-none}" \
		--rm \
		--privileged \
		-v ${PWD}:/test \
		${img} \
		/test/test.$(echo ${img} | tr "/" "-" | cut -d ":" -f1) \
		|| { echo "${img} failed."; exit 1; }
done
