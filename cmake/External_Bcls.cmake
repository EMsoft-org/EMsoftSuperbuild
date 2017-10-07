set(extProjectName "bcls")
message(STATUS "External Project: ${extProjectName}" )

set(bcls_VERSION "0.1")

if(WIN32)
  set(bcls_INSTALL "${EMsoft_SDK}/${extProjectName}-${bcls_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(bcls_INSTALL "${EMsoft_SDK}/${extProjectName}-${bcls_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(bcls_SUFFIX "_debug")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)


if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
elseif(APPLE)
  set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(CXX_FLAGS "-std=c++11")
  endif()
endif()

ExternalProject_Add(${extProjectName}
  #DOWNLOAD_NAME ${extProjectName}-${bcls_VERSION}.tar.gz
  #URL ${bcls_URL}
  GIT_REPOSITORY http://www.github.com/bluequartzsoftware/bcls
  GIT_TAG "develop"
  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${bcls_INSTALL}"

  CMAKE_ARGS
  #  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DOpenCL_INCLUDE_DIR:PATH=${OpenCL_INCLUDE_DIR}
    -DOpenCL_LIBRARY:FILEPATH=${OpenCL_LIBRARY}

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)


#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# bcls Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}/share/cmake\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}/lib/cmake/bcls\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}/share/cmake\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${bcls_DIR})\n")
