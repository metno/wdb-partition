#!/bin/sh

# increment number of months for date $1 by $2
increment_month()
{
    YEAR=`date -d$1 +%Y`
    START_MONTH=`date -d$1 +%m`
    END_MONTH=`expr $START_MONTH + $2`
    if [ $END_MONTH = 13 ]; then
	YEAR=`expr $YEAR + 1`
	END_MONTH=01
    fi
    if [ `expr length $END_MONTH` = 1 ]; then
	END_MONTH=0$END_MONTH
    fi

    echo $YEAR-$END_MONTH-01
}
#TIME_FROM=2012-02-01
TIME_FROM=$1
if [ -z $TIME_TO ]; then
    TIME_TO=`increment_month $TIME_FROM 1`
fi
TABLE_EXTENSION=`date -d$TIME_FROM +%Y%m`



cat partition_wdb.sql | \
sed s/TABLE_EXTENSION/$TABLE_EXTENSION/g | \
sed s/TIME_FROM/$TIME_FROM/g  | \
sed s/TIME_TO/$TIME_TO/g | \
psql wdb


