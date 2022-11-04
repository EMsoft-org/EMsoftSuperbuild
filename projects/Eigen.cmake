#--------------------------------------------------------------------------------------------------
# Are we building Eigen (ON by default)
#--------------------------------------------------------------------------------------------------
option(BUILD_EIGEN "Build Eigen" ON)
if(NOT BUILD_EIGEN)
  return()
endif()


set(extProjectName "Eigen")
set(Eigen_VERSION "3.3.9")

message(STATUS "Building: ${extProjectName} ${Eigen3_VERSION}: -DBUILD_EIGEN=${BUILD_EIGEN}")

#set(Eigen_URL "https://bitbucket.org/eigen/eigen/get/${Eigen_VERSION}.tar.gz")
set(Eigen_URL "http://dream3d.bluequartz.net/binaries/SDK/Eigen-${Eigen_VERSION}.tar.gz")
set(SOURCE_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/Source/${extProjectName}.tar.gz")

if(WIN32)
  set(Eigen_CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
elseif(APPLE)
  set(Eigen_CXX_FLAGS "-stdlib=libc++ -std=c++11")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(Eigen_CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(Eigen_CXX_FLAGS "-std=c++11")
  endif()
endif()

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

configure_file(
  "${_self_dir}/patches/Eigen_DartConfiguration.tcl.in"
  "${EMsoftOO_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}/DartConfiguration.tcl"
  @ONLY
  )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoftOO_SDK}/superbuild)

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${Eigen_VERSION}.tar.gz
  URL ${Eigen_URL}
  TMP_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${EMsoftOO_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${SOURCE_DIR}"
  BINARY_DIR "${EMsoftOO_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${EMsoftOO_SDK}/${extProjectName}-${Eigen_VERSION}"

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_CXX_FLAGS=${Eigen_CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -Wno-dev
    -DQT_QMAKE_EXECUTABLE=
    -DBUILD_SHARED_LIBS=OFF 
    -DBUILD_TESTING=OFF 

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)



#-- Append this information to the EMsoftOO_SDK CMake file that helps other developers
#-- configure EMsoft for building
FILE(APPEND ${EMsoftOO_SDK_FILE} "\n")
FILE(APPEND ${EMsoftOO_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoftOO_SDK_FILE} "# Eigen Library Location\n")
FILE(APPEND ${EMsoftOO_SDK_FILE} "set(Eigen3_DIR \"\${EMsoftOO_SDK_ROOT}/Eigen-${Eigen_VERSION}/share/eigen3/cmake\" CACHE PATH \"\")\n")

# Set this variable into the Cache since we are going to need it for other projects later.
set(Eigen3_DIR ${EMsoftOO_SDK}/Eigen-${Eigen_VERSION}/share/eigen3/cmake CACHE PATH "" FORCE)

