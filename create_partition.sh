#!/bin/sh

TIME_FROM=2012-01-01
TIME_TO=2012-02-01
TABLE_EXTENSION=`echo $TIME_FROM | cut -d- -f1,2 | sed s/-//`


cat partition_wdb.sql | \
sed s/TABLE_EXTENSION/$TABLE_EXTENSION/g | \
sed s/TIME_FROM/$TIME_FROM/g  | \
sed s/TIME_TO/$TIME_TO/g | \
psql wdb


