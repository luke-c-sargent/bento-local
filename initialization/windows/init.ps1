$projectPath = (Resolve-Path -Path  "..\..\").path
$configFile = "$projectPath\.env"

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
    write-host "ERROR: git is not found in your path. Please install git before running the initialization script."
	exit
}

$user_data = Read-Host -Prompt "use demo data [$($properties.USE_DEMO_DATA)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.USE_DEMO_DATA = $user_data }
$user_data = Read-Host -Prompt "set bento-frontend branch [$($properties.BACKEND_BRANCH)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.BACKEND_BRANCH = $user_data }
$user_data = Read-Host -Prompt "set bento-frontend branch [$($properties.FRONTEND_BRANCH)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.FRONTEND_BRANCH = $user_data }
$user_data = Read-Host -Prompt "set bento-model branch [$($properties.MODEL_BRANCH)]"; if (!([string]::IsNullOrWhiteSpace($user_data))) { $properties.MODEL_BRANCH = $user_data }
write-host

if ( Test-Path -Path "$projectPath\$($properties.BACKEND_SOURCE_FOLDER)" ) {
  write-host "The backend repository is already initialized in:  $projectPath\$($properties.BACKEND_SOURCE_FOLDER). Please remove this folder and re-initialize the project."
  write-host
  } else {
    write-host "Cloning bento-backend repository:  $($properties.BACKEND_BRANCH) branch"
	git clone -qb $($properties.BACKEND_BRANCH) --single-branch https://github.com/CBIIT/bento-backend.git $projectPath\$($properties.BACKEND_SOURCE_FOLDER)
	if ( $lastexitcode -ne 0 ) {
	  write-host "ERROR CREATING BACKEND SOURCE FOLDER: $projectPath\$($properties.BACKEND_SOURCE_FOLDER) - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE BUILDING BENTO-LOCAL"
	  } else {
	      write-host "Created backend source folder: $projectPath\$($properties.BACKEND_SOURCE_FOLDER)"
	      }
	write-host
    }

if ( Test-Path -Path "$projectPath\$($properties.FRONTEND_SOURCE_FOLDER)" ) {
  write-host "The frontend repository is already initialized in:  $projectPath\$($properties.FRONTEND_SOURCE_FOLDER). Please remove this folder and re-initialize the project."
  write-host
  } else {
    write-host "Cloning bento-frontend repository:  $($properties.FRONTEND_BRANCH) branch"
	git clone -qb $($properties.FRONTEND_BRANCH) --single-branch https://github.com/CBIIT/bento-frontend.git $projectPath\$($properties.FRONTEND_SOURCE_FOLDER)
	if ( $lastexitcode -ne 0 ) {
	  write-host "ERROR CREATING FRONTEND SOURCE FOLDER: $projectPath\$($properties.FRONTEND_SOURCE_FOLDER) - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE BUILDING BENTO-LOCAL"
	  } else {
	      write-host "Created frontend source folder: $projectPath\$($properties.FRONTEND_SOURCE_FOLDER)"
	      }
	write-host
    }

if ( Test-Path -Path "$projectPath\$($properties.BENTO_DATA_MODEL)" ) {
  write-host "The data model repository is already initialized in:  $projectPath\$($properties.BENTO_DATA_MODEL). Please remove this folder and re-initialize the project."
  write-host
  } else {
    write-host "Cloning bento-model repository:  $($properties.MODEL_BRANCH) branch"
	git clone -qb $($properties.MODEL_BRANCH) --single-branch https://github.com/CBIIT/BENTO-TAILORx-model.git $projectPath\$($properties.BENTO_DATA_MODEL)
	if ( $lastexitcode -ne 0 ) {
	  write-host "ERROR CREATING BENTO MODEL FOLDER: $projectPath\$($properties.BENTO_DATA_MODEL) - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE RUNNING THE BENTO DATALOADER"
	  } else {
	      write-host "Created model folder: $projectPath\$($properties.BENTO_DATA_MODEL)"
	      }
	write-host
    }

if ( $($properties.USE_DEMO_DATA) -eq "yes" ) {

  if ( Test-Path -Path "$projectPath\data" ) {
    write-host "The bento-local project already has a data folder defined at $projectPath\data. Please remove this folder and re-initialize the project."
	write-host
    } else {
      write-host "Seeding project with demo data"
	  robocopy ..\demo_data $projectPath\data /E | Out-Null
	  if ( $lastexitcode -gt 7 ) {
        write-host "ERROR CREATING DATA FOLDER: $projectPath\data - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE RUNNING THE BENTO DATALOADER"
		write-host
        } else {
            write-host "Created data folder: $projectPath\data"
	        write-host
            }
		}

  } else {
  
      if ( Test-Path -Path "$projectPath\data" ) {
        write-host "The bento-local project already has a data folder defined. Please remove this folder and re-initialize the project."
	    write-host
        } else {
          $null = New-Item $projectPath\data -ItemType directory
	      if ( $lastexitcode -ne 0 ) {
            write-host "ERROR CREATING DATA FOLDER: $projectPath\data - PLEASE VERIFY THAT THIS FOLDER EXISTS BEFORE RUNNING THE BENTO DATALOADER"
		    write-host
            } else {
	          write-host "Created data folder: $projectPath\data - this folder should be populated with data prior to running the bento dataloader."
	          write-host
              }

          }
      }
	  
Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
