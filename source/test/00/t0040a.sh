#!/bin/sh
#
#	cook - file construction tool
#	Copyright (C) 1990-1994, 1997, 1998, 2003 Peter Miller;
#	All rights reserved.
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program; if not, write to the Free Software
#	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA.
#
# MANIFEST: test the cooktime program
#
tmp=${COOK_TMP:-/tmp}/$$
PAGER=cat
export PAGER
umask 022
unset COOK
here=`pwd`
if test $? -ne 0 ; then exit 1; fi

bin="$here/${1-.}/bin"

fail()
{
	echo 'FAILED test of the cooktime program' 1>&2
	cd $here
	rm -rf $tmp
	exit 1
}
pass()
{
	cd $here
	rm -rf $tmp
	exit 0
}
trap "fail" 1 2 3 15

mkdir $tmp $tmp/lib
cd $tmp

#
# Use the default error messages.  There is no other way to get
# predictable test behaviour on the unknown systems we will be tested on.
#
COOK_MESSAGE_LIBRARY=$work/no-such-dir
export COOK_MESSAGE_LIBRARY
unset LANG

MANPATH=${MANPATH-/usr/man}
for path in ${AEGIS_SEARCH_PATH-$here}
do
	if test -d $path/lib/$LANG/.
	then
		MANPATH=${MANPATH}:$path/lib/$LANG
	fi
done
IFS="$ifs_old"

PAGER=cat
export PAGER

cp /dev/null victim
if test $? -ne 0 ; then fail; fi

$bin/cooktime victim -r > /dev/null
if test $? -ne 0 ; then fail; fi

# Cygwin can't cope with dates prior to 1980 (gives EINVAL if you try)
$bin/cooktime victim -m 2-jan-80 -r > /dev/null
if test $? -ne 0 ; then fail; fi

$bin/cooktime victim -a 8-jan-85 -r > /dev/null
if test $? -ne 0 ; then fail; fi

# probably OK
pass
