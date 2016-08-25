#!/bin/bash

set -e

mysql -u root --password="$MYSQL_ROOT_PASSWORD" -D "$MYSQL_DATABASE" << EOS
  create table violations (Plate varchar(255),State char(2),License_Type varchar(255),Summons_Number bigint,Issue_Date date,Violation_Time time,Violation varchar(255),Judgment_Entry_Date date,Fine_Amount numeric(15,4),Penalty_Amount numeric(15,4),Interest_Amount numeric(15,4),Reduction_Amount numeric(15,4),Payment_Amount numeric(15,4),Amount_Due numeric(15,4),Precinct varchar(255),County varchar(255),Issuing_Agency varchar(255),Violation_Status varchar(255),Summons_Image varchar(255));
  load data infile '/var/lib/mysql-files/violations' 
    into table violations fields terminated by ','
    optionally enclosed by '"'
    (Plate,State,License_Type,Summons_Number,@Issue_Date,@Violation_Time,Violation,@Judgment_Entry_Date,@Fine_Amount,@Penalty_Amount,@Interest_Amount,@Reduction_Amount,@Payment_Amount,@Amount_Due,Precinct,County,Issuing_Agency,Violation_Status,Summons_Image)
    SET
      Issue_Date = IF(LENGTH(@Issue_Date) = 0, null, STR_TO_DATE(@Issue_Date, '%m/%d/%Y')),
      Judgment_Entry_Date = IF(LENGTH(@Judgment_Entry_Date) = 0, null, STR_TO_DATE(@Judgment_Entry_Date, '%m/%d/%Y')),
      Violation_Time = IF(LENGTH(@Violation_Time) = 0, null, TIME(STR_TO_DATE(CONCAT('01/01/2001 ', @Violation_Time), '%m/%d/%Y %h:%i %p'))),
      Fine_Amount = IF(LENGTH(@Fine_Amount) = 0, null, REPLACE(@Fine_Amount, '$', '')),
      Penalty_Amount = IF(LENGTH(@Penalty_Amount) = 0, null, REPLACE(@Penalty_Amount, '$', '')),
      Interest_Amount = IF(LENGTH(@Interest_Amount) = 0, null, REPLACE(@Interest_Amount, '$', '')),
      Reduction_Amount = IF(LENGTH(@Reduction_Amount) = 0, null, REPLACE(@Reduction_Amount, '$', '')),
      Payment_Amount = IF(LENGTH(@Payment_Amount) = 0, null, REPLACE(@Payment_Amount, '$', '')),
      Amount_Due = IF(LENGTH(@Amount_Due) = 0, null, REPLACE(@Amount_Due, '$', ''))
    ; SHOW WARNINGS;
  commit;
EOS

#mysqlimport \
#  --fields-terminated-by=, \
#  --local -u root \
#  --columns='Plate,State,License_Type,Summons_Number,Issue_Date,Violation_Time,Violation,Judgment_Entry_Date,Fine_Amount,Penalty_Amount,Interest_Amount,Reduction_Amount,Payment_Amount,Amount_Due,Precinct,County,Issuing_Agency,Violation_Status,Summons_Image' \
#  --local \
#  --password="$MYSQL_ROOT_PASSWORD" \
#  "$MYSQL_DATABASE" \
#  /tmp/violations
