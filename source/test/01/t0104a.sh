#!/bin/sh
#
#	cook - file construction tool
#	Copyright (C) 1997, 1998 Peter Miller;
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
# MANIFEST: Test the make2cook functionality
#
work=${COOK_TMP:-/tmp}/$$
PAGER=cat
export PAGER
umask 022
unset COOK
here=`pwd`
if test $? -ne 0 ; then exit 2; fi

bin="$here/${1-.}/bin"

pass()
{
	set +x
	cd $here
	rm -rf $work
	exit 0
}
fail()
{
	set +x
	echo 'FAILED test of the make2cook functionality' 1>&2
	cd $here
	rm -rf $work
	exit 1
}
no_result()
{
	set +x
	echo 'NO RESULT test of the make2cook functionality' 1>&2
	cd $here
	rm -rf $work
	exit 2
}
trap \"no_result\" 1 2 3 15

mkdir $work $work/lib
if test $? -ne 0 ; then no_result; fi
cd $work
if test $? -ne 0 ; then no_result; fi

#
# Use the default error messages.  There is no other way to get
# predictable test behaviour on the unknown systems we will be tested on.
#
COOK_MESSAGE_LIBRARY=$work/no-such-dir
export COOK_MESSAGE_LIBRARY
unset LANG

#
# test the make2cook functionality
#
cat > test.in << 'fubar'
# Directory for object files and libc.a.  If this is not defined, the
# object files live in the subdirectories where their sources live, and
# libc.a lives in the parent directory (this probably doesn't work any
# more).
ifdef ARCH
ifeq ($(filter /%,$(ARCH)),)
objdir := $(..)$(ARCH)
else
objdir = $(ARCH)
endif
endif
fubar
if test $? -ne 0 ; then no_result; fi

cat > test.ok << 'fubar'
if [not [defined ..]] then
	.. = [getenv ..];
if [not [defined ARCH]] then
	ARCH = [getenv ARCH];
#line 0 "test.in"
/*
 * Directory for object files and libc.a.  If this is not defined, the
 * object files live in the subdirectories where their sources live, and
 * libc.a lives in the parent directory (this probably doesn't work any
 * more).
 */
#line 5 "test.in"
#if [defined ARCH ]
#if [in [filter /% [ARCH]] "" ]
if [not [defined objdir]] then
#line 7 "test.in"
	objdir = [..][ARCH];
#else
if [not [defined objdir]] then
#line 9 "test.in"
	objdir = [ARCH];
#endif
#endif
fubar
if test $? -ne 0 ; then no_result; fi

$bin/make2cook -e -ln test.in test.out
if test $? -ne 0 ; then fail; fi

diff test.ok test.out
if test $? -ne 0 ; then fail; fi

#
# Only definite negatives are possible.
# The functionality exercised by this test appears to work,
# no other guarantees are made.
#
pass
