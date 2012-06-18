-- Replace all instances of TABLE_EXTENSION a proper name extenstion
--                          TIME_FROM with correct from time
--                          TIME_TO with correct to time


BEGIN;

\set ON_ERROR_STOP



-- entry for lookup

INSERT INTO wdb_partition.floatvalueitem_partitions VALUES (
       'wdb_partition.floatvalueitem_TABLE_EXTENSION', 'TIME_FROM', 'TIME_TO');



--table

CREATE TABLE wdb_partition.floatvalueitem_TABLE_EXTENSION (CHECK (referencetime >= 'TIME_FROM' AND referencetime < 'TIME_TO')) INHERITS (wdb_int.floatvalueitem);



-- permissions

REVOKE ALL ON wdb_partition.floatvalueitem_TABLE_EXTENSION FROM public;
GRANT ALL ON wdb_partition.floatvalueitem_TABLE_EXTENSION TO wdb_admin;
GRANT SELECT, DELETE ON wdb_partition.floatvalueitem_TABLE_EXTENSION TO wdb_clean;



-- indices

ALTER TABLE ONLY wdb_partition.floatvalueitem_TABLE_EXTENSION ADD CONSTRAINT floatvalueitem_TABLE_EXTENSION_pkey PRIMARY KEY (valuegroupid, referencetime);

-- foreign key constraints

ALTER TABLE wdb_partition.floatvalueitem_TABLE_EXTENSION
	ADD FOREIGN KEY (confidencecode)
					REFERENCES wdb_int.qualityconfidencecode
					ON DELETE RESTRICT
					ON UPDATE CASCADE;

ALTER TABLE wdb_partition.floatvalueitem_TABLE_EXTENSION
	ADD FOREIGN KEY (valuegroupid)
					REFERENCES wdb_int.floatvaluegroup(valuegroupid)
					ON DELETE RESTRICT
					ON UPDATE CASCADE;

COMMIT;