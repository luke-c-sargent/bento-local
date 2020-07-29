@echo off
setlocal DISABLEDELAYEDEXPANSION

for /f "delims=" %%x in (..\default.conf) do (set "%%x")

where git >nul 2>nul
if %errorlevel% neq 0 (
    @echo ERROR: git is not found in your path. Please install git before running the initialization script.
	exit /b %errorlevel%
)

set /p project="set project: [%project%] "
set /p use_demo_data="use demo data: [%use_demo_data%] "
set /p backend_branch="set bento-backend branch: [%backend_branch%] "
set /p frontend_branch="set bento-frontend branch: [%frontend_branch%] "
set /p model_branch="set bento-model branch: [%model_branch%] "

echo Cloning bento-backend repo for %project%:  %backend_branch% branch
IF EXIST ..\..\%project%\bento-backend (
echo The backend repository is already initialized in:  %project%\bento-backend. Please remove this folder and re-initialize the project.
) ELSE (
git clone -b %backend_branch% --single-branch https://github.com/CBIIT/bento-backend.git ..\..\%project%\bento-backend
)

echo Cloning bento-frontend repository for %project%:  %frontend_branch% branch
IF EXIST ..\..\%project%\bento-frontend (
echo The frontend repository is already initialized in:  %project%\bento-frontend. Please remove this folder and re-initialize the project.
) ELSE (
git clone -b %frontend_branch% --single-branch https://github.com/CBIIT/bento-frontend.git ..\..\%project%\bento-frontend
)

echo Cloning bento-model repository for %project%:  %model_branch% branch
IF EXIST ..\..\%project%\bento-model (
echo The model repository is already initialized in:  %project%\bento-model. Please remove this folder and re-initialize the project.
) ELSE (
git clone -b %model_branch% --single-branch https://github.com/CBIIT/bento-model.git ..\..\%project%\bento-model
)

IF /I "%use_demo_data%"=="yes" (
echo Seeding %project% with demo data
IF EXIST ..\..\%project%\data (
echo The %project% project already has a data folder defined. Please remove this folder and re-initialize the project.
) ELSE (
robocopy ..\..\demo_data ..\..\%project%\data /E
)
)



