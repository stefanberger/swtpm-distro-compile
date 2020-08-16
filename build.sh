#!/usr/bin/env bash

# to build without cache: build.sh --no-cache

for df in  \
	Dockerfile.alpine \
	Dockerfile.centos \
	Dockerfile.debian \
	Dockerfile.fedora \
	Dockerfile.opensuse-tumbleweed \
	Dockerfile.ubuntu; do
	echo "------------------------------------"
	echo ">>>>>> Building $df <<<<<<"
	docker build \
		--build-arg LIBTPMS_BRANCH=${LIBTPMS_BRANCH:-master} \
		--build-arg SWTPM_BRANCH=${SWTPM_BRANCH:-master} \
		$@ -f $df . || { echo "$fd failed."; exit 1; }
done
