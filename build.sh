#!/bin/bash

set -e

VERSION=7.77.0
REPO_PATH=repo
BUILD_PATH="${REPO_PATH}/_build"

BUILD_PATH_RELEASE="${BUILD_PATH}/release"
BUILD_PATH_DEBUG="${BUILD_PATH}/debug"

get_suffix() {
	local system_version=$(lsb_release -sr | tr -d '.')
	local system_name=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
	local system_machine=$(uname -m | tr '_' '-')
	echo "${system_machine}-${system_name}-${system_version}"
}


SUFFIX_NAME=$(get_suffix)
build() {
	local source_path="${1}"
	local version="${2}"
	local build_type="${3}"
	local debug_suffix=""
	local build_path="${source_path}/${build_type}"
	mkdir -p "${build_path}"
	if ! [ "${build_type}" == "Release" ]; then
		debug_suffix="d"
	fi
	pushd "${build_path}"
		local stripped_version=$(echo -n ${version} | tr '.' '_' )
		git checkout curl-${stripped_version}
		cmake -DCMAKE_BUILD_TYPE=${build_type} \
			-DHTTP_ONLY=ON \
			-DCPPFLAG_CURL_STATICLIB="-fPIC" \
			-DBUILD_SHARED_LIBS=OFF \
			-DCMAKE_INSTALL_PREFIX=INSTALL \
			../
		make -j 10
		make install
		pushd INSTALL
			zip -r libcurl${debug_suffix}-dev_v${version}_${SUFFIX_NAME}.zip ./*
		popd
		mv INSTALL/*.zip ./
	popd
	mv ${build_path}/*.zip ./
}



if ! [ -d "${REPO_PATH}" ]; then
	git clone https://github.com/curl/curl.git "${REPO_PATH}"
fi

build "${REPO_PATH}" "${VERSION}" Release
build "${REPO_PATH}" "${VERSION}" Debug

