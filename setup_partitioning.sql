BEGIN;

CREATE SCHEMA wdb_partition;
REVOKE ALL ON SCHEMA wdb_partition FROM PUBLIC;
GRANT ALL ON SCHEMA wdb_partition TO wdb_admin;
GRANT USAGE ON SCHEMA wdb_partition TO wdb_write;
GRANT ALL ON SCHEMA wdb_partition TO wdb_clean;


-- This table lists all partitions, with their time ranges
CREATE TABLE wdb_partition.floatvalue_partitions (
       partition_name text NOT NULL PRIMARY KEY,
       fromtime timestamp with time zone NOT NULL,
       totime timestamp with time zone NOT NULL
);

-- The distribution function
CREATE OR REPLACE FUNCTION wdb_partition.floatvalue_allocate()
RETURNS trigger AS
$BODY$
DECLARE
	partition text;
	insert_statement text;
BEGIN
	SELECT 
	      partition_name INTO partition 
	FROM 
	      wdb_partition.floatvalue_partitions
	WHERE 
	      fromtime <= NEW.referencetime AND
	      totime > NEW.referencetime;

	IF NOT FOUND THEN
	   RAISE EXCEPTION 'A partition is not yet created for time %', NEW.referencetime;
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
	EXECUTE insert_statement;

	RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER floatvalue_partition_allocate_trigger
BEFORE INSERT ON wdb_int.floatvalue
FOR EACH ROW EXECUTE PROCEDURE wdb_partition.floatvalue_allocate();



-- Check that database settings are fit for using constraints
CREATE OR REPLACE FUNCTION check_constraint_exclusion()
RETURNS void AS
$BODY$
DECLARE
	contraint_exclusion text;
BEGIN
	SELECT setting INTO contraint_exclusion 
	FROM pg_settings 
	WHERE name='constraint_exclusion';

	IF contraint_exclusion != 'partition' THEN
	   RAISE WARNING 'Constraint exclusion should probably be set to <partition>. (It is now <%>)', contraint_exclusion;
	END IF;
END;
$BODY$
LANGUAGE plpgsql;
SELECT check_constraint_exclusion();
DROP FUNCTION check_constraint_exclusion();


COMMIT;
