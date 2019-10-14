set(extProjectName "jsonfortran")
message(STATUS "External Project: ${extProjectName}" )

set(JSONFORTRAN_VERSION "4.2.1")

# This is need to figure out the proper install dir for some Linux distributions
include(include(GNUInstallDirs)

if(MSVC_IDE)
  set(JSONFORTRAN_INSTALL "${EMsoft_SDK}/${extProjectName}-${JSONFORTRAN_VERSION}")
elseif(WIN32)
  set(JSONFORTRAN_INSTALL "${EMsoft_SDK}/${extProjectName}-${JSONFORTRAN_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(JSONFORTRAN_INSTALL "${EMsoft_SDK}/${extProjectName}-${JSONFORTRAN_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(JSONFORTRAN_SUFFIX "_debug")
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

if (${CMAKE_Fortran_COMPILER} MATCHES "gfortran.*")
  set(FC_NAME "GNU")
endif()
# if (${CMAKE_Fortran_COMPILER} MATCHES "ifort.*")
#   set(FC_NAME "intel")
# endif()

ExternalProject_Add(${extProjectName}
  #DOWNLOAD_NAME ${extProjectName}-${JSONFORTRAN_VERSION}.tar.gz
  #URL ${JSONFORTRAN_URL}
  GIT_REPOSITORY https://github.com/bluequartzsoftware/json-fortran
  GIT_TAG "4.2.1"
  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${JSONFORTRAN_INSTALL}"

  CMAKE_ARGS
  #  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DUSE_GNU_INSTALL_CONVENTION=ON
    -DSKIP_DOC_GEN=1

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

if (${CMAKE_Fortran_COMPILER} MATCHES "gfortran.*")
  set(FC_NAME "gnu")
endif()
if (${CMAKE_Fortran_COMPILER} MATCHES "ifort.*")
  set(FC_NAME "intel")
endif()

#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure EMsoft for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# JSONFORTRAN Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${JSONFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${JSONFORTRAN_VERSION}-\${BUILD_TYPE}/lib/cmake/${extProjectName}-${FC_NAME}-${JSONFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${JSONFORTRAN_DIR}\" CACHE PATH \"\")\n")
elseif(MSVC_IDE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${JSONFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_DIR \"\${JSONFORTRAN_INSTALL}/lib/cmake/${extProjectName}-${FC_NAME}-${JSONFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${JSONFORTRAN_DIR}\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${JSONFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_DIR \"\${JSONFORTRAN_INSTALL}/lib/cmake/${extProjectName}-${FC_NAME}-${JSONFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${JSONFORTRAN_DIR}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${JSONFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(JSONFORTRAN_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${JSONFORTRAN_VERSION}-\${BUILD_TYPE}/${CMAKE_INSTALL_LIBDIR}/cmake/${extProjectName}-${FC_NAME}-${JSONFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${JSONFORTRAN_DIR}\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${JSONFORTRAN_DIR})\n")
FILE(APPEND ${EMsoft_SDK_FILE} "Check3rdPartyDir(DIR \${JSONFORTRAN_DIR})\n")


