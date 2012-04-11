BEGIN;

--CREATE TABLE wdb_int.floatvalue_partitions (
--       partition_name text NOT NULL PRIMARY KEY,
--       fromtime timestamp with time zone NOT NULL,
--       totime timestamp with time zone NOT NULL
--);

DROP TRIGGER floatvalue_partition_allocate_trigger ON wdb_int.floatvalue;

CREATE OR REPLACE FUNCTION floatvalue_partition_allocate()
RETURNS trigger AS
$BODY$
DECLARE
	partition text;
	insert_statement text;
BEGIN
	SELECT 
	      partition_name INTO partition 
	FROM 
	      wdb_int.floatvalue_partitions
	WHERE 
	      fromtime <= NEW.validtimefrom AND
	      totime > NEW.validtimefrom;

	IF NOT FOUND THEN
	   RAISE EXCEPTION 'A partition is not yet created for time %', NEW.validtimefrom;
	END IF;

	-- Feil her
	--INSERT INTO partition_name VALUES (NEW.*);
	insert_statement := 'INSERT INTO '|| partition ||' VALUES ('|| 
			 NEW.valueid || ', ' ||
			 NEW.valuetype || ', ' ||
			 NEW.dataproviderid || ', ' ||
			 NEW.placeid || ', ' ||
			 quote_literal(NEW.referencetime) || ', ' ||
			 quote_literal(NEW.validtimefrom) || ', ' ||
			 quote_literal(NEW.validtimeto) || ', ' ||
			 NEW.validtimeindeterminatecode || ', ' ||
			 NEW.valueparameterid || ', ' ||
			 NEW.levelparameterid || ', ' ||
			 NEW.levelfrom || ', ' ||
			 NEW.levelto || ', ' ||
			 NEW.levelindeterminatecode || ', ' || 
			 NEW.dataversion || ', ' ||
			 NEW.maxdataversion || ', ' ||
			 NEW.confidencecode || ', ' ||
			 NEW.value || ', ' ||
			 quote_literal(NEW.valuestoretime) || ')'
	;

	RAISE INFO '%', insert_statement;

	EXECUTE insert_statement;

	RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER floatvalue_partition_allocate_trigger
BEFORE INSERT ON wdb_int.floatvalue
FOR EACH ROW EXECUTE PROCEDURE floatvalue_partition_allocate();

COMMIT;
