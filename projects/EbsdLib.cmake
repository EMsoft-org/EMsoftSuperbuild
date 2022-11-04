set(extProjectName "EbsdLib")
message(STATUS "External Project: ${extProjectName}" )

set(EbsdLib_VERSION "2.0")
set(GIT_HASH "develop")

if(MSVC_IDE)
  set(EbsdLib_INSTALL "${EMsoft_SDK}/${extProjectName}-${EbsdLib_VERSION}")
elseif(WIN32)
  set(EbsdLib_INSTALL "${EMsoft_SDK}/${extProjectName}-${EbsdLib_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(EbsdLib_INSTALL "${EMsoft_SDK}/${extProjectName}-${EbsdLib_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(EbsdLib_SUFFIX "_debug")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)

set(DEPENDS Eigen tbb)
if(TARGET ghcFilesystem)
  set(DEPENDS ${DEPENDS} ghcFilesystem)
endif()

if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(DEPENDS Eigen tbb)
endif()



ExternalProject_Add(${extProjectName}
  DEPENDS ${DEPENDS}
  GIT_REPOSITORY http://www.github.com/bluequartzsoftware/EbsdLib
  GIT_TAG "${GIT_HASH}"
  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${EbsdLib_INSTALL}"

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT:PATH=${OSX_SDK}
    -DEigen3_DIR:PATH=${Eigen3_DIR}
    -DEbsdLib_ENABLE_HDF5:BOOL=OFF
    -DghcFilesystem_DIR:PATH=${EMsoft_SDK}/ghcFilesystem-1.3.2/lib/cmake/ghcFilesystem
    -DTBB_DIR:PATH=${EMsoft_SDK}/tbb-${tbb_VERSION}-${tbb_os_name}/tbb/cmake

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
FILE(APPEND ${EMsoft_SDK_FILE} "# EbsdLib Library Location\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}-\${BUILD_TYPE}/share/cmake/EbsdLib\" CACHE PATH \"\")\n")
elseif(MSVC_IDE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}/share/cmake/EbsdLib\" CACHE PATH \"\")\n") 
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}-\${BUILD_TYPE}/share/cmake/EbsdLib\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_INSTALL \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(EbsdLib_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${EbsdLib_VERSION}-\${BUILD_TYPE}/share/cmake/EbsdLib\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${EbsdLib_DIR})\n")
FILE(APPEND ${EMsoft_SDK_FILE} "Check3rdPartyDir(DIR \${EbsdLib_DIR})\n")
