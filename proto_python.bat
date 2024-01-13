@ECHO ON

set BASEDIR=%~dp0
PUSHD %BASEDIR%

@REM python -m grpc_tools.protoc -I. --python_out=./python_proto --grpc_python_out=./python_proto testbed.proto
@REM python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. testbed.proto
@REM python -m grpc_tools.protoc -I. --python_out=. --python_betterproto_out=. --grpc_python_out=. testbed.proto

@REM python -m grpc_tools.protoc -I. --python_betterproto_out=. testbed.proto

C:\Users\brigido\.conan2\p\proto5ab71c9c8fe99\p\bin\protoc.exe -I. --python_betterproto_out=./build/proto_py testbed.proto