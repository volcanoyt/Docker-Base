#!/bin/bash

declare -a gbulid=("node-pm2-alpine" "novnc-alpine" "icecast-alpine" "novnc-ubuntu" "php-alpine" "ffmpeg-snapshot-alpine")
whatuse="abc"

echo "Let's build :)"
gonline="no"

bulid()
{
  echo "Start build..."
  for i in "${gbulid[@]}";
  do 
    if [[ $whatuse == *"$i"* ]]; then

     echo "$i...."
     cd "$i" || exit;
     docker build -t "repo.volcanoyt.com/base_$i" -f Dockerfile .
     cd ..
    
     if [[ $gonline == *"yes"* ]]; then
      echo "Start push to our server"
      docker push repo.volcanoyt.com/base_"$i"
     fi

    else
     echo "Skip $i"
    fi
  done
}

tes()
{
  echo "Start Tes Mode..."
  for i in "${gbulid[@]}";
  do 
    if [[ $whatuse == *"$i"* ]]; then

     bulid

     if [[ $whatuse == *"novnc-alpine"* ]]; then
      docker run --rm -it  -p 5901:5901/tcp -p 6080:6080/tcp repo.volcanoyt.com/base_novnc-alpine:latest
     fi

    else
     echo "Skip $i"
    fi
  done
}

push()
{
  echo "Start push..."
  for i in "${gbulid[@]}";
  do 
    if [[ $whatuse == *"$i"* ]]; then

     echo "$i...."
     docker push repo.volcanoyt.com/base_"$i"

    else
     echo "Skip $i"
    fi
  done
}

if [ $# -eq 0 ]; then
  echo "Type build like bash run.sh bulid etc,etc,etc"
else

  tmpuse="$2"
  if [ -n "$tmpuse" ]
  then
      whatuse="$tmpuse"
  fi
  
  gonline="$3"   
  case $1 in bulid|push|tes)
    $1
    ;;
  esac
fi