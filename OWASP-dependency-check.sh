#!/bin/sh

DC_VERSION="latest"
DC_DIRECTORY=$HOME/OWASP-Dependency-Check
DC_PROJECT="dependency-check scan: $(pwd)"
DATA_DIRECTORY="$DC_DIRECTORY/data"
CACHE_DIRECTORY="$DC_DIRECTORY/data/cache"

if [ ! -d "$DATA_DIRECTORY" ]; then
    echo "Initially creating persistent directory: $DATA_DIRECTORY"
    mkdir -p "$DATA_DIRECTORY"
fi
if [ ! -d "$CACHE_DIRECTORY" ]; then
    echo "Initially creating persistent directory: $CACHE_DIRECTORY"
    mkdir -p "$CACHE_DIRECTORY"
fi

# Make sure we are using the latest version
docker pull owasp/dependency-check:$DC_VERSION

docker run --rm \
    -e user=$USER \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    --volume $(pwd):/src \
    --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data \
    --volume $(pwd)/odc-reports:/report \
    owasp/dependency-check:$DC_VERSION \
    --scan /src \
    --log /report123/dc.log
    --format "ALL" \
    --project "$DC_PROJECT" \
    --out /report12
    # Use suppression like this: (where /src == $pwd)
    # --suppression "/src/security/dependency-check-suppression.xml"
