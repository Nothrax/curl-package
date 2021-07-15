##
#
# Download and initialize variable curl_ROOT
#

IF(NOT CMAKE_BUILD_TYPE)
	MESSAGE(FATAL_ERROR "curl package does not provide multi-conf support!")
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)
CMLIB_DEPENDENCY(
	URI "https://github.com/bringauto/cmake-package-tools.git"
	URI_TYPE GIT
	TYPE MODULE
)
FIND_PACKAGE(CMAKE_PACKAGE_TOOLS REQUIRED)

SET(platform_string)
CMAKE_PACKAGE_TOOLS_PLATFORM_STRING(platform_string)

SET(version v7.77.0)
SET(curl_url)
IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
	SET(curl_url
		"https://github.com/bringauto/curl-package/releases/download/${version}/libcurld-dev_${version}_${platform_string}.zip"
	)
ELSE()
	SET(curl_url
		"https://github.com/bringauto/curl-package/releases/download/${version}/libcurl-dev_${version}_${platform_string}.zip"
	)
ENDIF()

CMLIB_DEPENDENCY(
	URI "${curl_url}"
	TYPE ARCHIVE
	OUTPUT_PATH_VAR _curl_ROOT
)

SET(CURL_ROOT "${_curl_ROOT}"
	CACHE STRING
	"curl root directory"
	FORCE
)

UNSET(_curl_ROOT)
UNSET(curl_url)
UNSET(version)
UNSET(platform_string)
