set(extProjectName "tbb")
message(STATUS "External Project: ${extProjectName}" )

set(tbb_VERSION "44_20160526")

set(tbb_INSTALL "${EMsoft_SDK}/tbb${tbb_VERSION}oss")
set(tbb_url_server "http://dream3d.bluequartz.net/binaries/SDK/Sources/TBB")
if(APPLE)
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_osx.tgz")
elseif(WIN32)
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_win.zip")
else()
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_lin.tgz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)

#------------------------------------------------------------------------------
# Windows and OS X have TBB Compiled and installed
if(NOT WIN32 AND NOT APPLE)
  ExternalProject_Add(${extProjectName}
    # DOWNLOAD_NAME ${extProjectName}-${tbb_VERSION}.tar.gz
    URL ${tbb_URL}
    TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp"
    DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
    SOURCE_DIR "${EMsoft_SDK}/${extProjectName}${tbb_VERSION}oss"
    BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${tbb_INSTALL}"
    CONFIGURE_COMMAND "" 
    BUILD_COMMAND "" 
    INSTALL_COMMAND ""

    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
  )

  #-- Append this information to the EMsoft_SDK CMake file that helps other developers
  #-- configure EMsoft for building
  FILE(APPEND ${EMsoft_SDK_FILE} "\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_INSTALL_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${tbb_VERSION}oss\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

else()
#------------------------------------------------------------------------------
# Linux Ubuntu 14.04 has an acceptable TBB installation
  FILE(APPEND ${EMsoft_SDK_FILE} "\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_INSTALL_DIR \"/usr\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

endif()

