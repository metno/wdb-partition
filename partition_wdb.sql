BEGIN;

-- Replace all instances of TABLE_EXTENSION a proper name extenstion
--                          'TIME_FROM' with correct from time
--                          'TIME_TO' with correct to time


--table
CREATE TABLE wdb_int.floatvalue_TABLE_EXTENSION (CHECK (validtimefrom >= 'TIME_FROM' AND validtimefrom < 'TIME_TO')) INHERITS (wdb_int.floatvalue);

INSERT INTO wdb_int.floatvalue_partitions VALUES (
       'wdb_int.floatvalue_TABLE_EXTENSION', 'TIME_FROM', 'TIME_TO');

-- indices
ALTER TABLE ONLY wdb_int.floatvalue_TABLE_EXTENSION ADD CONSTRAINT floatvalue_TABLE_EXTENSION_pkey PRIMARY KEY (valueid, valuetype);
CREATE UNIQUE INDEX XAK1Wdb_FloatValue_2012_01 ON wdb_int.FloatValue_TABLE_EXTENSION
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

CREATE INDEX XIE1Wdb_FloatValue_TABLE_EXTENSION ON wdb_int.FloatValue_TABLE_EXTENSION
(
       DataProviderId,
       ValidTimeFrom,
       ValueParameterId
);

CREATE INDEX XIE2Wdb_FloatValue_TABLE_EXTENSION ON wdb_int.FloatValue_TABLE_EXTENSION
(
       PlaceId,
       ValidTimeFrom,
       ValueParameterId
);

CREATE INDEX XIE3Wdb_FloatValue_TABLE_EXTENSION ON wdb_int.FloatValue_TABLE_EXTENSION
(
       ValidTimeFrom,
       PlaceId,
       Valueparameterid
);

CREATE INDEX XIE4Wdb_FloatValue_TABLE_EXTENSION ON wdb_int.FloatValue_TABLE_EXTENSION
(
       ValidTimeFrom,
       DataProviderId,
       ValueParameterId
);

COMMIT;