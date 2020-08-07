#/bin/sh

configfile="../../.env"

while IFS='=' read -r key value; do
  if [[ !( -z "${key}") ]]; then
    eval ${key}=\${value}
  fi
done < "$configfile"

if ! command -v git &> /dev/null
then
    echo "ERROR: git is not found in your path. Please install git before running the initialization script."
    exit
fi

read -p "use demo data [default=$USE_DEMO_DATA]: " user_data
  : ${user_data:=$USE_DEMO_DATA}; USE_DEMO_DATA=$user_data
read -p "set bento-backend branch [default=$BACKEND_BRANCH]: " user_data
  : ${user_data:=$BACKEND_BRANCH}; BACKEND_BRANCH=$user_data
read -p "set bento-frontend branch [default=$FRONTEND_BRANCH]: " user_data
  : ${user_data:=$FRONTEND_BRANCH}; FRONTEND_BRANCH=$user_data
read -p "set bento-model branch [default=$MODEL_BRANCH]: " user_data
  : ${user_data:=$MODEL_BRANCH}; MODEL_BRANCH=$user_data


if [[ -d "../../$BACKEND_SOURCE_FOLDER" ]]
then
  echo "The backend repository is already initialized in:  $BACKEND_SOURCE_FOLDER. Please remove this folder and re-initialize the project."
else
  echo "Cloning bento-backend repository:  $BACKEND_BRANCH branch"
  git clone -b "$BACKEND_BRANCH" --single-branch https://github.com/CBIIT/bento-backend.git "../../$BACKEND_SOURCE_FOLDER"
fi

if [[ -d "../../$FRONTEND_SOURCE_FOLDER" ]]
then
  echo "The frontend repository is already initialized in:  $FRONTEND_SOURCE_FOLDER. Please remove this folder and re-initialize the project."
else
  echo "Cloning bento-frontend repository:  $FRONTEND_BRANCH branch"
  git clone -b "$FRONTEND_BRANCH" --single-branch https://github.com/CBIIT/bento-frontend.git "../../$FRONTEND_SOURCE_FOLDER"
fi

if [[ -d "../../$BENTO_DATA_MODEL" ]]
then
  echo "The bento-model repository is already initialized in:  $BENTO_DATA_MODEL. Please remove this folder and re-initialize the project."
else
  echo "Cloning bento-model repository:  $MODEL_BRANCH branch"
  git clone -b "$MODEL_BRANCH" --single-branch https://github.com/CBIIT/BENTO-TAILORx-model.git "../../$BENTO_DATA_MODEL"
fi

if [[ $USE_DEMO_DATA == "yes" ]]
then
  if [[ -d "../../data" ]]
  then
    echo "The bento-local project already has a data folder defined. Please remove this folder and re-initialize the project."
  else
    echo Seeding project with demo data
	cp -R ../demo_data ../../data
  fi
else
mkdir ../../data
fi