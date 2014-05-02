#!/bin/bash
[[ $QUERY_STRING =~ 'zip' ]] && zip=/vsizip
echo "Content-Type: application/json"
echo ""
ogr2ogr -f geojson /vsistdout/ ${zip}/vsicurl/$QUERY_STRING
