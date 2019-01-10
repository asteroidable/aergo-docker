TAG=$1
if [ -z "$TAG" ]
then
    echo "Usage:"
    echo "  build.sh tag [--latest]"
    echo "Example:"
    echo "  build.sh 0.9.9 --latest"
    exit 1
fi

GIT_TAG=v$TAG

if [ "$2" = "--latest" ]
then
    LATEST=true
else
    LATEST=false
fi

MAJOR_TAG=$(echo "$TAG" | sed -e 's/\.[0-9]*$//')

echo "Building Docker images for $TAG using git tag $GIT_TAG"
if $LATEST
then
    echo "Also building 'latest' tag"
fi

sleep 1

if $LATEST
then
    declare -a tags=("$TAG" "$MAJOR_TAG" "latest")
else
    declare -a tags=("$TAG" "$MAJOR_TAG")
fi

declare -a names=("node" "tools" "polaris")
for name in "${names[@]}"
do
    for tag in "${tags[@]}"
    do
        echo "[aergo/$name:$tag]"
        docker build --build-arg GIT_TAG=v$TAG -t aergo/$name:$tag $name >/tmp/dockerbuild 2>&1 &
        PROC_ID=$!
        echo -n "Build started"
        LAST_STEP=""
        while kill -0 "$PROC_ID" >/dev/null 2>&1; do  
            STEP=$(grep Step /tmp/dockerbuild | tail -1)
            [[ $STEP != $LAST_STEP && $STEP = *[$' \t\n']* ]] && echo -n -e "\033[0K\r$STEP"
            LAST_STEP=$STEP
        done
        echo -e "\r\033[0KDone"
    done
done

echo "REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE"
for name in "${names[@]}"
do
    for tag in "${tags[@]}"
    do
        docker images aergo/$name:$tag | tail -1
    done
done

echo "You can now push these to Docker Hub."
echo "For example:"

declare -a names=("node" "tools" "polaris")
for name in "${names[@]}"
do
    echo "  docker push aergo/$name:$TAG"
    echo "  docker push aergo/$name:$MAJOR_TAG"
    if $LATEST
    then
        echo "  docker push aergo/$name:latest"
    fi
done

