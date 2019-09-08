INSERT INTO BI_HR_COMN_CODE_GROUP_BAS VALUE
  (SRC_SYS_ID,
   CODE_GRP_ID,
   CODE_GRP_ENG_NM,
   CODE_GRP_ENG_ABBR_NM,
   CODE_GRP_KOR_NM,
   CODE_GRP_KOR_ABBR_NM,
   UPPER_CODE_GRP_ID,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT 'iHR',
         CODE_GRP_ID,
         CODE_GRP_ENG_NM,
         CODE_GRP_ENG_ABBR_NM,
         CODE_GRP_KOR_NM,
         CODE_GRP_KOR_ABBR_NM,
         UPPER_CODE_GRP_ID,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
    FROM BVK_BI_COMN_CODE_GROUP_BAS_V@NOHL;

INSERT INTO BI_HR_DEPT_BAS VALUE
  (REGN_CD,
   CPNY_CD,
   LOC_CD,
   DEPT_CD,
   CODE_KOR_NM,
   CODE_KOR_ABBR_NM,
   CODE_ENG_NM,
   CODE_ENG_ABBR_NM,
   COST_CNTR_CD,
   HRCHY_LEVEL,
   UPPER_CODE_ID,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT 'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         DEPT_CD,
         CODE_KOR_NM,
         CODE_KOR_ABBR_NM,
         CODE_ENG_NM,
         CODE_ENG_ABBR_NM,
         COST_CNTR_CD,
         HRCHY_LEVEL,
         UPPER_CODE_ID,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
    FROM BVK_BI_DEPT_BAS_V@NOHL;

INSERT INTO BI_HR_EMP_BAS VALUE
  (BASE_DT,
   REGN_CD,
   CPNY_CD,
   LOC_CD,
   EMP_ID,
   DEPT_CD,
   GRP_HIRE_DT,
   HIRE_DT,
   WORK_YR_CNT,
   BRTH_DT,
   AGE,
   GNDR_CD,
   JOB_GRP_CD,
   JOB_RANK_CD,
   JOB_PSTN_CD,
   DUTY_TYPE_CD,
   WORK_DIV_CD,
   RETR_DT,
   LAST_APNT_DT,
   COST_DIV_CD,
   PAY_TRGT_YN,
   PAY_CTG_CD,
   COST_CNTR_CD,
   ERP_USER_ID,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT BASE_DT,
         'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         EMP_ID,
         DEPT_CD,
         GRP_HIRE_DT,
         HIRE_DT,
         WORK_YR_CNT,
         BRTH_DT,
         AGE,
         GNDR_CD,
         JOB_GRP_CD,
         JOB_RANK_CD,
         JOB_PSTN_CD,
         DUTY_TYPE_CD,
         WORK_DIV_CD,
         RETR_DT,
         LAST_APNT_DT,
         COST_DIV_CD,
         PAY_TRGT_YN,
         PAY_CTG_CD,
         COST_CNTR_CD,
         ERP_USER_ID,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
    FROM BVK_BI_EMP_BAS_V@NOHL
   WHERE LOC_CD IS NOT NULL;

INSERT INTO BI_HR_APNT_TXN VALUE
  (APNT_DT,
   REGN_CD,
   CPNY_CD,
   EMP_ID,
   APNT_RESN_CD,
   LOC_CD,
   DEPT_CD,
   JOB_GRP_CD,
   JOB_RANK_CD,
   EMP_TYPE_CD,
   PAY_CTG_CD,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT APNT_DT,
         'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         EMP_ID,
         APNT_RESN_CD,
         LOC_CD,
         DEPT_CD,
         JOB_GRP_CD,
         JOB_RANK_CD,
         EMP_TYPE_CD,
         PAY_CTG_CD,
         substr(APPLY_START_DT,1,8),
         substr(APPLY_END_DT,1,8),
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
    FROM bvk_bi_apnt_txn_v@NOHL
   WHERE LOC_CD IS NOT NULL;

INSERT INTO BI_HR_WORK_TIME_TXN VALUE
  (WORK_DT,
   REGN_CD,
   CPNY_CD,
   LOC_CD,
   DEPT_CD,
   EMP_ID,
   WORK_STRT_DTM,
   WORK_END_DTM,
   DUTY_DIV_CD,
   DUTY_CTGR_CD,
   DUTY_TYPE_CD,
   WORK_TIME,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT WORK_DT,
         'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         DEPT_CD,
         EMP_ID,
         WORK_STRT_DTM,
         WORK_END_DTM,
         DUTY_DIV_CD,
         DUTY_CTGR_CD,
         DUTY_TYPE_CD,
         WORK_TIME,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
    FROM BVK_BI_WORK_TIME_TXN_V@NOHL;

INSERT INTO BI_HR_APNT_TXN VALUE
  (APNT_DT,
   REGN_CD,
   CPNY_CD,
   EMP_ID,
   APNT_RESN_CD,
   LOC_CD,
   DEPT_CD,
   JOB_GRP_CD,
   JOB_RANK_CD,
   EMP_TYPE_CD,
   PAY_CTG_CD,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT APNT_DT,
         'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         EMP_ID,
         APNT_RESN_CD,
         LOC_CD,
         DEPT_CD,
         JOB_GRP_CD,
         JOB_RANK_CD,
         EMP_TYPE_CD,
         PAY_CTG_CD,
         substr(APPLY_START_DT,1,8),
         substr(APPLY_END_DT,1,8),
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
    FROM bvk_bi_apnt_txn_v@NOHL
   WHERE LOC_CD IS NOT NULL;

SELECT * FROM BI_HR_COMN_CODE_GROUP_BAS;

20180313

INSERT INTO BI_HR_HEAD_COUNT_FCT
VALUE
  (BASE_DT,
   REGN_CD,
   CPNY_CD,
   LOC_CD,
   DEPT_CD,
   COST_CNTR_CD,
   EMP_ID,
   JOB_GRP_CD,
   JOB_RANK_CD,
   EMP_TYPE_CD,
   PAY_CTGR_CD,
   DUTY_TYPE_CD,
   GRP_HIRE_DT,
   HIRE_DT,
   WORK_YR_CNT,
   GNDR_CD,
   APNT_RESN_CD,
   PAY_TRGT_YN,
   BIRTH_DT,
   AGE,
   LOAD_DTM)
  SELECT
   base_dt,
   'NA',
   CASE
     WHEN LOC_CD = 11 THEN
      81
     WHEN LOC_CD = 12 THEN
      81
     ELSE
      122
   END,
   LOC_CD,
   DEPT_CD,
   COST_CNTR_CD,
   EMP_ID,
   JOB_GRP_CD,
   JOB_RANK_CD,
   EMP_TYPE_CD,
   PAY_CTG_CD,
   DUTY_TYPE_CD,
   GRP_HIRE_DT,
   HIRE_DT,
   WORK_YR_CNT,
   GNDR_CD,
   APNT_RESN_CD,
   PAY_TRGT_YN,
   BRTH_DT,
   AGE,
   LOAD_DTM
    FROM BVK_BI_HEAD_COUNT_FCT_V@NOHL;

INSERT INTO BI_HR_PAY_FCT VALUE
  (BASE_YR,
   HALF_YR,
   QUTR,
   BASE_MM,
   FSCL_YR,
   FSCL_MM,
   REGN_CD,
   CPNY_CD,
   LOC_CD,
   DEPT_CD,
   COST_CNTR_CD,
   EMP_ID,
   PAY_CTG_CD,
   PAY_KIND_CD,
   PAY_ITEM_CD,
   JOB_GRP_CD,
   JOB_RANK_CD,
   EMP_TYPE_CD,
   PAY_AMT,
   LOAD_DTM)
  SELECT BASE_YR,
         HALF_YR,
         QUTR,
         BASE_MM,
         FSCL_YR,
         FSCL_MM,
         'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         DEPT_CD,
         COST_CNTR_CD,
         EMP_ID,
         PAY_CTG_CD,
         PAY_KIND_CD,
         PAY_ITEM_CD,
         JOB_GRP_CD,
         JOB_RANK_CD,
         EMP_TYPE_CD,
         PAY_AMT,
         LOAD_DTM
    FROM BVK_BI_PAY_FCT_V@NOHL;

INSERT INTO BI_HR_WORK_TIME_FCT VALUE
  (BASE_YR,
   HALF_YR,
   QUTR,
   BASE_MM,
   FSCL_YR,
   BASE_DT,
   REGN_CD,
   CPNY_CD,
   LOC_CD,
   DEPT_CD,
   COST_CNTR_CD,
   JOB_GRP_CD,
   JOB_RANK_CD,
   EMP_TYPE_CD,
   DUTY_DIV_CD,
   DUTY_CTGR_CD,
   DUTY_TYPE_CD,
   EMP_ID,
   WORK_TIME,
   JOB_PSTN_CD,
   LOAD_DTM)
  SELECT BASE_YR,
         HALF_YR,
         QUTR,
         BASE_MM,
         FSCL_YR,
         BASE_DT,
         'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         DEPT_CD,
         COST_CNTR_CD,
         JOB_GRP_CD,
         JOB_RANK_CD,
         EMP_TYPE_CD,
         DUTY_DIV_CD,
         DUTY_CTGR_CD,
         DUTY_TYPE_CD,
         EMP_ID,
         WORK_TIME,
         JOB_PSTN_CD,
         LOAD_DTM
    FROM BVK_BI_WORK_TIME_FCT_V@NOHL;

20180315

사업장 : bvk_bi_loc_dim_v
직군 : bvk_bi_job_grp_dim_v
직급 : bvk_bi_job_rank_dim_v
직위 : bvk_bi_job_pstn_dim_v
재직구분 : bvk_bi_work_div_dim_v
근무유형 : bvk_bi_duty_ctg_dim_v
근무형태 : bvk_bi_duty_type_dim_v
급여유형 : bvk_bi_pay_ctg_dim_v
급여종류 : bvk_bi_pay_kind_dim_v
급여항목 : bvk_bi_pay_item_dim_v
발령사유 : bvk_bi_apnt_resn_dim_v
성별 : bvk_bi_gndr_dim_v

INSERT INTO BI_HR_LOC_DIM VALUE
  (REGN_CD,
   CPNY_CD,
   LOC_CD,
   LOC_ENG_NM,
   LOC_ENG_ABBR_NM,
   LOC_KOR_NM,
   LOC_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT 'NA',
                  CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         LOC_ENG_NM,
         LOC_ENG_ABBR_NM,
         LOC_KOR_NM,
         LOC_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_LOC_DIM_V@NOHL;

INSERT INTO BI_HR_JOB_GRP_DIM VALUE
  (REGN_CD,
   CPNY_CD,
   LOC_CD,
   JOB_GRP_CD,
   JOB_GRP_ENG_NM,
   JOB_GRP_ENG_ABBR_NM,
   JOB_GRP_KOR_NM,
   JOB_GRP_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT 'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         JOB_GRP_CD,
         JOB_GRP_ENG_NM,
         JOB_GRP_ENG_ABBR_NM,
         JOB_GRP_KOR_NM,
         JOB_GRP_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_JOB_GRP_DIM_V@NOHL;

INSERT INTO BI_HR_JOB_RANK_DIM VALUE
  (REGN_CD,
   CPNY_CD,
   LOC_CD,
   JOB_RANK_CD,
   JOB_RANK_ENG_NM,
   JOB_RANK_ENG_ABBR_NM,
   JOB_RANK_KOR_NM,
   JOB_RANK_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT 'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         JOB_RANK_CD,
         JOB_RANK_ENG_NM,
         JOB_RANK_ENG_ABBR_NM,
         JOB_RANK_KOR_NM,
         JOB_RANK_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_JOB_RANK_DIM_V@NOHL;

INSERT INTO BI_HR_JOB_PSTN_DIM VALUE
  (REGN_CD,
   CPNY_CD,
   LOC_CD,
   JOB_PSTN_CD,
   JOB_PSTN_ENG_NM,
   JOB_PSTN_ENG_ABBR_NM,
   JOB_PSTN_KOR_NM,
   JOB_PSTN_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT 'NA',
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END,
         LOC_CD,
         JOB_PSTN_CD,
         JOB_PSTN_ENG_NM,
         JOB_PSTN_ENG_ABBR_NM,
         JOB_PSTN_KOR_NM,
         JOB_PSTN_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_JOB_PSTN_DIM_V@NOHL;

INSERT INTO BI_HR_WORK_DIV_DIM VALUE
  (WORK_DIV_CD,
   WORK_DIV_ENG_NM,
   WORK_DIV_ENG_ABBR_NM,
   WORK_DIV_KOR_NM,
   WORK_DIV_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT WORK_DIV_CD,
         WORK_DIV_ENG_NM,
         WORK_DIV_ENG_ABBR_NM,
         WORK_DIV_KOR_NM,
         WORK_DIV_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_WORK_DIV_DIM_V@NOHL;

INSERT INTO BI_HR_DUTY_CTG_DIM VALUE
  (DUTY_CTG_CD,
   DUTY_CTG_ENG_NM,
   DUTY_CTG_ENG_ABBR_NM,
   DUTY_CTG_KOR_NM,
   DUTY_CTG_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT DUTY_CTG_CD,
         DUTY_CTG_ENG_NM,
         DUTY_CTG_ENG_ABBR_NM,
         DUTY_CTG_KOR_NM,
         DUTY_CTG_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_DUTY_CTG_DIM_V@NOHL;

INSERT INTO BI_HR_DUTY_TYPE_DIM VALUE
  (DUTY_TYPE_CD,
   DUTY_TYPE_ENG_NM,
   DUTY_TYPE_ENG_ABBR_NM,
   DUTY_TYPE_KOR_NM,
   DUTY_TYPE_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT DUTY_TYPE_CD,
         DUTY_TYPE_ENG_NM,
         DUTY_TYPE_ENG_ABBR_NM,
         DUTY_TYPE_KOR_NM,
         DUTY_TYPE_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_DUTY_TYPE_DIM_V@NOHL;


INSERT INTO BI_HR_PAY_CTG_DIM VALUE
  (PAY_CTG_CD,
   PAY_CTG_ENG_NM,
   PAY_CTG_ENG_ABBR_NM,
   PAY_CTG_KOR_NM,
   PAY_CTG_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT PAY_CTG_CD,
         PAY_CTG_ENG_NM,
         PAY_CTG_ENG_ABBR_NM,
         PAY_CTG_KOR_NM,
         PAY_CTG_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_PAY_CTG_DIM_V@NOHL;

INSERT INTO BI_HR_PAY_KIND_DIM VALUE
  (PAY_KIND_CD,
   PAY_KIND_ENG_NM,
   PAY_KIND_ENG_ABBR_NM,
   PAY_KIND_KOR_NM,
   PAY_KIND_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT PAY_KIND_CD,
         PAY_KIND_ENG_NM,
         PAY_KIND_ENG_ABBR_NM,
         PAY_KIND_KOR_NM,
         PAY_KIND_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_PAY_KIND_DIM_V@NOHL;


INSERT INTO BI_HR_PAY_ITEM_DIM VALUE
  (PAY_ITEM_CD,
   PAY_ITEM_ENG_NM,
   PAY_ITEM_ENG_ABBR_NM,
   PAY_ITEM_KOR_NM,
   PAY_ITEM_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT PAY_ITEM_CD,
         PAY_ITEM_ENG_NM,
         PAY_ITEM_ENG_ABBR_NM,
         PAY_ITEM_KOR_NM,
         PAY_ITEM_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_PAY_ITEM_DIM_V@NOHL;

INSERT INTO BI_HR_APNT_RESN_DIM VALUE
  (APNT_RESN_CD,
   APNT_RESN_ENG_NM,
   APNT_RESN_ENG_ABBR_NM,
   APNT_RESN_KOR_NM,
   APNT_RESN_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT APNT_RESN_CD,
         APNT_RESN_ENG_NM,
         APNT_RESN_ENG_ABBR_NM,
         APNT_RESN_KOR_NM,
         APNT_RESN_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_APNT_RESN_DIM_V@NOHL;


INSERT INTO BI_HR_GNDR_DIM VALUE
  (GNDR_CD,
   GNDR_ENG_NM,
   GNDR_ENG_ABBR_NM,
   GNDR_KOR_NM,
   GNDR_KOR_ABBR_NM,
   SORT_ORDER,
   USE_YN,
   APPLY_START_DT,
   APPLY_END_DT,
   FRST_INST_DTM,
   LAST_MDFY_DTM,
   LOAD_DTM)
  SELECT GNDR_CD,
         GNDR_ENG_NM,
         GNDR_ENG_ABBR_NM,
         GNDR_KOR_NM,
         GNDR_KOR_ABBR_NM,
         SORT_ORDER,
         USE_YN,
         APPLY_START_DT,
         APPLY_END_DT,
         FRST_INST_DTM,
         LAST_MDFY_DTM,
         LOAD_DTM
 
    FROM BVK_BI_GNDR_DIM_V@NOHL;



DROP TABLE bi_hr_dept_l1_dim;
CREATE TABLE bi_hr_dept_l1_dim AS
SELECT 'NA' REGN_CD,
       CASE
         WHEN LOC_CD = 11 THEN
          81
         WHEN LOC_CD = 12 THEN
          81
         ELSE
          122
       END CPNY_CD,
       LOC_CD,
       DEPT_L1_CD,
       DEPT_L1_ENG_NM,
       DEPT_L1_ENG_ABBR_NM,
       DEPT_L1_KOR_NM,
       DEPT_L1_KOR_ABBR_NM,
       COST_CNTR_CD,
       SORT_ORDER,
       USE_YN,
       APPLY_START_DT,
       APPLY_END_DT,
       FRST_INST_DTM,
       LAST_MDFY_DTM,
       LOAD_DTM
  FROM BVK_BI_DEPT_L1_DIM_V@NOHL;
DROP TABLE bi_hr_dept_l2_dim;
CREATE TABLE bi_hr_dept_l2_dim AS
SELECT 'NA' REGN_CD,
       CASE
         WHEN LOC_CD = 11 THEN
          81
         WHEN LOC_CD = 12 THEN
          81
         ELSE
          122
       END CPNY_CD,
       LOC_CD,
       DEPT_L1_CD,
       DEPT_L2_CD,
       DEPT_L2_ENG_NM,
       DEPT_L2_ENG_ABBR_NM,
       DEPT_L2_KOR_NM,
       DEPT_L2_KOR_ABBR_NM,
       COST_CNTR_CD,
       SORT_ORDER,
       USE_YN,
       APPLY_START_DT,
       APPLY_END_DT,
       FRST_INST_DTM,
       LAST_MDFY_DTM,
       LOAD_DTM
  FROM BVK_BI_DEPT_L2_DIM_V@NOHL;
DROP TABLE bi_hr_dept_l3_dim;
CREATE TABLE bi_hr_dept_l3_dim AS
SELECT 'NA' REGN_CD,
       CASE
         WHEN LOC_CD = 11 THEN
          81
         WHEN LOC_CD = 12 THEN
          81
         ELSE
          122
       END CPNY_CD,
       LOC_CD,
       DEPT_L1_CD,
       DEPT_L2_CD,
       DEPT_L3_CD,
       DEPT_L3_ENG_NM,
       DEPT_L3_ENG_ABBR_NM,
       DEPT_L3_KOR_NM,
       DEPT_L3_KOR_ABBR_NM,
       COST_CNTR_CD,
       SORT_ORDER,
       USE_YN,
       APPLY_START_DT,
       APPLY_END_DT,
       FRST_INST_DTM,
       LAST_MDFY_DTM,
       LOAD_DTM
  FROM BVK_BI_DEPT_L3_DIM_V@NOHL;
DROP TABLE bi_hr_dept_l4_dim;
CREATE TABLE bi_hr_dept_l4_dim AS
SELECT 'NA' REGN_CD,
       CASE
         WHEN LOC_CD = 11 THEN
          81
         WHEN LOC_CD = 12 THEN
          81
         ELSE
          122
       END CPNY_CD,
       LOC_CD,
       DEPT_L1_CD,
       DEPT_L2_CD,
       DEPT_L3_CD,
       DEPT_L4_CD,
       DEPT_L4_ENG_NM,
       DEPT_L4_ENG_ABBR_NM,
       DEPT_L4_KOR_NM,
       DEPT_L4_KOR_ABBR_NM,
       COST_CNTR_CD,
       SORT_ORDER,
       USE_YN,
       APPLY_START_DT,
       APPLY_END_DT,
       FRST_INST_DTM,
       LAST_MDFY_DTM,
       LOAD_DTM
  FROM BVK_BI_DEPT_L4_DIM_V@NOHL;
 
DROP TABLE bi_hr_dept_l5_dim;
CREATE TABLE bi_hr_dept_l5_dim AS
SELECT 'NA' REGN_CD,
       CASE
         WHEN LOC_CD = 11 THEN
          81
         WHEN LOC_CD = 12 THEN
          81
         ELSE
          122
       END CPNY_CD,
       LOC_CD,
       DEPT_L1_CD,
       DEPT_L2_CD,
       DEPT_L3_CD,
       DEPT_L4_CD,
       DEPT_L5_CD,
       DEPT_L5_ENG_NM,
       DEPT_L5_ENG_ABBR_NM,
       DEPT_L5_KOR_NM,
       DEPT_L5_KOR_ABBR_NM,
       COST_CNTR_CD,
       SORT_ORDER,
       USE_YN,
       APPLY_START_DT,
       APPLY_END_DT,
       FRST_INST_DTM,
       LAST_MDFY_DTM,
       LOAD_DTM
  FROM BVK_BI_DEPT_L5_DIM_V@NOHL;

INSERT INTO BI_HR_LABOR_COST_FCT
SELECT * FROM BI_HR_LABOR_COST_FCT@PRODR12;



CREATE TABLE BI_HR_COST_CNTR_DIM AS
SELECT * FROM BVK_BI_COST_CNTR_DIM_V@nohl;


CREATE TABLE bi_d_cm_ACC_MAPPING_CODE AS
SELECT LOOKUP_CODE NK_ACCOUNT,
       MEANING,
       DESCRIPTION,
       TAG GLOBAL_ACCOUNT,
       START_DATE_ACTIVE,
       END_DATE_ACTIVE,
       ENABLED_FLAG,
       LOOKUP_TYPE
  FROM FND_LOOKUP_VALUES_VL@PRODR12
WHERE lookup_type = 'NBI_DW_ACCOUNT_MAPPING_CODE'
order by LOOKUP_CODE


CREATE TABLE BI_HR_COST_ACNT_L1_DIM AS
select regn_cd,
cpny_cd,
CASE WHEN loc_cd = 'S' THEN 11
     WHEN loc_cd = 'Y' THEN 12
       ELSE 13 END LOC_CD,
acnt_class_cd,
cost_acnt_ctg_cd,
cost_acnt_l1_cd,
COST_ACNT_L1_ENG_NM,
SYSDATE LOAD_DTM FROM BI_HR_COST_ACNT_L1_DIM@PRODR12 ;
CREATE TABLE BI_HR_COST_ACNT_L2_DIM AS
select regn_cd,
cpny_cd,
CASE WHEN loc_cd = 'S' THEN 11
     WHEN loc_cd = 'Y' THEN 12
       ELSE 13 END LOC_CD,
acnt_class_cd,
cost_acnt_ctg_cd,
cost_acnt_l1_cd,
cost_acnt_l2_cd,
cost_acnt_l2_eng_nm,
SYSDATE LOAD_DTM FROM BI_HR_COST_ACNT_L2_DIM@PRODR12 ;
CREATE TABLE BI_HR_COST_ACNT_L3_DIM AS
select regn_cd,
cpny_cd,
CASE WHEN loc_cd = 'S' THEN 11
     WHEN loc_cd = 'Y' THEN 12
       ELSE 13 END LOC_CD,
acnt_class_cd,
cost_acnt_ctg_cd,
cost_acnt_l1_cd,
cost_acnt_l2_cd,
cost_acnt_l3_cd,
cost_acnt_l3_eng_nm,
SYSDATE LOAD_DTM FROM BI_HR_COST_ACNT_L3_DIM@PRODR12 ;
CREATE TABLE BI_HR_COST_ACNT_L4_DIM AS
select regn_cd,
cpny_cd,
CASE WHEN loc_cd = 'S' THEN 11
     WHEN loc_cd = 'Y' THEN 12
       ELSE 13 END LOC_CD,
acnt_class_cd,
cost_acnt_ctg_cd,
cost_acnt_l1_cd,
cost_acnt_l2_cd,
cost_acnt_l3_cd,
cost_acnt_l4_cd,
cost_acnt_l4_eng_nm,
SYSDATE LOAD_DTM FROM BI_HR_COST_ACNT_L4_DIM@PRODR12 ;

TRUNCATE TABLE BI_HR_OVER_TIME_PLAN_FCT;
INSERT INTO BI_HR_OVER_TIME_PLAN_FCT
  SELECT BASE_YR,
         HALF_YR,
         QUTR_YR,
         BASE_MM,
         FSCL_YR,
         FSCL_MM,
         'NA' REGN_CD,
         CASE
           WHEN LOC_CD = 11 THEN
            81
           WHEN LOC_CD = 12 THEN
            81
           ELSE
            122
         END CPNY_CD,
         LOC_CD,
         COST_CNTR_CD,
         JOB_GRP_CD,
         PLAN_OVER_TIME,
         LOAD_DTM
    FROM BVK_BI_OT_PLAN_UPLOAD@NOHL;

  TRUNCATE TABLE BI_HR_HEAD_COUNT_PLAN_FCT;
  INSERT INTO BI_HR_HEAD_COUNT_PLAN_FCT
    SELECT
    base_yr,
  half_yr,
  qutr_yr,
  base_mm,
  fscl_yr,
  fscl_mm,
           'NA' REGN_CD,
           CASE
             WHEN LOC_CD = 11 THEN
              81
             WHEN LOC_CD = 12 THEN
              81
             ELSE
              122
           END CPNY_CD,
           LOC_CD,
  cost_cntr_cd,
  job_grp_cd,
  job_rank_cd,
  plan_head_count,
  SYSDATE load_dtm
      FROM BVK_BI_OT_HEAD_COUNT_UPLOAD@NOHL;

SELECT DISTINCT paymth FROM bi_hr_pay_result_fct;
SELECT DISTINCT paymth FROM bvk_bi_pay_results@nohl;
