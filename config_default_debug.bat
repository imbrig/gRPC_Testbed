@ECHO ON

set BASEDIR=%~dp0
PUSHD %BASEDIR%

RMDIR /Q /S build

conan profile detect --force
conan install . --output-folder=./ --build=missing --settings=build_type=Debug
cmake --preset default -DCMAKE_BUILD_TYPE=Debug
