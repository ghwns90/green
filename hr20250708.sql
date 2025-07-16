select * from tab; -- table 정보보기

SELECT        FIRST_NAME,  LAST_NAME
 FROM         EMPLOYEES
 --  WHERE
 ORDER BY     LAST_NAME ASC
;

-- 직원의 이름을 성과 이름을 부텽서 출력
SELECT       FIRST_NAME || ' ' || LAST_NAME AS 이름
 FROM        EMPLOYEES 
 ORDER BY    FIRST_NAME || ' ' || LAST_NAME ASC;
 -- ORDER BY 이름 ASC;   -- 별칭(aLIAS)
 -- ORDER BY 1 ASC;  -- 칼럼중의 1번째
 
 -- 부서번호가 60인 직원정보(번호, 이름, 이메일, 부서번호)
 SELECT     EMPLOYEE_ID, 
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            DEPARTMENT_ID             -- 번호, 이름, 이메일, 부서번호     
  FROM      EMPLOYEES
  WHERE     DEPARTMENT_ID = 60;      -- 부서번호가 6
 
 -- 부서번호가 90인 직원정보
 SELECT     EMPLOYEE_ID, 
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            DEPARTMENT_ID             -- 번호, 이름, 이메일, 부서번호     
  FROM      EMPLOYEES
  WHERE     DEPARTMENT_ID = 90;      -- 부서번호가 6
 
 
 -- 부서번호가 60, 90 부서의 직원정보
 SELECT     EMPLOYEE_ID, 
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            DEPARTMENT_ID             -- 번호, 이름, 이메일, 부서번호     
  FROM      EMPLOYEES
  WHERE     DEPARTMENT_ID = 60      -- 부서번호가 6
   OR       DEPARTMENT_ID = 90;
 
 SELECT     EMPLOYEE_ID, 
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            DEPARTMENT_ID             -- 번호, 이름, 이메일, 부서번호     
  FROM      EMPLOYEES
  WHERE     DEPARTMENT_ID IN ( 60, 90 );      -- 부서번호가 6
 
-- 1. 월급이 12000 이상인 직원의 번호, 이름, 이메일, 월급을 웕긊순으로 출력
SELECT      EMPLOYEE_ID                       "직원의 번호",
            FIRST_NAME || ' ' ||  LAST_NAME   "이름", 
            EMAIL                             "이메일", 
            SALARY                            "월급"
  FROM      EMPLOYEES   
  WHERE     SALARY     >=    12000            -- 월급이 12000 이
  ORDER BY  SALARY    DESC
  ; 
 
-- 2. 월급이 10000~15000 인 직원의 사번, 이름, 월급, 부서번호
1)
SELECT       EMPLOYEE_ID                       사번, 
             FIRST_NAME || ' ' || LAST_NAME    이름, 
             SALARY                            월급, 
             DEPARTMENT_ID                     부서번호
 FROM        EMPLOYEES
 WHERE       10000 <=  SALARY        
  AND                  SALARY  <= 15000       --  월급이 10000~15000 
 ORDER BY    SALARY  DESC;

2) 
SELECT       EMPLOYEE_ID                       사번, 
             FIRST_NAME || ' ' || LAST_NAME    이름, 
             SALARY                            월급, 
             DEPARTMENT_ID                     부서번호
 FROM        EMPLOYEES
 WHERE       SALARY BETWEEN 10000 AND 15000     --  월급이 10000~15000 
 ORDER BY    SALARY  DESC;

 
-- 3. 직업 ID 가 IT_PROG 인 직원 명단
SELECT       EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
 FROM        EMPLOYEES 
 WHERE       JOB_ID = 'IT_PROG';

 
-- 4. 직원이름이 GRANT 인 직원을 찾으세요 
UPPER()   : 모두 대문자로
LOWER()   : 모두 소문자로
INITCAP() : 첫글자만 대문자로

SELECT       EMPLOYEE_ID                      사번, 
             FIRST_NAME  || ' ' || LAST_NAME  이름, 
             EMAIL                            이메일 
 FROM        EMPLOYEES  
 WHERE       UPPER(FIRST_NAME)  =  'GRANT'
  OR         UPPER(LAST_NAME)   =  'GRANT';

 
-- 5. 사번, 월급, 10% 인상한 월급
SELECT      employee_id            사번, 
            first_name, last_name, 
            salary                 월급, 
            salary * 1.1           인상월급
 FROM       EMPLOYEES;
 
  
-- 6. 50 번 부서의 직원명단, 월급, 부서번호
SELECT     FIRST_NAME || ' ' || LAST_NAME   직원명단, 
           SALARY                           월급, 
           DEPARTMENT_ID                    부서번호
 FROM      EMPLOYEES
 WHERE     DEPARTMENT_ID   =  50;           

   
-- 7. 20,  80, 60, 90 번 부서의 직원명단, 월급, 부서번호
SELECT     FIRST_NAME || ' ' || LAST_NAME    직원명단, 
           SALARY                            월급, 
           DEPARTMENT_ID                     부서번호
 FROM      EMPLOYEES
 -- WHERE     DEPARTMENT_ID   IN  ( 20,  80, 60, 90 );
 WHERE     DEPARTMENT_ID   =   20
   OR      DEPARTMENT_ID   =   80
   OR      DEPARTMENT_ID   =   60
   OR      DEPARTMENT_ID   =   90;

-- 중요 데이터 추가(107명 + 2명) 
 SELECT COUNT(*) 
  FROM  EMPLOYEES;
   
INSERT INTO  EMPLOYEES 
  VALUES (207, '길동', '홍', 'HONGGD', '010-1234-5678', SYSDATE,
      'IT_PROG', NULL, NULL, NULL, NULL);
INSERT INTO  EMPLOYEES 
  VALUES (208, '라니', '카', 'RINA', '010-2345-6789', SYSDATE,
      'IT_PROG', NULL, NULL, NULL, NULL);
UPDATE  EMPLOYEES
 SET    FIRST_NAME = '리나'
 WHERE  EMPLOYEE_ID = 208;
 
 SELECT * FROM EMPLOYEES;
 ROLLBACK
 COMMIT;
    
-- 8. 보너스없는 직원명단 (COMMISSION_PCT 가 없다)
-- NULL 값은 IS, IS NOT NULL 로 비교한다 ( = 로 비교 안됨  )
SELECT       FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT   
 FROM        EMPLOYEES
 WHERE       COMMISSION_PCT  IS   NULL;

-- 9. 전화번호가 010으로 시작하는
  -- PATTERN mACHONG : %(0 자 이상 여러자),  _(한 글자)
         sql                        java           css            
  LIKE '010%'  : 010 으로 시작하는  startsWith     [tel^=010]
  LIKE '%010%' : 010 을 포함하는    contains       [tel*=010]
  LIKE '%010'  : 010 으로 끝나는    endsWith       [tel$=010] 
  
  LIKE '김_'   : 이름이 두자이묘 첫글자는 '김'


-- 10. LAST_NAME 세번째,네번째 글자가 LL 인것을 찾아라 
SELECT       FIRST_NAME, LAST_NAME
 FROM        EMPLOYEES 
 WHERE       LAST_NAME   LIKE   '__ll%';

---- 날짜 25/07/08   x 
--  2025-07-08  : 국제 표준
--  08/07/25    : 영국식   일/월/년
--  07/08/25    : 미국식

ALTER  SESSION  SET  NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';   // AM/PM 
SELECT  SYSDATE      FROM  DUAL;    // 25/07/08 -> 2025-07-08 15:14:27  
SELECT  7/2          FROM  DUAL;   -- 3.5
SELECT  0/2          FROM  DUAL;   -- 0
SELECT  2/0          FROM  DUAL;   -- ORA-01476: 제수가 0 입니다
SELECT  SYSTIMESTAMP FROM DUAL;    -- 25/07/08 15:19:04.082000000 +09:00

SELECT  SYSDATE - 7    일주일전날짜,
        SYSDATE       오늘,
        SYSDATE + 7    일주일후날짜
 FROM  DUAL; 
 
SELECT   SYSDATE, ROUND(SYSDATE, 'MONTH'), TRUNC(SYSDATE, 'MONTH')
 FROM    DUAL;
 
SELECT NEXT_DAY(SYSDATE, '월요일') FROM DUAL;  -- 다음 월요일
SELECT LAST_DAY(SYSDATE) FROM DUAL;             -- 2025-07-31 15:44:32 이번달 마자믹 날짜
SELECT TRUNC(SYSDATE, 'MONTH') FROM DUAL;       -- 2025-07-01 00:00:00 이번달 첫번째 날짜

SELECT '2025-12-25' - SYSDATE  FROM DUAL;

-- 10. 입사년월이 17년 2월인 사원출력 -- 입사년월이 17년 2월인 사원출력
SELECT     EMPLOYEE_ID                     사번,
           FIRST_NAME || ' ' || LAST_NAME  이름,
           HIRE_DATE                       입사일
 FROM      EMPLOYEES
 WHERE     '2017-02-01 00:00:00' <= HIRE_DATE  
  AND      HIRE_DATE    <  '2017-03-01 00:00:00';

-- 11. '17/02/07'   에 입사한 사람출력 -- '07/02/07'   에 입사한 사람출력
SELECT     EMPLOYEE_ID                      사번,
           FIRST_NAME || ' ' || LAST_NAME   이름,
           HIRE_DATE                        입사일
 FROM      EMPLOYEES
 WHERE     HIRE_DATE = '2017-02-07';

-- 12 . 오늘 '25/07/08'  입사한 사람
SELECT     EMPLOYEE_ID                      사번,
           FIRST_NAME || ' ' || LAST_NAME   이름,
           HIRE_DATE                        입사일
 FROM      EMPLOYEES
 WHERE     TRUNC(HIRE_DATE)  = '2025-07-08 00:00:00';

-- 입사후 일주일이내인 직원명단
SELECT     EMPLOYEE_ID                      사번,
           FIRST_NAME || ' ' || LAST_NAME   이름,
           HIRE_DATE                        입사일
 FROM      EMPLOYEES
 WHERE     HIRE_DATE  BETWEEN  SYSDATE-7 AND SYSDATE;

-- 화요일 입사자를 출력
SELECT     EMPLOYEE_ID                            사번,
           FIRST_NAME || ' ' || LAST_NAME         이름,
           TO_CHAR(HIRE_DATE, 'YYYY-MM-DD DAY')   입사일
 FROM      EMPLOYEES
 WHERE     TO_CHAR(HIRE_DATE, 'DAY') = '화요일';

--  08월 입사자의  사번, 이름, 입사일를 입사일 순으로C
SELECT     EMPLOYEE_ID                            사번,
           FIRST_NAME || ' ' || LAST_NAME         이름,
           TO_CHAR(HIRE_DATE, 'YYYY-MM-DD DAY')   입사일
 FROM      EMPLOYEES
 WHERE     TO_CHAR( HIRE_DATE, 'MM') = '08'; 


