BEGIN;

CREATE TABLE floatvalue_partitions (
       partition_name text NOT NULL PRIMARY KEY,
       fromtime timestamp with time zone NOT NULL,
       totime timestamp with time zone NOT NULL
);


COMMIT;
