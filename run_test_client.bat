@ECHO OFF

set BASEDIR=%~dp0
PUSHD %BASEDIR%

python .\testbed_client.py
