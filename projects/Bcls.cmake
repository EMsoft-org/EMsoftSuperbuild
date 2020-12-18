set(extProjectName "bcls")
message(STATUS "External Project: ${extProjectName}" )
if(NOT "${MKL_DIR}" STREQUAL "")
  message(STATUS "|-- MKL_DIR: ${MKL_DIR}")
endif()
set(bcls_VERSION "0.1")
set(BCLS_GIT_TAG "develop")

if(MSVC_IDE)
  set(bcls_INSTALL "${EMsoft_SDK}/${extProjectName}-${bcls_VERSION}")
elseif(WIN32)
  set(bcls_INSTALL "${EMsoft_SDK}/${extProjectName}-${bcls_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(bcls_INSTALL "${EMsoft_SDK}/${extProjectName}-${bcls_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(bcls_SUFFIX "_debug")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)

#-------------------------------------------------------------------------------
# We only support Intel Visual Fortran 2018 and newer since those have a sane
# folder structure scheme. These next lines make sense on Windows Intel installs,
# let's hope that their installations on Linux and macOS are about the same
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

if(${Fortran_COMPILER_NAME} MATCHES "gfortran.*")
  set(BCLS_USE_MKL "OFF")
elseif (${Fortran_COMPILER_NAME} MATCHES "ifort.*")
  set(BCLS_USE_MKL "ON")
else()
  message(STATUS "The Fotran compiler is NOT recognized. EMsoft may not support it.")
  message(FATAL_ERROR "Current Fotran Compiler is ${CMAKE_Fortran_COMPILER}")
endif()



ExternalProject_Add(${extProjectName}
  #DOWNLOAD_NAME ${extProjectName}-${bcls_VERSION}.tar.gz
  #URL ${bcls_URL}
  GIT_REPOSITORY http://www.github.com/bluequartzsoftware/bcls
  GIT_TAG "${BCLS_GIT_TAG}"
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
    -DBCLS_USE_MKL:BOOL=${BCLS_USE_MKL}
    -DMKL_DIR:PATH=${MKL_DIR}

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
FILE(APPEND ${EMsoft_SDK_FILE} "# bcls Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}/lib/cmake/bcls\" CACHE PATH \"\")\n")
elseif(MSVC_IDE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}/lib/cmake/bcls\" CACHE PATH \"\")\n") 
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}/lib/cmake/bcls\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(bcls_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${bcls_VERSION}-\${BUILD_TYPE}/lib/cmake/bcls\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${bcls_DIR})\n")
FILE(APPEND ${EMsoft_SDK_FILE} "Check3rdPartyDir(DIR \${bcls_DIR})\n")
