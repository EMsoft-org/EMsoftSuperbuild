
set(extProjectName "FFTW")
message(STATUS "External Project: ${extProjectName}" )

set(FFTW_VERSION "3.3.4")
set(FFTW_PREFIX "${EMsoft_SDK}/superbuild/${extProjectName}")

set(FFTW_DOWNLOAD_DIR "${EMsoft_SDK}/superbuild/${extProjectName}")
set(FFTW_BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build")
set(FFTW_SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source")
set(FFTW_STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp")
set(FFTW_TEMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Tmp")
set(FFTW_INSTALL_DIR "${EMsoft_SDK}/Doxygen-${FFTW_VERSION}")
set(FFTW_DOWNLOAD_FILE ${FFTW_FOLDER_NAME}.tar.gz)
if(WIN32)
  set(FFTW_INSTALL_DIR "${EMsoft_SDK}/fftw-${FFTW_VERSION}-dll64")
  set(FFTW_FOLDER_NAME "fftw-${FFTW_VERSION}-dll64")
endif()

set(FFTW_url_server "http://dream3d.bluequartz.net/binaries/EMSoft_SDK/")

if(WIN32)
  set(FFTW_DOWNLOAD_FILE fftw-${FFTW_VERSION}-dll64.zip)
elseif(APPLE)
  set(FFTW_DOWNLOAD_FILE fftw-${FFTW_VERSION}.tar.gz)
else()
  set(FFTW_DOWNLOAD_FILE fftw-${FFTW_VERSION}.tar.gz)
endif()

set(FFTW_URL "${FFTW_url_server}/${FFTW_DOWNLOAD_FILE}")

set_property(DIRECTORY PROPERTY EP_BASE ${FFTW_PREFIX})

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

#-- On OS X systems we are going to simply download Doxygen and copy the .app bundle to the /Applications DIRECTORY
#-- which is where CMake expects to find it.
if(APPLE)
  set(DOX_OSX_BASE_NAME Doxygen-${FFTW_VERSION})
  set(DOX_OSX_DMG_ABS_PATH "${EMsoft_SDK}/superbuild/${extProjectName}/Doxygen-${FFTW_VERSION}.dmg")
  set(FFTW_DMG ${DOX_OSX_DMG_ABS_PATH})

  configure_file(
    "${_self_dir}/Doxygen_osx_install.sh.in"
    "${CMAKE_BINARY_DIR}/Doxygen_osx_install.sh"
    @ONLY
  )

  if(NOT EXISTS "${DOX_OSX_DMG_ABS_PATH}")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}-${FFTW_VERSION}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${FFTW_URL} "${DOX_OSX_DMG_ABS_PATH}" SHOW_PROGRESS)
  endif()

  if(NOT EXISTS "/Applications/DOxygen.app")
    execute_process(COMMAND "${CMAKE_BINARY_DIR}/Doxygen_osx_install.sh"
                    OUTPUT_VARIABLE MOUNT_OUTPUT
                    RESULT_VARIABLE did_run
                    ERROR_VARIABLE mount_error
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
    message(STATUS "OUTPUT_VARIABLE: ${MOUNT_OUTPUT}")
  endif()

elseif(WIN32)


  set_property(DIRECTORY PROPERTY EP_BASE ${EMsoft_SDK}/superbuild)

  ExternalProject_Add(${extProjectName}
    DOWNLOAD_NAME ${FFTW_DOWNLOAD_FILE}
    URL ${FFTW_URL}
    TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp"
    STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp"
    DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}
    SOURCE_DIR "${FFTW_INSTALL_DIR}"
    BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${FFTW_INSTALL_DIR}"

    CONFIGURE_COMMAND ""
    PATCH_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""

    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
  )

else()

  ExternalProject_Add( Doxygen
    #--Download step--------------
    #   GIT_REPOSITORY ""
    #   GIT_TAG ""
    URL ${FFTW_URL}
    # URL_MD5
    #--Update/Patch step----------
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    #--Configure step-------------
    SOURCE_DIR "${FFTW_SOURCE_DIR}"
    CONFIGURE_COMMAND ""
    #--Build step-----------------
    BINARY_DIR "${FFTW_BINARY_DIR}"
    BUILD_COMMAND ""
    #--Install step-----------------
    INSTALL_DIR "${FFTW_INSTALL_DIR}"
    INSTALL_COMMAND ""
    DEPENDS ${FFTW_DEPENDENCIES}
  )

endif()


FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# FFTW ${FFTW_VERSION} Location\n")
if(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_INSTALL \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}-dll64/fftw-${FFTW_VERSION}-dll64\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_VERSION \"${FFTW_VERSION}\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_INCLUDE_DIR \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}-dll64\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_LIBRARY \"\${EMsoft_SDK_ROOT}/fftw-${FFTW_VERSION}-dll64/libfftw3-3.lib\")\n")
  FILE(APPEND ${EMsoft_SDK_FILE} "set(FFTW3_IS_SHARED TRUE)\n")
else()

endif()