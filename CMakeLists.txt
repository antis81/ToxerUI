project(ToxerDesktop)
cmake_minimum_required (VERSION 3.5)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_MODULE_PATH ${ToxerDesktop_SOURCE_DIR}/cmake;${CMAKE_MODULE_PATH} CACHE STRING "CMake modules search path")
set(QML_IMPORT_PATH "${ToxerDesktop_SOURCE_DIR}/qml" CACHE STRING "Qt Creator extra qml import paths")

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# setup version string
find_package(Git)
if(GIT_FOUND)
    execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags --long --always --dirty=-d
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        RESULT_VARIABLE git_result
        OUTPUT_VARIABLE PROJECT_REVISION
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_VARIABLE git_err
        )
    if (git_result EQUAL 0)
        message(STATUS "Toxer Git-Hash: ${PROJECT_REVISION}")
    else()
        message(FATAL_ERROR "Git error: ${git_err}")
    endif()
endif()
if(NOT PROJECT_REVISION)
    set(PROJECT_REVISION "DEVBUILD")
endif()
add_definitions(-DTOXER_VERSION="${PROJECT_REVISION}")

find_package (Qt5 COMPONENTS Core Network Qml Gui Quick REQUIRED)
find_package (sodium REQUIRED)

#file (GLOB_RECURSE SCRIPTS "scripts/*.*")
#add_custom_target(scripts SOURCES ${SCRIPTS})

qt5_add_resources(RESOURCES
  ${ToxerDesktop_SOURCE_DIR}/res/res.qrc
  ${ToxerDesktop_SOURCE_DIR}/qml/qml.qrc)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions -fno-rtti")
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

add_subdirectory (lib)
add_subdirectory(ToxerCore)

find_library(TOX_CORE toxcore REQUIRED)

file (GLOB_RECURSE JS_FILES "qml/*.js")
add_custom_target(js_files SOURCES ${JS_FILES})

file (GLOB_RECURSE QML_FILES "qml/*.qml")
add_custom_target(qml_files SOURCES ${QML_FILES})

file (GLOB_RECURSE QMLDIR_FILES "qml/*qmldir")
add_custom_target(qmldir_files SOURCES ${QMLDIR_FILES})

add_executable(toxer
  src/main.cpp
  ${RESOURCES}
  )
set_property (TARGET toxer APPEND PROPERTY COMPILE_DEFINITIONS
  QT_NO_CAST_FROM_ASCII
  QT_NO_CAST_TO_ASCII
  QT_NO_CAST_FROM_BYTEARRAY
  )
target_include_directories (toxer PRIVATE
  $<BUILD_INTERFACE:
  ${ToxerDesktop_SOURCE_DIR}/ToxerCore/src
  >)

target_link_libraries (toxer
  Qt5::Quick
  toxercore
  ${TOX_CORE}
  sodium
  )

install(TARGETS toxer
  RUNTIME DESTINATION bin COMPONENT Runtime
  LIBRARY DESTINATION lib COMPONENT Runtime
  )
