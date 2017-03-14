set(extProjectName "tbb")
message(STATUS "External Project: ${extProjectName}" )

set(tbb_VERSION "44_20160526")

set(tbb_INSTALL "${DREAM3D_SDK}/tbb${tbb_VERSION}oss")
set(tbb_url_server "http://dream3d.bluequartz.net/binaries/SDK/Sources/TBB")
if(APPLE)
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_osx.tgz")
elseif(WIN32)
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_win.zip")
else()
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_lin.tgz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

#------------------------------------------------------------------------------
# Windows and OS X have TBB Compiled and installed
if(NOT WIN32 AND NOT APPLE)
  ExternalProject_Add(${extProjectName}
    # DOWNLOAD_NAME ${extProjectName}-${tbb_VERSION}.tar.gz
    URL ${tbb_URL}
    TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
    DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
    SOURCE_DIR "${DREAM3D_SDK}/${extProjectName}${tbb_VERSION}oss"
    BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
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

  #-- Append this information to the DREAM3D_SDK CMake file that helps other developers
  #-- configure DREAM3D for building
  FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_INSTALL_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}${tbb_VERSION}oss\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

else()
#------------------------------------------------------------------------------
# Linux Ubuntu 14.04 has an acceptable TBB installation
  FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_INSTALL_DIR \"/usr\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

endif()

