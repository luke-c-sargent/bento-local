@echo off
setlocal DISABLEDELAYEDEXPANSION

REM // Get target directory for code checkouts
set REL_PATH=.
pushd %REL_PATH%
set ROOT_PATH=%CD%
popd

for /f "eol=# delims=" %%x in (%ROOT_PATH%\.env) do (set "%%x")

IF EXIST %ROOT_PATH% (
echo %ROOT_PATH%
echo Starting the Bento-Local containers.

cd %ROOT_PATH%
powershell -Command "& {docker-compose up -d}"

) ELSE (

@echo ERROR: The required directory is not found in your path.
pause
exit /b %errorlevel%

)
echo.
)

IF EXIST %ROOT_PATH% (

%SystemRoot%\explorer.exe "%ROOT_PATH%"

)

start chrome http://localhost:8085

REM // Hold the script open until the user quits
pause