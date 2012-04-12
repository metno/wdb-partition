-- Replace all instances of TABLE_EXTENSION a proper name extenstion
--                          TIME_FROM with correct from time
--                          TIME_TO with correct to time


BEGIN;

\set ON_ERROR_STOP



-- entry for lookup

INSERT INTO wdb_partition.floatvalue_partitions VALUES (
       'wdb_partition.floatvalue_TABLE_EXTENSION', 'TIME_FROM', 'TIME_TO');



--table

CREATE TABLE wdb_partition.floatvalue_TABLE_EXTENSION (CHECK (validtimefrom >= 'TIME_FROM' AND validtimefrom < 'TIME_TO')) INHERITS (wdb_int.floatvalue);



-- permissions

REVOKE ALL ON wdb_partition.floatvalue_TABLE_EXTENSION FROM public;
GRANT ALL ON wdb_partition.floatvalue_TABLE_EXTENSION TO wdb_admin;
GRANT SELECT, DELETE ON wdb_partition.floatvalue_TABLE_EXTENSION TO wdb_clean;



-- indices

ALTER TABLE ONLY wdb_partition.floatvalue_TABLE_EXTENSION ADD CONSTRAINT floatvalue_TABLE_EXTENSION_pkey PRIMARY KEY (valueid, valuetype);
CREATE UNIQUE INDEX XAK1Wdb_FloatValue_TABLE_EXTENSION ON wdb_partition.FloatValue_TABLE_EXTENSION
(
       DataProviderId,
       ReferenceTime,
       DataVersion,
       PlaceId,
       ValueParameterId,
       LevelParameterId,
       LevelFrom,
       LevelTo,
       LevelIndeterminateCode,
       ValidTimeFrom,
       ValidTimeTo,
       ValidTimeIndeterminateCode
);

CREATE INDEX XIE1Wdb_FloatValue_TABLE_EXTENSION ON wdb_partition.FloatValue_TABLE_EXTENSION
(
       DataProviderId,
       ValidTimeFrom,
       ValueParameterId
);

CREATE INDEX XIE2Wdb_FloatValue_TABLE_EXTENSION ON wdb_partition.FloatValue_TABLE_EXTENSION
(
       PlaceId,
       ValidTimeFrom,
       ValueParameterId
);

CREATE INDEX XIE3Wdb_FloatValue_TABLE_EXTENSION ON wdb_partition.FloatValue_TABLE_EXTENSION
(
       ValidTimeFrom,
       PlaceId,
       Valueparameterid
);

CREATE INDEX XIE4Wdb_FloatValue_TABLE_EXTENSION ON wdb_partition.FloatValue_TABLE_EXTENSION
(
       ValidTimeFrom,
       DataProviderId,
       ValueParameterId
);



-- foreign key constraints

ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (dataproviderid)
					REFERENCES wdb_int.dataprovider
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (placeid)
					REFERENCES wdb_int.placedefinition
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (validtimeindeterminatecode)
					REFERENCES wdb_int.timeindeterminatetype
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (valueparameterid)
					REFERENCES wdb_int.parameter
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (levelparameterid)
					REFERENCES wdb_int.parameter
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (levelindeterminatecode)
					REFERENCES wdb_int.levelindeterminatetype
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


ALTER TABLE wdb_partition.FloatValue_TABLE_EXTENSION
	ADD FOREIGN KEY (confidencecode)
					REFERENCES wdb_int.qualityconfidencecode
					ON DELETE RESTRICT
					ON UPDATE CASCADE;


COMMIT;