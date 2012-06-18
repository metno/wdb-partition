#!/bin/sh

set -e

SHAREDIR=.

DATABASE=wdb
USERNAME=
HOSTNAME=
PORT=

version()
{
	echo $PROGRAM $VERSION
}

help()
{
echo "Prepare a wdb database for partitioning

Options:

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
	[ -z $USERNAME ] || echo -n "-U$USERNAME "
	[ -z $PORT ] || echo -n "-p$PORT "
}

TEMP=`getopt -o d:h:u:U:p --long version,help,database:,host:,username:,port: -n $1 -- "$@"`
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

psql `wdb_arguments` < $SHAREDIR/setup_partitioning.sql
