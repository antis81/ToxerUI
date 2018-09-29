#!/bin/sh
set -e

scriptdir=$(dirname `readlink -f $0`)
toxer="${scriptdir}/ToxerCore"
toxer_version='sfos'
toxer_url=https://gitlab.com/antis81/Toxer
toxer_archive=Toxer-$toxer_version.tar.bz2

echo "Downloading Toxer sources from Toxer ${toxer_url}/-/archive/${toxer_version}/${toxer_archive}."
echo "Will be extracted to ${toxer} subfolder."
mkdir -p $toxer
curl -L "${toxer_url}/-/archive/${toxer_version}/${toxer_archive}" | tar xj -C $toxer --strip-components=1

