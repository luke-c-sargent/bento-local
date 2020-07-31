$configFile = "..\..\.env"

$properties = @{}

# Read properties from .env
foreach($line in (Get-Content -Path $configFile | Where {$_ -notmatch '^#.*'} | Where { $_.Trim() -ne '' })) {
  $words = $line.Split('=',2)
  $properties.add($words[0].Trim(), $words[1].Trim())
  }

# Test whether Git is installed and available on the system's path. This is required for the script to run
try
{
    git | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException]
{
    echo "ERROR: git is not found in your path. Please install git before running the initialization script."
	exit
}

$user_data = Read-Host -Prompt "use demo data [$($properties.USE_DEMO_DATA)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.USE_DEMO_DATA = $user_data }
$user_data = Read-Host -Prompt "set bento-frontend branch [$($properties.BACKEND_BRANCH)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.BACKEND_BRANCH = $user_data }
$user_data = Read-Host -Prompt "set bento-frontend branch [$($properties.FRONTEND_BRANCH)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.FRONTEND_BRANCH = $user_data }
$user_data = Read-Host -Prompt "set bento-model branch [$($properties.MODEL_BRANCH)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.MODEL_BRANCH = $user_data }

if ( Test-Path -Path "..\..\$($properties.BACKEND_SOURCE_FOLDER)" ) {
  echo "The backend repository is already initialized in:  $($properties.BACKEND_SOURCE_FOLDER). Please remove this folder and re-initialize the project."
  } else {
    echo "Cloning bento-backend repository:  $($properties.BACKEND_BRANCH) branch"
	git clone -b $($properties.BACKEND_BRANCH) --single-branch https://github.com/CBIIT/bento-backend.git ..\..\$($properties.BACKEND_SOURCE_FOLDER)
    }

if ( Test-Path -Path "..\..\$($properties.FRONTEND_SOURCE_FOLDER)" ) {
  echo "The frontend repository is already initialized in:  $properties.FRONTEND_SOURCE_FOLDER. Please remove this folder and re-initialize the project."
  } else {
    echo "Cloning bento-frontend repository:  $($properties.FRONTEND_BRANCH) branch"
	git clone -b $($properties.FRONTEND_BRANCH) --single-branch https://github.com/CBIIT/bento-frontend.git ..\..\$($properties.FRONTEND_SOURCE_FOLDER)
    }

if ( Test-Path -Path "..\..\$($properties.BENTO_DATA_MODEL)" ) {
  echo "The data model repository is already initialized in:  $properties.BENTO_DATA_MODEL. Please remove this folder and re-initialize the project."
  } else {
    echo "Cloning bento-model repository:  $($properties.MODEL_BRANCH) branch"
	git clone -b $($properties.MODEL_BRANCH) --single-branch https://github.com/CBIIT/bento-model.git ..\..\$($properties.BENTO_DATA_MODEL)
    }

if ( $($properties.USE_DEMO_DATA) -eq "yes" ) {
  if ( Test-Path -Path "..\..\data" ) {
    echo "The bento-local project already has a data folder defined. Please remove this folder and re-initialize the project."
    } else {
      echo "Seeding project with demo data"
	  robocopy ..\demo_data ..\..\data /E
      }
  }
