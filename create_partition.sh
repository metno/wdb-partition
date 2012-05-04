#!/bin/sh


set -e

SHAREDIR=.

ALL_OPTIONS=$*

PROGRAM=$0
VERSION=0.1.0

DATABASE=wdb
USERNAME=
HOSTNAME=
PORT=

PARTITION_SIZE_IN_MONTHS=3

version()
{
	echo $PROGRAM $VERSION
}

help()
{
echo "Description

More description

Options:

  -f [ --from ] arg            Earliest time the new partition should
                               be valid for.
  -t [ --to ]                  First point in time the new partition
                               should be valid for. If not given, the
                               new partition will be valid for exactly
                               one month.

  --table-extension            Override generated table name extension

  --next-period                 This is an alternative to the above
                               options. Create a new partition, valid
                               for one month, starting at the first
                               day of the upcoming month

  -d [ --database ] arg (=wdb) Database name (ex. wdb)
  -h [ --host ] arg            Database host (ex. somehost.met.no)
  -u [ --user ] arg            Database user name
  -p [ --port ] arg            Database port number to connect to
"	
}

wdb_arguments()
{
	[ -z $DATABASE ] || echo -n "-d$DATABASE "
	[ -z $HOSTNAME ] || echo -n "-h$HOSTNAME "
	[ -z $USERNAME ] || echo -n "-u$USERNAME "
	[ -z $PORT ] || echo -n "-p$PORT "
}

# increment number of months for date $1 by $2
increment_month()
{
    YEAR=`date -d$1 +%Y`
    START_MONTH=`date -d$1 +%m`
    END_MONTH=`expr $START_MONTH + $2`
    if [ $END_MONTH -gt 12 ]; then
		YEAR=`expr $YEAR + 1`
		END_MONTH=`expr $END_MONTH - 12`
    fi
    if [ `expr length $END_MONTH` = 1 ]; then
	END_MONTH=0$END_MONTH
    fi

    echo $YEAR-$END_MONTH-01
}

next_period_start()
{
    YEAR=`date -d$1 +%Y`
    START_MONTH=`date -d$1 +%m`
    
    END_MONTH=`expr $START_MONTH + $PARTITION_SIZE_IN_MONTHS - $START_MONTH % $PARTITION_SIZE_IN_MONTHS`
    if [ $END_MONTH -gt 12 ]; then
		YEAR=`expr $YEAR + 1`
		END_MONTH=`expr $END_MONTH - 12`  
    fi
    if [ `expr length $END_MONTH` = 1 ]; then
		END_MONTH=0$END_MONTH
    fi

    echo $YEAR-$END_MONTH-01
}


TEMP=`getopt -o d:h:u:U:p:f:t: --long version,help,database:,host:,username:,port:from:,to:,table-extension:,next-period -n $1 -- "$@"`
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"


while true; do 
    case "$1" in
	--version)
	    version
	    exit 0
	    ;;
	--help) 
	    help
	    exit 0
	    ;;
	-d|--database)
	    DATABASE="$2"
	    shift 2
	    ;;
	-h|--host)
	    HOSTNAME="$2"
	    shift 2
	    ;;
	-u|-U|--username)
	    USERNAME="$2"
	    shift 2
	    ;;
	-p|--port)
	    PORT=$2
	    shift 2
	    ;;
	-f|--from)
	    TIME_FROM=$2
	    shift 2
	    ;;
	-t|--to)
	    TIME_TO=$2
	    shift 2
	    ;;
	--table-extension)
	    TABLE_EXTENSION=$2
	    shift 2
	    ;;
	--next-period)
	    TODAY=`date +%Y-%m-01`
	    TIME_FROM=`next_period_start $TODAY`
    	TIME_TO=`next_period_start $TIME_FROM`
        shift
	    ;;
	--)
	    shift
	    break
	    ;;
	*) # this should never happen
	    echo invalid argument: $1
	    exit 1
	    ;;
    esac
done


if [ -z $TIME_FROM ]; then
    echo Fromtime must be specified
    exit 1
fi
if [ -z $TIME_TO ]; then
    TIME_TO=`increment_month $TIME_FROM $PARTITION_SIZE_IN_MONTHS`
fi
if [ -z $TABLE_EXTENSION ]; then
    TABLE_EXTENSION=`date -d$TIME_FROM +%Y%m`
fi

#echo $TABLE_EXTENSION
echo "From: $TIME_FROM"
echo "To:   $TIME_TO"


cat $SHAREDIR/partition_wdb.sql | \
sed s/TABLE_EXTENSION/$TABLE_EXTENSION/g | \
sed s/TIME_FROM/$TIME_FROM/g  | \
sed s/TIME_TO/$TIME_TO/g | \
psql wdb

