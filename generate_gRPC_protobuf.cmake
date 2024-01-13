# generate_gRPC_protobuf.cmake

function(gRPC_protobuf_generate_cpp TARGET ROOT_OUTPUT_DIR protobuf_BIN_DIR grpc_BIN_DIR)
    # Extract the list of .proto files from the remaining arguments
    set(PROTO_FILES "${ARGN}")

    # Process each passed proto file
    foreach(PROTO_FILE ${PROTO_FILES})
        # Check if the "output" subfolder exists, and create it if not
        get_filename_component(BASENAME ${PROTO_FILE} NAME_WE)
        set(OUTPUT_DIR ${ROOT_OUTPUT_DIR}/${BASENAME})
        if(NOT EXISTS ${OUTPUT_DIR})
            make_directory(${OUTPUT_DIR})
        endif()

        # Define the command to run protoc.exe
        set(PROTOC_COMMAND
            ${protobuf_BIN_DIR}/protoc.exe
            --proto_path=${CMAKE_CURRENT_SOURCE_DIR}
            --cpp_out=${OUTPUT_DIR}
            --grpc_out=${OUTPUT_DIR}
            --plugin=protoc-gen-grpc=${grpc_BIN_DIR}/grpc_cpp_plugin.exe
            ${PROTO_FILE})

        # Execute the protoc command
        set(PROTOC_RESULT)
        execute_process(COMMAND ${PROTOC_COMMAND} RESULT_VARIABLE PROTOC_RESULT)

        # Check the result of the execution
        if(PROTOC_RESULT)
            message(FATAL_ERROR "Failed to run protoc.exe on ${PROTO_FILE}! Exit code: ${PROTOC_RESULT}")
        else()
            # Add generated files directly to the lists
            file(GLOB PROTO_H_FILES ${OUTPUT_DIR}/*.pb.h)
            file(GLOB PROTO_CC_FILES ${OUTPUT_DIR}/*.pb.cc)
            # Add to the IDE folder, the output folder to the includes, and add the files to the target sources
            source_group("${BASENAME}_proto" FILES ${PROTO_H_FILES} ${PROTO_CC_FILES})
            target_include_directories(${TARGET} PRIVATE ${OUTPUT_DIR})
            target_sources(${TARGET} PRIVATE ${PROTO_CC_FILES} ${PROTO_H_FILES})
        endif()
    endforeach()
endfunction()

function(gRPC_protobuf_generate_py OUTPUT_DIR protobuf_BIN_DIR)
    # Extract the list of .proto files from the remaining arguments
    set(PROTO_FILES "${ARGN}")

    # Process each passed proto file
    foreach(PROTO_FILE ${PROTO_FILES})
        # Check if the "output" subfolder exists, and create it if not
        get_filename_component(BASENAME ${PROTO_FILE} NAME_WE)
        if(NOT EXISTS ${OUTPUT_DIR})
            make_directory(${OUTPUT_DIR})
        endif()

        # Define the command to run protoc.exe
        set(PROTOC_COMMAND
            ${protobuf_BIN_DIR}/protoc.exe
            --proto_path=${CMAKE_CURRENT_SOURCE_DIR}
            --python_betterproto_out=${OUTPUT_DIR}
            ${PROTO_FILE})

        # Execute the protoc command
        set(PROTOC_RESULT)
        execute_process(COMMAND ${PROTOC_COMMAND} RESULT_VARIABLE PROTOC_RESULT)

        # Check the result of the execution
        if(PROTOC_RESULT)
            message(FATAL_ERROR "Failed to run protoc.exe on ${PROTO_FILE}! Exit code: ${PROTOC_RESULT}")
        endif()
    endforeach()
endfunction()
