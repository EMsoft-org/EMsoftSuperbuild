# This is the DREAM3D_SDK File. This file contains all the paths to the dependent libraries.
# This was generated for Version 6.3 Development of DREAM.3D. This SDK has C++11 Support ENABLED
if(NOT DEFINED DREAM3D_FIRST_CONFIGURE)
  message(STATUS "*******************************************************")
  message(STATUS "* DREAM.3D First Configuration Run                    *")
  message(STATUS "* DREAM3D_SDK Loading from ${CMAKE_CURRENT_LIST_DIR}  *")
  message(STATUS "*******************************************************")
  set(CMAKE_CXX_FLAGS "-std=c++11 -mfpmath=sse" CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD 11 CACHE STRING "" FORCE)
  set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE STRING "" FORCE)
endif()

#set(BrandedSIMPLView_DIR /home/${USER}/Workspace/BrandedDREAM3D)

#--------------------------------------------------------------------------------------------------
# These settings are specific to DREAM3D. DREAM3D needs these variables to
# configure properly.

set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

message(STATUS "The Current Build type being used is ${BUILD_TYPE}")
