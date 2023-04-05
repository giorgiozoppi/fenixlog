list(APPEND YAML_FIND_INCLUDE_DIRS "/usr/include/yaml-cpp")
list(APPEND YAML_FIND_INCLUDE_DIRS "/usr/local/include/yaml-cpp")
list(APPEND YAML_FIND_LIB_FILES "/usr/lib/libyaml-cpp.a")
list(APPEND YAML_FIND_LIB_FILES "/usr/local/lib/libyaml-cpp.a")
list(APPEND YAML_FIND_LIBDEBUG_FILES "/usr/local/lib/libyaml-cppd.a")
list(APPEND YAML_FIND_LIBDEBUG_FILES "/usr/lib/libyaml-cppd.a")

foreach(YAML_INCLUDE_ITEM ${YAML_FIND_INCLUDE_DIRS})
if(EXISTS ${YAML_INCLUDE_ITEM}) 
set(YAMLCPP_INCLUDE_DIR ${YAML_INCLUDE_ITEM})
endif()
endforeach()

foreach(YAML_LIB_ITEM ${YAML_FIND_LIB_FILES})
if(EXISTS "${YAML_LIB_ITEM}") 
set(YAML_CPP_LIB ${YAML_LIB_ITEM})
endif()
endforeach()

foreach(YAML_LIB_ITEM ${YAML_FIND_LIBDEBUG_FILES})
if(EXISTS "${YAML_LIB_ITEM}") 
set(YAML_CPP_DEBUG_LIB ${YAML_LIB_ITEM})
endif()
endforeach()
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
set(YAMLCPP_LIBRARY ${YAML_CPP_DEBUG_LIB})
else()
set(YAMLCPP_LIBRARY ${YAML_CPP_LIB})
endif()


IF (YAMLCPP_LIBRARY AND YAMLCPP_INCLUDE_DIR)
    SET(YamlCpp_FOUND TRUE)
ENDIF (YAMLCPP_LIBRARY AND YAMLCPP_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(YamlCpp DEFAULT_MSG YAMLCPP_LIBRARY YAMLCPP_INCLUDE_DIR)
mark_as_advanced(YAMLCPP_LIBRARY YAMLCPP_INCLUDE_DIR)
