BEGIN;

CREATE TABLE wdb_int.floatvalue_201201 (CHECK (validtimefrom >= '2012-01-01' AND validtimefrom < '2012-02-01')) INHERITS (wdb_int.floatvalue);


ROLLBACK;