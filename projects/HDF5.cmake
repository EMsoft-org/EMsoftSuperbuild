set(extProjectName "hdf5")

set(HDF5_VERSION "1.10.5")
message(STATUS "External Project: ${extProjectName}: ${HDF5_VERSION}" )

#set(HDF5_URL "http://www.hdfgroup.org/ftp/HDF5/prev-releases/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz")
set(HDF5_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/HDF5/hdf5-${HDF5_VERSION}.tar.gz")

set(HDF5_BUILD_SHARED_LIBS ON)
set(HDF5_INSTALL "${EMsoft_SDK}/${extProjectName}-${HDF5_VERSION}-${CMAKE_BUILD_TYPE}")

if(MSVC_IDE)
  set(HDF5_INSTALL "${EMsoft_SDK}/${extProjectName}-${HDF5_VERSION}")
endif()

if(NOT WIN32)
  set(HDF5_BUILD_SHARED_LIBS OFF)
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(HDF5_SUFFIX "_debug")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)


if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(C_FLAGS "/DWIN32 /D_WINDOWS /W3 /MP")
  set(C_CXX_FLAGS -DCMAKE_CXX_FLAGS=${CXX_FLAGS} -DCMAKE_C_FLAGS=${C_FLAGS})
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++")
  endif()
endif()

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${HDF5_VERSION}.tar.gz
  URL ${HDF5_URL}
  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${HDF5_VERSION}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${HDF5_VERSION}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${HDF5_VERSION}"
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${HDF5_VERSION}/Source/${extProjectName}"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${HDF5_VERSION}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${HDF5_INSTALL}"

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${HDF5_BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON 
    -DHDF5_BUILD_WITH_INSTALL_NAME=ON 
    -DHDF5_BUILD_CPP_LIB=ON 
    -DHDF5_BUILD_HL_LIB=ON
    -DHDF5_BUILD_FORTRAN=ON
    -DHDF5_BUILD_EXAMPLES=OFF
    -DBUILD_TESTING=OFF

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)


#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure EMsoft for building
# -- The HDF5_DIR variable is VERY dependent on the version of HDF5 being compiled. If EMsoft
#-- moves up to HDF5 1.10.x then those paths are slightly different.
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# HDF5 Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}-\${BUILD_TYPE}/share/cmake/hdf5\" CACHE PATH \"\")\n")
elseif(MSVC_IDE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}/cmake/hdf5\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}-\${BUILD_TYPE}/cmake/hdf5\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(HDF5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${HDF5_VERSION}-\${BUILD_TYPE}/share/cmake/hdf5\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${HDF5_DIR})\n")
