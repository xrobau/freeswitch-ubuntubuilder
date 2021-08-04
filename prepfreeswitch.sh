#!/bin/bash

BASEDIR=$1
FSPREFIX=$2
SOURCEFILE=$3

set -e
cd $BASEDIR

rm -rf $FSPREFIX
tar xf $SOURCEFILE
FSDIR=$BASEDIR/$FSPREFIX

echo "Removing dh-systemd (no longer exists)"
sed -i 's/", dh-systemd"/" "/'  $FSDIR/debian/bootstrap.sh
echo "Disabling applications/mod_signalwire, codecs/mod_bv, codecs/mod_ilbc, codecs/mod_silk, languages/mod_v8"
sed -i '/avoid_mods=(/a  applications/mod_signalwire\n  codecs/mod_bv\n  codecs/mod_ilbc\n codecs/mod_silk\n  languages/mod_v8' $FSDIR/debian/bootstrap.sh
echo "Disabling mongo components and mod_cv"
sed -i '/avoid_mods=(/a  event_handlers/mod_cdr_mongodb\n applications/mod_mongo\n applications/mod_cv' $FSDIR/debian/bootstrap.sh
echo "Changing python-dev to python2-dev and disabling mod_python mod_rayo endpoints/mod_skinny"
sed -i 's/python-dev/python2-dev/' $FSDIR/debian/bootstrap.sh
sed -i 's/python-dev/python2-dev/' $FSDIR/debian/control-modules
sed -i '/avoid_mods=(/a  languages/mod_python\n  event_handlers/mod_rayo\n  endpoints/mod_skinny' $FSDIR/debian/bootstrap.sh
#echo "Switching to a single job for debugging"
#sed -ri 's/make -j..NJOBS./make -j1/' $FSDIR/debian/rules


