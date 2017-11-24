set(extProjectName "CLFortran")
message(STATUS "External Project: ${extProjectName}" )

set(CLFORTRAN_VERSION "0.0.1")

if(WIN32)
  set(CLFORTRAN_INSTALL "${EMsoft_SDK}/${extProjectName}-${CLFORTRAN_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(CLFORTRAN_INSTALL "${EMsoft_SDK}/${extProjectName}-${CLFORTRAN_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(CLFORTRAN_SUFFIX "_debug")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)


if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(OpenCL_INCLUDE_DIR "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0/include")
  set(OpenCL_LIBRARY "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0/lib/x64/OpenCL.lib")
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
  #DOWNLOAD_NAME ${extProjectName}-${CLFORTRAN_VERSION}.tar.gz
  #URL ${CLFORTRAN_URL}
  GIT_REPOSITORY http://www.github.com/bluequartzsoftware/clfortran
  GIT_TAG "develop"
  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${CLFORTRAN_INSTALL}"

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

#--------------------------------------------------------------------------------------------------
# FORTRAN CL Library
# set(CLFORTRAN_INSTALL "${EMsoft_SDK_ROOT}/CLFortran")
# set(CLFORTRAN_DIR "${EMsoft_SDK_ROOT}/CLFortran/lib/CMake/CLFortran")


#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure EMsoft for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# CLFORTRAN Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CLFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${CLFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CLFORTRAN_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${CLFORTRAN_VERSION}-\${BUILD_TYPE}/lib/cmake/CLFortran\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CLFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${CLFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CLFORTRAN_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${CLFORTRAN_VERSION}-\${BUILD_TYPE}/lib/cmake/CLFortran\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CLFORTRAN_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${CLFORTRAN_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(CLFORTRAN_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${CLFORTRAN_VERSION}-\${BUILD_TYPE}/lib/cmake/CLFortran\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${CLFORTRAN_DIR})\n")
FILE(APPEND ${EMsoft_SDK_FILE} "Check3rdPartyDir(DIR \${CLFORTRAN_DIR})\n")

