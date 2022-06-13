#!/bin/bash

set -e

BASE=$1
CONFFILE=${BASE}/configure.ac
PATCHDIR=${BASE}/debian/patches
PATCHFILE=999-fix-fsversion.patch
MAJOR=$2
MINOR=$3
MICRO=$4
REV=$5

PINC=/usr/include/python3.10

VER=${MAJOR}.${MINOR}.${MICRO}-${REV}

if [ ! -e "$CONFFILE" ]; then
	echo $CONFFILE does not exist
	exit 1
fi

if [ ! -d "$PATCHDIR" ]; then
	echo Patch dir $PATCHDIR does not exist
	exit 1
fi

mv ${CONFFILE} ${CONFFILE}.orig

sed -e "s|\(AC_SUBST(SWITCH_VERSION_MAJOR, \[\).*\(\])\)|\1${MAJOR}\2|" \
	-e "s|\(AC_SUBST(SWITCH_VERSION_MINOR, \[\).*\(\])\)|\1${MINOR}\2|" \
	-e "s|\(AC_SUBST(SWITCH_VERSION_MICRO, \[\).*\(\])\)|\1${MICRO}-${REV}\2|" \
	-e "s|\(AC_INIT(\[freeswitch\], \[\).*\(\], bugs@freeswitch.org)\)|\1${VER}\2|" \
	-e "/^APR_REMOVEFROM/a APR_ADDTO(CPPFLAGS, -I$PINC)\nAPR_ADDTO(SWITCH_AM_CFLAGS, -I$PINC)" \
	< ${CONFFILE}.orig > ${CONFFILE}

cd $BASE
# Ignore return code on diff
diff -ur ./$(basename ${CONFFILE}.orig) ./$(basename ${CONFFILE}) > ${PATCHDIR}/${PATCHFILE} || true

grep -q ${PATCHFILE} ${PATCHDIR}/series || echo ${PATCHFILE} >> ${PATCHDIR}/series

rm -f ${CONFFILE}
mv ${CONFFILE}.orig ${CONFFILE}
