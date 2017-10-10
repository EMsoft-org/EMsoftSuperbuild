set(extProjectName "Qt")
message(STATUS "External Project: ${extProjectName}" )

# set(qt5_version_full "5.6.2")
# set(qt5_version_short "5.6")
# set(qt5_installer_version "56")

# Qt 5.9.x is going to be used.
set(qt5_version_full "5.9.2")
set(qt5_version_short "5.9.2")
set(qt5_installer_version "591")


set(qt5_INSTALL "${EMsoft_SDK}/${extProjectName}${qt5_version_full}")
set(qt5_BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build")

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

set(QT_INSTALL_LOCATION "${EMsoft_SDK}/${extProjectName}${qt5_version_full}")

if(APPLE)
  set(qt5_Headless_FILE "Qt_HeadlessInstall_OSX.js")
elseif(WIN32)
  set(qt5_Headless_FILE "Qt_HeadlessInstall_Win64.js")
else()
  set(qt5_Headless_FILE "Qt_HeadlessInstall_OSX.js")
endif()

set(QT_MSVC_VERSION_NAME "")
if(MSVC13)
   set(QT_MSVC_VERSION_NAME "msvc2013_64")
endif()
if(MSVC14)
  set(QT_MSVC_VERSION_NAME "msvc2015_64")
endif()
if(MSVC15)
  set(QT_MSVC_VERSION_NAME "msvc2017_64")
endif()

set(JSFILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.js")
configure_file(
  "${_self_dir}/${qt5_Headless_FILE}"
  "${JSFILE}"
  @ONLY
)

if(APPLE)
  #set(qt5_url "http://qt.mirror.constant.com/archive/qt/${qt5_version_short}/${qt5_version_full}/qt-opensource-mac-x64-clang-${qt5_version_full}.dmg")

  set(qt5_url "http://qt.mirror.constant.com/archive/qt/5.9/5.9.2/qt-opensource-mac-x64-5.9.2.dmg")

  set(Qt5_OSX_BASE_NAME qt-opensource-mac-x64-${qt5_version_full})

  set(Qt5_OSX_DMG_ABS_PATH "${EMsoft_SDK}/superbuild/${extProjectName}/${Qt5_OSX_BASE_NAME}.dmg")
  set(Qt5_DMG ${Qt5_OSX_DMG_ABS_PATH})

  configure_file(
    "${_self_dir}/Qt5_osx_install.sh.in"
    "${CMAKE_BINARY_DIR}/Qt5_osx_install.sh"
    @ONLY
  )


  if(NOT EXISTS "${Qt5_DMG}")
    message(STATUS "===============================================================")
    message(STATUS "    Downloading ${extProjectName}${qt5_version_full} Offline Installer")
    message(STATUS "    ${qt5_url}")
    message(STATUS "    Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${Qt5_DMG}" SHOW_PROGRESS)
  endif()


  if(NOT EXISTS "${QT_INSTALL_LOCATION}/${qt5_version_short}/clang_64/bin/qmake")
    message(STATUS "    Running Qt5 Installer. A GUI Application will pop up on your machine.")
    message(STATUS "    This may take some time for the installer to start.")
    message(STATUS "    Please wait for the installer to finish.")
    execute_process(COMMAND "${CMAKE_BINARY_DIR}/Qt5_osx_install.sh"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt5-offline-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt5-offline-err.log"
                    ERROR_VARIABLE mount_error
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

  endif()
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/${qt5_version_short}/clang_64/bin/qmake)

elseif(WIN32)
  set(qt5_online_installer "qt-unified-windows-x86-2.0.3-online.exe")
  set(qt5_url "https://download.qt.io/archive/online_installers/2.0/${qt5_online_installer}")

  if(NOT EXISTS "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}${qt5_version_full}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}" SHOW_PROGRESS)
  endif()

  set(QT5_ONLINE_INSTALLER "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
  configure_file(
    "${_self_dir}/Qt_HeadlessInstall.bat"
    "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.bat"
    @ONLY
  )

  if(NOT EXISTS "${EMsoft_SDK}/${extProjectName}${qt5_version_full}")
    message(STATUS "Executing the Qt5 Installer... ")
    execute_process(COMMAND "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.bat"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-err.log"
                    ERROR_VARIABLE installer_error
                    WORKING_DIRECTORY ${qt5_BINARY_DIR} )
  endif()
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/${qt5_version_short}/${QT_MSVC_VERSION_NAME}/bin/qmake.exe)
else()
  
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/${qt5_version_short}/gcc_64/bin/qmake)
endif()


ExternalProject_Add(Qt5
    TMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/tmp/"
    STAMP_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Stamp/"
    DOWNLOAD_DIR ${EMsoft_SDK}/superbuild/${extProjectName}/Download
    SOURCE_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Source/"
    BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build/"
    INSTALL_DIR "${EMsoft_SDK}/${extProjectName}"

    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""
    )

#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure EMsoft for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# Qt ${qt5_version_full} Library\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${qt5_version_full}/${qt5_version_short}/clang_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${qt5_version_full}/${qt5_version_short}/${QT_MSVC_VERSION_NAME}/lib/cmake/Qt5\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${qt5_version_full}/${qt5_version_short}/gcc_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Qt5_DIR})\n")
FILE(APPEND ${EMsoft_SDK_FILE} "Check3rdPartyDir(DIR \${Qt5_DIR})\n")


