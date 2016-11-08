#!/bin/bash

set -e

sqlplus system/oracle <<END
create table violations (
  Plate varchar2(255),
  State char(2),
  License_Type varchar2(255),
  Summons_Number number(19),
  Issue_Date date,
  Violation_Time date,
  Violation varchar2(255),
  Judgment_Entry_Date date,
  Fine_Amount numeric(15,4),
  Penalty_Amount numeric(15,4),
  Interest_Amount numeric(15,4),
  Reduction_Amount numeric(15,4),
  Payment_Amount numeric(15,4),
  Amount_Due numeric(15,4),
  Precinct varchar2(255),
  County varchar2(255),
  Issuing_Agency varchar2(255),
  Violation_Status varchar2(255),
  Summons_Image varchar2(255)
);
END
sqlldr system/oracle control=/var/lib/oracle-files/loader.ctl log=/dev/stdout
