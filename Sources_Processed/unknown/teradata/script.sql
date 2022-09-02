CREATE MULTISET TABLE TABLE1 ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      DATASOURCE_NUM_ID BYTEINT NOT NULL,
      INTEGRATION_ID VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      SOURCE_ID VARCHAR(30) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      PHONE_NUMBER VARCHAR(40) CHARACTER SET LATIN NOT CASESPECIFIC,
      DNIS DECIMAL(10,0) ,
      PHONE_DESC VARCHAR(50) CHARACTER SET LATIN NOT CASESPECIFIC)
PRIMARY INDEX TABLE1_PI ( DATASOURCE_NUM_ID ,INTEGRATION_ID );

/* <sc-view> SCH_VW.TABLE1 </sc-view> */

REPLACE  VIEW VW_TABLE1 AS
LOCKING ROW FOR ACCESS
SELECT p.DATASOURCE_NUM_ID
, p.INTEGRATION_ID
, p.SOURCE_ID
, p.PHONE_NUMBER
, p.DNIS
, p.PHONE_DESC
FROM TABLE1 p
 ;

REPLACE PROCEDURE P_CAG_COUNT_BIZ_DAYS
	(IN V_CREATED_DT_WID INTEGER, 
	IN V_ACTUAL_END_DT TIMESTAMP,
	 OUT O_CAG_BIZ_DAYS INTEGER 
	) 
	BEGIN
	SELECT COUNT(*) INTO O_CAG_BIZ_DAYS 
	FROM UDS_VW.W_DAY_D_CEW W_DAY_D 
	WHERE 
	W_DAY_D.ROW_WID>V_CREATED_DT_WID AND 
	CAST(W_DAY_D.DAY_DT AS DATE)<=CAST(V_ACTUAL_END_DT AS DATE)  AND 
	W_DAY_D.X_CAG_HOLIDAY_FLG IS NULL AND 
	W_DAY_D.DAY_OF_WEEK NOT IN (7,1)AND
	W_DAY_D.DAY_DT IS NOT NULL;
	END;

