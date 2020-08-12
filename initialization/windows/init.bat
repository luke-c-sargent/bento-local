@echo off
setlocal DISABLEDELAYEDEXPANSION

REM // Get target directory for code checkouts
set REL_PATH=..\..\
pushd %REL_PATH%
set ROOT_PATH=%CD%
popd

for /f "eol=# delims=" %%x in (%ROOT_PATH%\.env) do (set "%%x")

where git >nul 2>nul
if %errorlevel% neq 0 (
    @echo ERROR: git is not found in your path. Please install git before running the initialization script.
	pause
	exit /b %errorlevel%
)

set /p USE_DEMO_DATA="use demo data [%USE_DEMO_DATA%]: "
set /p BACKEND_BRANCH="set bento-backend branch [%BACKEND_BRANCH%]: "
set /p FRONTEND_BRANCH="set bento-frontend branch [%FRONTEND_BRANCH%]: "
set /p MODEL_BRANCH="set bento-model branch [%MODEL_BRANCH%]: "
echo.

IF EXIST %ROOT_PATH%\%BACKEND_SOURCE_FOLDER% (
echo The backend repository is already initialized in:  %ROOT_PATH%\%BACKEND_SOURCE_FOLDER%. Please remove this folder and re-initialize the project.
) ELSE (
echo Cloning bento-backend repository:  %BACKEND_BRANCH% branch
git clone -b %BACKEND_BRANCH% --single-branch https://github.com/CBIIT/bento-backend.git %ROOT_PATH%\%BACKEND_SOURCE_FOLDER% >nul 2>&1
IF ERRORLEVEL 1 (
echo ERROR CREATING BACKEND SOURCE FOLDER: %ROOT_PATH%\%BACKEND_SOURCE_FOLDER% - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE BUILDING BENTO-LOCAL
) ELSE (
echo Created backend source folder: %ROOT_PATH%\%BACKEND_SOURCE_FOLDER%
)
echo.
)

>nul 2>&1 dir /a-d %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER% && (set EMPTY_DIR=0) || (set EMPTY_DIR=1)

IF EXIST %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER% (
IF %EMPTY_DIR% == 0 (
set FRONT_INIT=1 
) ELSE (
set FRONT_INIT=0
)
) ELSE (
set FRONT_INIT=0
)

IF %FRONT_INIT% == 1 (
echo The frontend repository is already initialized in:  %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER%. Please remove this folder and re-initialize the project.
) ELSE (
echo Cloning bento-frontend repository:  %FRONTEND_BRANCH% branch
IF EXIST %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER% ( rmdir /s /q %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER% ) 
git clone -b %FRONTEND_BRANCH% --single-branch https://github.com/CBIIT/bento-frontend.git %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER% >nul 2>&1
IF ERRORLEVEL 1 (
echo ERROR CREATING FRONTEND SOURCE FOLDER: %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER% - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE BUILDING BENTO-LOCAL
) ELSE (
echo Created frontend source folder: %ROOT_PATH%\%FRONTEND_SOURCE_FOLDER%
)
echo.
)

IF EXIST %ROOT_PATH%\%BENTO_DATA_MODEL% (
echo The model repository is already initialized in:  %ROOT_PATH%\%BENTO_DATA_MODEL%. Please remove this folder and re-initialize the project.
) ELSE (
echo Cloning bento-model repository:  %MODEL_BRANCH% branch
git clone -b %MODEL_BRANCH% --single-branch https://github.com/CBIIT/BENTO-TAILORx-model.git %ROOT_PATH%\%BENTO_DATA_MODEL% >nul 2>&1
IF ERRORLEVEL 1 (
echo ERROR CREATING MODEL SOURCE FOLDER: %ROOT_PATH%\%BENTO_DATA_MODEL% - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE RUNNING THE BENTO DATALOADER
) ELSE (
echo Created model folder: %ROOT_PATH%\%BENTO_DATA_MODEL%
)
echo.
)

IF /I "%USE_DEMO_DATA%"=="yes" (
IF EXIST %ROOT_PATH%\data (
echo The bento-local project already has a data folder defined at %ROOT_PATH%\data. Please remove this folder and re-initialize the project.
) ELSE (
echo Seeding project with demo data
robocopy ..\demo_data %ROOT_PATH%\data /E >nul 2>&1
IF %ERRORLEVEL% GTR 7 (
echo ERROR CREATING DATA FOLDER: %ROOT_PATH%\data - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE RUNNING THE BENTO DATALOADER
) ELSE (
echo Created data folder: %ROOT_PATH%\data
)
)
) ELSE (
IF EXIST %ROOT_PATH%\data (
echo The bento-local project already has a data folder defined. Please remove this folder and re-initialize the project.
) ELSE (
mkdir %ROOT_PATH%\data >nul 2>&1
IF ERRORLEVEL 1 (
echo ERROR CREATING DATA FOLDER: %ROOT_PATH%\data - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE RUNNING THE BENTO DATALOADER
) ELSE (
echo Created data folder: %ROOT_PATH%\data - this folder should be populated with data prior to running the bento dataloader.
)
)
)

REM // Hold the script open until the user quits
pause