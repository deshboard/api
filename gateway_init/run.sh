#!/bin/sh

BASEDIR=$(dirname "$0")

for f in $BASEDIR/apis/*.json
do
	curl -XPUT $KONG_ADMIN_API/apis/ -H "Content-Type: application/json" -d @$f
done

for f in $BASEDIR/plugins/*.json
do
	curl -XPUT $KONG_ADMIN_API/plugins/ -H "Content-Type: application/json" -d @$f
done
