#!/bin/bash

set -e

DB="$POSTGRES_DB"
if [ -z "$DB" ]; then
  DB="$POSTGRES_USER"
fi

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$DB" << EOS
create table violations (Plate varchar,State char(2),License_Type varchar,Summons_Number bigint,Issue_Date date,Violation_Time time,Violation varchar,Judgment_Entry_Date date,Fine_Amount money,Penalty_Amount money,Interest_Amount money,Reduction_Amount money,Payment_Amount money,Amount_Due money,Precinct varchar,County varchar,Issuing_Agency varchar,Violation_Status varchar,Summons_Image varchar);
\copy violations FROM '/tmp/violations' DELIMITER ',' CSV
EOS
