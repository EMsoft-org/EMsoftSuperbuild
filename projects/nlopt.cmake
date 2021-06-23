#--------------------------------------------------------------------------------------------------
# Are we building NLOPT (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(BUILD_NLOPT "Build nlopt" ON)
if("${BUILD_NLOPT}" STREQUAL "OFF")
  return()
endif()

set(extProjectName "nlopt")
set(nlopt_VERSION "2.7.0")
message(STATUS "Building: ${extProjectName} ${nlopt_VERSION}: -DBUILD_NLOPT=${BUILD_NLOPT}" )

if(MSVC_IDE)
  set(nlopt_INSTALL "${EMsoft_SDK}/${extProjectName}-${nlopt_VERSION}")
elseif(WIN32)
  set(nlopt_INSTALL "${EMsoft_SDK}/${extProjectName}-${nlopt_VERSION}-${CMAKE_BUILD_TYPE}")
else()
  set(nlopt_INSTALL "${EMsoft_SDK}/${extProjectName}-${nlopt_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)


# if(DREAM3D_USE_CUSTOM_DOWNLOAD_SITE)
#   set(EP_SOURCE_ARGS  
#     DOWNLOAD_NAME ${extProjectName}-${nlopt_VERSION}.zip
#     URL ${DREAM3D_CUSTOM_DOWNLOAD_URL_PREFIX}${extProjectName}-${nlopt_VERSION}.zip
#   )
# else()
  set(EP_SOURCE_ARGS  
    GIT_REPOSITORY "https://github.com/stevengj/nlopt.git"
    GIT_PROGRESS 1
    GIT_TAG v${nlopt_VERSION}
  )
#endif()

ExternalProject_Add(${extProjectName}
  ${EP_SOURCE_ARGS}

  TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${nlopt_VERSION}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${nlopt_VERSION}/Stamp"
  DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}-${nlopt_VERSION}/Download
  SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${nlopt_VERSION}/Source"
  BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}-${nlopt_VERSION}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${nlopt_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}

    -DNLOPT_CXX=ON
    -DNLOPT_FORTRAN=ON
    -DNLOPT_GUILE=OFF
    -DNLOPT_MATLAB=OFF
    -DNLOPT_OCTAVE=OFF
    -DNLOPT_PYTHON=OFF
    -DNLOPT_SWIG=OFF
    -DNLOPT_TESTS=OFF

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
FILE(APPEND ${EMsoft_SDK_FILE} "# haru\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(nlopt_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${nlopt_VERSION}-\${BUILD_TYPE}/cmake/lib${extProjectName}\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(nlopt_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${nlopt_VERSION}/cmake/lib${extProjectName}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(nlopt_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}-${nlopt_VERSION}-\${BUILD_TYPE}/cmake/lib${extProjectName}\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${nlopt_DIR})\n")
FILE(APPEND ${EMsoft_SDK_FILE} "set(nlopt_VERSION \"${nlopt_VERSION}\" CACHE STRING \"\")\n")
