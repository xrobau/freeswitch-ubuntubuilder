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
echo "Setting --with-python=no and --with-python3=yes"
sed -i 's/--with-python/--with-python=no/' $FSDIR/debian/rules
sed -i 's/--with-python3/--with-python3=no/' $FSDIR/debian/rules
echo "Changing python-dev to python3-dev and disabling mod_python mod_rayo endpoints/mod_skinny"
sed -i 's/python-dev/python3-dev/' $FSDIR/debian/bootstrap.sh
sed -i 's/python-dev/python3-dev/' $FSDIR/debian/control-modules
sed -i '/avoid_mods=(/a  languages/mod_python\n  languages/mod_python3\n  event_handlers/mod_rayo\n  endpoints/mod_skinny' $FSDIR/debian/bootstrap.sh
#echo "Switching to a single job for debugging"
#sed -ri 's/make -j..NJOBS./make -j1/' $FSDIR/debian/rules
echo "Stopping dpkg from restarting freeswitch on upgrades"
sed -r -i 's/dh_systemd_start.+-pfreeswitch-systemd/dh_systemd_start --no-restart-after-upgrade --no-restart-on-upgrade -pfreeswitch-systemd/' $FSDIR/debian/rules

echo "Disabling libav, it's missing in impish and later"
sed -i 's/, libavresample-dev//' $FSDIR/debian/control*
sed -i '/avoid_mods=(/a  event_handlers/mod_amqp applications/mod_av' $FSDIR/debian/bootstrap.sh

echo "Python ESL is just messed up somehow"
rm -f $FSDIR/debian/python-esl.install
chmod 755 $FSDIR/libs/esl/*/python-config
