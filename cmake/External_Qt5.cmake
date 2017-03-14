set(extProjectName "Qt")
message(STATUS "External Project: ${extProjectName}" )
set(qt5_version "5.6.2")
set(qt5_url "http://qt.mirror.constant.com/archive/qt/5.6/${qt5_version}-2/qt-opensource-mac-x64-clang-${qt5_version}-2.dmg")
set(qt5_INSTALL "${EMsoft_SDK}/${extProjectName}${qt5_version}")
set(qt5_BINARY_DIR "${EMsoft_SDK}/superbuild/${extProjectName}/Build")

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

set(QT_INSTALL_LOCATION "${EMsoft_SDK}/${extProjectName}${qt5_version}")

if(APPLE)
  set(qt5_Headless_FILE "Qt_HeadlessInstall_OSX.js")
elseif(WIN32)
  set(qt5_Headless_FILE "Qt_HeadlessInstall_Win64.js")
else()
  set(qt5_Headless_FILE "Qt_HeadlessInstall_OSX.js")
else()

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
  set(Qt5_OSX_BASE_NAME qt-opensource-mac-x64-clang-${qt5_version})

  set(Qt5_OSX_DMG_ABS_PATH "${EMsoft_SDK}/superbuild/${extProjectName}/${Qt5_OSX_BASE_NAME}-1.dmg")
  set(Qt5_DMG ${Qt5_OSX_DMG_ABS_PATH})

  configure_file(
    "${_self_dir}/Qt5_osx_install.sh.in"
    "${CMAKE_BINARY_DIR}/Qt5_osx_install.sh"
    @ONLY
  )


  if(NOT EXISTS "${Qt5_DMG}")
    message(STATUS "===============================================================")
    message(STATUS "    Downloading ${extProjectName}${qt5_version} Offline Installer")
    message(STATUS "    Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${Qt5_DMG}" SHOW_PROGRESS)
  endif()


  if(NOT EXISTS "${QT_INSTALL_LOCATION}/5.6/clang_64/bin/qmake")
    message(STATUS "    Running Qt5 Offline Installer. A GUI Application will pop up on your machine.")
    message(STATUS "    Please wait for the installer to finish.")
    execute_process(COMMAND "${CMAKE_BINARY_DIR}/Qt5_osx_install.sh"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt5-offline-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt5-offline-err.log"
                    ERROR_VARIABLE mount_error
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )

  endif()
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/5.6/clang_64/bin/qmake)

elseif(WIN32)
  set(qt5_online_installer "qt-unified-windows-x86-2.0.3-online.exe")
  set(qt5_url "https://download.qt.io/archive/online_installers/2.0/${qt5_online_installer}")

  if(NOT EXISTS "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}${qt5_version}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}" SHOW_PROGRESS)
  endif()

  set(QT5_ONLINE_INSTALLER "${EMsoft_SDK}/superbuild/${extProjectName}/Download/${qt5_online_installer}")
  configure_file(
    "${_self_dir}/Qt_HeadlessInstall.bat"
    "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.bat"
    @ONLY
  )

  if(NOT EXISTS "${EMsoft_SDK}/${extProjectName}${qt5_version}")
    message(STATUS "Executing the Qt5 Installer... ")
    execute_process(COMMAND "${EMsoft_SDK}/superbuild/${extProjectName}/Download/Qt_HeadlessInstall.bat"
                    OUTPUT_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-out.log"
                    ERROR_FILE "${EMsoft_SDK}/superbuild/${extProjectName}/Download/qt-unified-err.log"
                    ERROR_VARIABLE installer_error
                    WORKING_DIRECTORY ${qt5_BINARY_DIR} )
  endif()
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/5.6/${QT_MSVC_VERSION_NAME}/bin/qmake.exe)
else()
  
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/5.6/gcc_64/bin/qmake)
endif()

#-- Append this information to the EMsoft_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${EMsoft_SDK_FILE} "\n")
FILE(APPEND ${EMsoft_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${EMsoft_SDK_FILE} "# Qt ${qt5_version} Library\n")
if(APPLE)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${qt5_version}/5.6/clang_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${qt5_version}/5.6/${QT_MSVC_VERSION_NAME}/lib/cmake/Qt5\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${EMsoft_SDK_FILE} "set(Qt5_DIR \"\${EMsoft_SDK_ROOT}/${extProjectName}${qt5_version}/5.6/gcc_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${EMsoft_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Qt5_DIR})\n")


