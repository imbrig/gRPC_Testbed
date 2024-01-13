# CMakeLists.txt

cmake_minimum_required(VERSION 3.10)
project(Testbed)

# Set the C++ standard to C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Conan public third-party packages
find_package(absl REQUIRED)
find_package(grpc REQUIRED)
find_package(protobuf REQUIRED)

# Add the source files from the root directory
file(GLOB HEADERS "*.h")
file(GLOB SOURCES "*.cpp" "*.cc")
source_group("" FILES ${HEADERS} ${SOURCES})

# Add the executable with the source files
add_executable(${PROJECT_NAME} ${HEADERS} ${SOURCES})

# Include directories for the target
target_include_directories(${PROJECT_NAME} PRIVATE ${absl_INCLUDE_DIRS} ${gRPC_INCLUDE_DIRS} ${protobuf_INCLUDE_DIRS})

# Link libraries
target_link_libraries(${PROJECT_NAME} PRIVATE ${absl_LIBRARIES} ${gRPC_LIBRARIES} ${protobuf_LIBRARIES})

# Include the custom gRPC_protobuf_generate_cpp function
include(generate_gRPC_protobuf.cmake)

# Try to generate the gRPC protobuf files here
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(grpc_BIN_DIR ${grpc_PACKAGE_FOLDER_DEBUG}/bin)
    set(protobuf_BIN_DIR ${protobuf_BIN_DIRS_DEBUG})
else()
    set(grpc_BIN_DIR ${grpc_PACKAGE_FOLDER_RELEASE}/bin)
    set(protobuf_BIN_DIR ${protobuf_BIN_DIRS_RELEASE})
endif()

# Add all .proto files in this project
#file(GLOB PROTO_FILES "*.proto")
set(PROTO_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/testbed.proto)

# Specify the output directory for proto generated files
set(PROTO_CPP_OUTPUT_DIR ${CMAKE_BINARY_DIR}/../proto_cpp)
set(PROTO_PY_OUTPUT_DIR ${CMAKE_BINARY_DIR}/../proto_py)

# Use the custom gRPC_protobuf_generate_cpp function for all .proto files, they will be added to the project
gRPC_protobuf_generate_cpp(${PROJECT_NAME} ${PROTO_CPP_OUTPUT_DIR} ${protobuf_BIN_DIR} ${grpc_BIN_DIR} ${PROTO_FILES})
# Use the custom gRPC_protobuf_generate_py function for all .proto files, these are for the python client
gRPC_protobuf_generate_py(${PROTO_PY_OUTPUT_DIR} ${protobuf_BIN_DIR} ${PROTO_FILES})
