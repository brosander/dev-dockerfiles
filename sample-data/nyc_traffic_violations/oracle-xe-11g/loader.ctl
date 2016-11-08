LOAD DATA
  infile '/var/lib/oracle-files/violations'
  REPLACE
  INTO TABLE violations
  fields terminated by ',' optionally enclosed by '"'
  (
  Plate,
  State,
  License_Type,
  Summons_Number,
  Issue_Date date 'MM/DD/YYYY',
  Violation_Time date 'HH:MI AM',
  Violation,
  Judgment_Entry_Date date 'MM/DD/YYYY',
  Fine_Amount,
  Penalty_Amount,
  Interest_Amount,
  Reduction_Amount,
  Payment_Amount,
  Amount_Due,
  Precinct,
  County,
  Issuing_Agency,
  Violation_Status,
  Summons_Image
  )
