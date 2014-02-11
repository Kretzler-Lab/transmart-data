--
-- Type: TABLE; Owner: TM_CZ; Name: CZ_JOB_MASTER
--
 CREATE TABLE "TM_CZ"."CZ_JOB_MASTER" 
  (	"JOB_ID" NUMBER(18,0) DEFAULT NULL NOT NULL ENABLE, 
"START_DATE" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
"END_DATE" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
"ACTIVE" NVARCHAR2(1), 
"TIME_ELAPSED_SECS" NUMBER(18,4) DEFAULT 0, 
"BUILD_ID" NUMBER(18,0), 
"SESSION_ID" NUMBER(18,0), 
"DATABASE_NAME" NVARCHAR2(50), 
"JOB_STATUS" NVARCHAR2(50), 
"JOB_NAME" NVARCHAR2(500), 
 CONSTRAINT "CZ_JOB_MASTER_PK" PRIMARY KEY ("JOB_ID")
 USING INDEX
 TABLESPACE "TRANSMART"  ENABLE
  ) SEGMENT CREATION IMMEDIATE
 TABLESPACE "TRANSMART" ;

--
-- Type: SEQUENCE; Owner: TM_CZ; Name: SEQ_CZ_JOB_MASTER
--
CREATE SEQUENCE  "TM_CZ"."SEQ_CZ_JOB_MASTER"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 13781 CACHE 2 NOORDER  NOCYCLE ;

--
-- Type: TRIGGER; Owner: TM_CZ; Name: TRG_CZ_JOB_ID
--
  CREATE OR REPLACE TRIGGER "TM_CZ"."TRG_CZ_JOB_ID" 
  before insert on CZ_JOB_MASTER    for each row
  begin
    if inserting then
      if :NEW.JOB_ID is null then
        select SEQ_CZ_JOB_MASTER.nextval into :NEW.JOB_ID from dual;
      end if;
    end if;
  end;






/
ALTER TRIGGER "TM_CZ"."TRG_CZ_JOB_ID" ENABLE;
 
