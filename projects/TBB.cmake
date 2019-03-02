set(extProjectName "tbb")
set(tbb_VERSION "2019_20181203")

message(STATUS "External Project: ${extProjectName}: ${tbb_VERSION}" )

set(tbb_INSTALL "${EMsoft_SDK}/tbb${tbb_VERSION}oss")
set(tbb_url_server "https://github.com/01org/tbb/releases/download/2019_U3")

if(APPLE)
  set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_mac.tgz")
elseif(WIN32)
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_win.zip")
else()
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_lin.tgz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)

#------------------------------------------------------------------------------
# Linux has TBB Compiled and installed
if(WIN32 OR APPLE OR "${BUILD_TBB}" STREQUAL "ON" )
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
  #-- configure DREAM3D for building
  #-- Starting with TBB 2018 U5 the Parallel STL is included which is why we need 
  #-- the double path to the TBB cmake directory
  FILE(APPEND ${EMsoft_SDK_FILE} "\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_INSTALL_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${tbb_VERSION}oss/${extProjectName}${tbb_VERSION}oss\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${tbb_VERSION}oss/${extProjectName}${tbb_VERSION}oss/cmake\" CACHE PATH \"\")\n") 
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

else()
  message(STATUS "LINUX: Please use your package manager to install Threading Building Blocks (TBB)")
  #------------------------------------------------------------------------------
  # Linux has an acceptable TBB installation
  FILE(APPEND ${EMsoft_SDK_FILE} "\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_INSTALL_DIR \"/usr\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_DIR \"/usr\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

endif()

