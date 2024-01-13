gRPC_Testbed

Install Prerequisites:
Visual Studio 2019
Conan ~2.0.9
Cmake ~3.27.3
Python ~3.11.7
pip install grpcio
pip install grpcio-tools
pip install --pre "betterproto[compiler]"

Run the `config_default_debug.bat` for debug or `config_default_release.bat` for release. All generated code from the proto files should be in the build folder under `proto_cpp` and `proto_py`, the cpp files will be added to the project by the cmake config script.