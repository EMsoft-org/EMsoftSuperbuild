#--------------------------------------------------------------------------------------------------
# Are we building BSPLINE-FORTRAN (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(BUILD_BSPLINEFORTRAN "Build BSPLINEFORTRAN" ON)
if("${BUILD_BSPLINEFORTRAN}" STREQUAL "OFF")
  return()
endif()

set(extProjectName "BSPLINEFORTRAN")

#------------------------------------------------------------------------------
set(BSPLINEFORTRAN_VERSION "7.4.0")
# we pull from a forked repository since a change was made to make the 
# set_extrap_flag routine public in the object oriented version of the package...
set(GIT_REPOSITORY_URL "https://github.com/marcdegraef/bspline-fortran")

message(STATUS "Building: ${extProjectName} ${BSPLINEFORTRAN_VERSION}: -DBUILD_BSPLINEFORTRAN=${BUILD_BSPLINEFORTRAN}" )


# This is need to figure out the proper install dir for some Linux distributions
include(GNUInstallDirs)

if(MSVC_IDE)
  set(BSPLINEFORTRAN_INSTALL "${EMsoftOO_SDK}/${extProjectName}-${BSPLINEFORTRAN_VERSION}")
elseif(WIN32)
  set(BSPLINEFORTRAN_INSTALL "${EMsoftOO_SDK}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(BSPLINEFORTRAN_INSTALL "${EMsoftOO_SDK}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(BSPLINEFORTRAN_SUFFIX "_debug")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoftOO_SDK}/superbuild)


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
  #DOWNLOAD_NAME ${extProjectName}-${BSPLINEFORTRAN_VERSION}.tar.gz
  #URL ${BSPLINEFORTRAN_URL}
  GIT_REPOSITORY "${GIT_REPOSITORY_URL}"
  GIT_TAG "${BSPLINEFORTRAN_VERSION}"
  TMP_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${EMsoftOO_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${BSPLINEFORTRAN_INSTALL}"

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

#-- Append this information to the EMsoftOO_SDK CMake file that helps other developers
#-- configure EMsoft for building
FILE(APPEND ${EMsoftOO_SDK_FILE} "\n")
FILE(APPEND ${EMsoftOO_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoftOO_SDK_FILE} "# BSPLINEFORTRAN Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_INSTALL \"\${EMsoftOO_SDK_ROOT}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_DIR \"\${EMsoftOO_SDK_ROOT}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-\${BUILD_TYPE}/lib\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${BSPLINEFORTRAN_DIR}\" CACHE PATH \"\")\n")
elseif(MSVC_IDE)
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_INSTALL \"\${EMsoftOO_SDK_ROOT}/${extProjectName}-${BSPLINEFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_DIR \"\${BSPLINEFORTRAN_INSTALL}/lib/cmake/${extProjectName}-${FC_NAME}-${BSPLINEFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${BSPLINEFORTRAN_DIR}\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_INSTALL \"\${EMsoftOO_SDK_ROOT}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_DIR \"\${BSPLINEFORTRAN_INSTALL}/lib/cmake/${extProjectName}-${FC_NAME}-${BSPLINEFORTRAN_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${BSPLINEFORTRAN_DIR}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_INSTALL \"\${EMsoftOO_SDK_ROOT}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(BSPLINEFORTRAN_DIR \"\${EMsoftOO_SDK_ROOT}/${extProjectName}-${BSPLINEFORTRAN_VERSION}-\${BUILD_TYPE}/lib\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoftOO_SDK_FILE} "set(${extProjectName}-${FC_NAME}_DIR \"\${BSPLINEFORTRAN_DIR}\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoftOO_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${BSPLINEFORTRAN_DIR})\n")
FILE(APPEND ${EMsoftOO_SDK_FILE} "Check3rdPartyDir(DIR \${BSPLINEFORTRAN_DIR})\n")


