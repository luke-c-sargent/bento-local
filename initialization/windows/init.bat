@echo off
setlocal DISABLEDELAYEDEXPANSION

for /f "eol=# delims=" %%x in (..\..\.env) do (set "%%x")

where git >nul 2>nul
if %errorlevel% neq 0 (
    @echo ERROR: git is not found in your path. Please install git before running the initialization script.
	exit /b %errorlevel%
)

set /p USE_DEMO_DATA="use demo data [%USE_DEMO_DATA%]: "
set /p BACKEND_BRANCH="set bento-backend branch [%BACKEND_BRANCH%]: "
set /p FRONTEND_BRANCH="set bento-frontend branch [%FRONTEND_BRANCH%]: "
set /p MODEL_BRANCH="set bento-model branch [%MODEL_BRANCH%]: "

echo Cloning bento-backend repository:  %BACKEND_BRANCH% branch
IF EXIST ..\..\%BACKEND_SOURCE_FOLDER% (
echo The backend repository is already initialized in:  %BACKEND_SOURCE_FOLDER%. Please remove this folder and re-initialize the project.
) ELSE (
git clone -b %BACKEND_BRANCH% --single-branch https://github.com/CBIIT/bento-backend.git ..\..\%BACKEND_SOURCE_FOLDER%
)

echo Cloning bento-frontend repository:  %FRONTEND_BRANCH% branch
IF EXIST ..\..\%FRONTEND_SOURCE_FOLDER% (
echo The frontend repository is already initialized in:  %FRONTEND_SOURCE_FOLDER%. Please remove this folder and re-initialize the project.
) ELSE (
git clone -b %FRONTEND_BRANCH% --single-branch https://github.com/CBIIT/bento-frontend.git ..\..\%FRONTEND_SOURCE_FOLDER%
)

echo Cloning bento-model repository:  %MODEL_BRANCH% branch
IF EXIST ..\..\%BENTO_DATA_MODEL% (
echo The model repository is already initialized in:  %BENTO_DATA_MODEL%. Please remove this folder and re-initialize the project.
) ELSE (
git clone -b %MODEL_BRANCH% --single-branch https://github.com/CBIIT/bento-model.git ..\..\%BENTO_DATA_MODEL%
)

IF /I "%USE_DEMO_DATA%"=="yes" (
echo Seeding project with demo data
IF EXIST ..\..\data (
echo The bento-local project already has a data folder defined. Please remove this folder and re-initialize the project.
) ELSE (
robocopy ..\demo_data ..\..\data /E
)
)
