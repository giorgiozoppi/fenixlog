set(VCPKG $ENV{HOME}/vcpkg/scripts/buildsystems/vcpkg.cmake)
set(NINJA /usr/bin/ninja)
if (EXISTS ${VCPKG})
    message(STATUS "Found VCPKG installation")
    set(CMAKE_TOOLCHAIN_FILE ${VCPKG}
            CACHE STRING "")
endif ()
cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
file(STRINGS "VERSION" VERSION_STRING)
project(fenixlog VERSION "${VERSION_STRING}" LANGUAGES CXX)
set(CMAKE_BUILD_TYPE_INIT Release)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(Boost_USE_STATIC_LIBS ON) 
set(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF) 
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
find_package(YamlCpp REQUIRED)
find_package(spdlog CONFIG REQUIRED)
find_package(unofficial-libuv CONFIG REQUIRED)
find_package(Boost "1.76.0" COMPONENTS system program_options) 
set(CMAKE_VERBOSE_MAKEFILE 0)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

include_directories(${CMAKE_SOURCE_DIR}/include)
file(GLOB_RECURSE INCLUDE_FILES ${CMAKE_SOURCE_DIR}/include/*.hpp)
file(GLOB_RECURSE SOURCE_FILES_NO_MAIN ${CMAKE_SOURCE_DIR}/src/*.cpp)
# for using catch we don't need the main
list(FILTER SOURCE_FILES_NO_MAIN EXCLUDE REGEX ".*main.cc$")
file(GLOB SOURCES ${CMAKE_SOURCE_DIR}/src/*.cc)
include(${CMAKE_SOURCE_DIR}/cmake/unit_test.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/clang_tools.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/cppcheck.cmake)

if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS})    
    message(STATUS  "Boost Found at ${Boost_INCLUDE_DIRS} ${Boost_LIBRARIES}")
endif()
if (YamlCpp_FOUND)
include_directories(${YAMLCPP_INCLUDE_DIR})

message(STATUS  "Yaml Found at ${YAMLCPP_LIBRARY} ${YAMLCPP_INCLUDE_DIR}")
endif()
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  # using Clang
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi")
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(fenixlog PRIVATE -Wall -Wextra -Werror -std=c++20 -stdlib=libc++ -fsanitize=address -fprofile-arcs -ftest-coverage -fno-omit-frame-pointer -v)
  else()
    target_compile_options(fenixlog PRIVATE -Wall -Wextra -Werror -std=c++20 -stdlib=libc++ -v)
  endif()
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  # using GCC
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  target_compile_options(fenixlog PRIVATE -Wall -Wextra -Werror -O0 -ggdb -fsanitize=address -fprofile-arcs -ftest-coverage)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lgcov -coverage")
  else()
  target_compile_options(fenixlog PRIVATE -Wall -Wextra -Werror -std=c++20)
  endif()
endif()
target_link_libraries(fenixlog PRIVATE ${Boost_LIBRARIES} ${YAMLCPP_LIBRARY} crypto ssl pthread spdlog::spdlog spdlog::spdlog_header_only unofficial::libuv::libuv)
enable_testing()
add_executable(fenixlog ${SOURCE_FILES_NO_MAIN} ${SOURCE_FILES_TEST})