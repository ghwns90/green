    -- SQL 명령순서
    -- FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY
    -- WHERE 문 안에 집계함수 사용불가



--   부서번호 80 이 아닌 직원

SELECT  employee_id                        사번,
        first_name || ' ' || last_name     이름, 
        phone_number                       전화,  
        department_id                      부서번호
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID != 80; -- 아니다 !=, <>, ^=

-- >, <, >=, <=, =, != (<>)
-- 나머지 MOD(7, 2)

SELECT  7/2, ROUND(123.456, 2), ROUND(163.456, -2),
             TRUNC(123.456, 2), TRUNC(163.456, -2)
FROM    DUAL;

-- 직원사번, 입사일 
SELECT  employee_id 사번, 
        hire_date 입사일,
        TO_CHAR(hire_date, 'YYYY-MM-DD DAY') 
FROM    EMPLOYEES;

-- 2025년 07월 09일 10시 05분 04초 오전 수요일

SELECT  SYSDATE,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM DAY') 날짜,
        TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초" AM DAY') 날짜2,
        TO_CHAR(SYSDATE, 'YYYY"年"MM"月"DD"日"HH"時"MI"分"SS"秒" AM DAY') 날짜3
FROM    DUAL;

-- DECODE() 함수 : 다중 IF 
-- 사번, 이름, 부서명
SELECT  employee_id 사번, 
        first_name || ' ' || last_name 이름,
        DECODE(
            department_id, 60, 'IT',
                           50, 'Shipping',
                           80, 'Sales',
                                '그외'
        ) 부서명
FROM    EMPLOYEES;

-- * NULL 은 계산식에 포함되면 결과는 NULL 이다

-- 직원명단, 직원의 월급, 보너스 출력 연봉 출력

SELECT  EMPLOYEE_ID                                   직원명단, 
        DECODE(SALARY, NULL, '신입사원', SALARY)      직원월급, 
        NVL(SALARY * COMMISSION_PCT, 0)               보너스, 
        SALARY * 12 + NVL(SALARY * COMMISSION_PCT, 0) 연봉
FROM    EMPLOYEES;

-- CASE WHEN
    -- WHEN SCORE BETWEEN 90 AND 100     THEN 'A'
    -- WHEN 90 <= SCORE AND SCORE <= 100 THEN 'A'
    
SELECT  employee_id                     사번,
        first_name || ' ' || last_name  이름,
        CASE    department_id 
            WHEN 90 THEN 'Executive'
            WHEN 80 THEN 'Sales'
            WHEN 60 THEN 'IT'
            WHEN 50 THEN 'Shipping'
            ELSE         '그외'
        END 부서명
FROM    EMPLOYEES;

SELECT  employee_id                     사번,
        first_name || ' ' || last_name  이름,
        CASE    
            WHEN department_id = 90 THEN 'Executive'
            WHEN department_id = 80 THEN 'Sales'
            WHEN department_id = 60 THEN 'IT'
            WHEN department_id = 50 THEN 'Shipping'
            ELSE         '그외'
        END 부서명
FROM    EMPLOYEES;

-------------------------------------------------------------------


-- 년월일시분초오전오후 : 年月日時分秒午前午後
-- 日 月 火 水 木 金 土 曜日

SELECT TO_CHAR(SYSDATE, 'YYYY') || '年'
    || TO_CHAR(SYSDATE, 'MM')   || '月'
    || TO_CHAR(SYSDATE, 'DD')   || '日'
    || TO_CHAR(SYSDATE, 'HH')   || '時'
    || TO_CHAR(SYSDATE, 'MI')   || '分'
    || TO_CHAR(SYSDATE, 'SS')   || '秒'
    || DECODE(TO_CHAR(SYSDATE, 'AM'), '오전', '午前',
                                      '오후', '午後')   
    ||' '|| 
    DECODE(TO_CHAR(SYSDATE, 'DY'), 
                        '월', '月',                                        
                        '화', '火',
                        '수', '水',
                        '목', '木',
                        '금', '金',
                        '토', '土',
                        '일', '日')
    ||'曜日'
    
FROM    DUAL;   

----------------------------------------------------------

 -- IF 를 사용한다
-- 1) NVL()

SELECT  employee_id                사번, 
        first_name||' '||last_name 이름, 
        salary                     월급, 
        NVL( commission_pct, 0)    보너스,
        DECODE( commission_pct, NULL, '보너스없음' , commission_pct)
FROM    EMPLOYEES;

-- 2) NULLIF (expr1, expr2)
-- 둘을 비교해서 같으면 null, 같지 않으면 expr1

---------------------------------------------------------------------------

--  집계 함수 : AGGREGATE  함수
--  모든 집계 함수는 null 값은 포함하지 않는다
--  ~별 인원수
--  집계함수  COUNT(), SUM(), AVG(), MIN(), MAX(), VARIANCE(expr)분산, STDDEV(expr)표준편차
--  그룹핑    GROUP BY

-- 직원의 인원수 COUNT()

SELECT * FROM employees; -- 전체 명단
SELECT COUNT(*) FROM employees; -- 직원의 인원수
SELECT COUNT(employee_id) FROM employees;   --109
SELECT COUNT(department_id) FROM employees; --106 (NULL 3명)

SELECT * FROM employees
WHERE department_id IS NULL;

-- 전체직원의 월급 합
SELECT COUNT(salary) FROM employees;
SELECT SUM(salary) FROM employees;  -- 월급 합
SELECT AVG(salary) FROM employees;  -- 월급 평균
SELECT MIN(salary) FROM employees;  -- 최소 월급
SELECT MAX(salary) FROM employees;  -- 최대 월급

-- 60번 부서의 평균 월급
SELECT AVG(salary) FROM employees
WHERE department_id = 60;

-- EMPLOYEES 테이블의 부서수를 알고 싶다
SELECT department_id FROM employees;
SELECT COUNT(department_id) FROM employees;

-- 중복을 제거한 부서의 수를 출력
-- DISTINCT 중복 제거
SELECT DISTINCT department_id FROM employees;
SELECT COUNT(DISTINCT department_id) 중복없는부서갯수 FROM employees;
SELECT COUNT(*) FROM departments;

-- 입사일에 해당되는 달의 첫번째 날짜와 마지막 날짜를 출력 
SELECT  employee_id  사번,
        TO_CHAR(hire_date, 'YYYY-MM-DD')    입사일,
        TO_CHAR(TRUNC(hire_date, 'MONTH'), 'YYYY-MM-DD') 입사월첫날,
        TO_CHAR(LAST_DAY(hire_date), 'YYYY-MM-DD')       입사월마지막날짜
FROM    employees;

-- 직원이 근무하는 부서의 수
SELECT COUNT(DISTINCT department_id) FROM employees;

-- 직원수, 월급합, 월급평균, 최대월급, 최소월급
SELECT COUNT(employee_id) 직원수,
       SUM(salary) 월급합,
       AVG(salary) 월급평균,
       MAX(salary) 최대월급,
       MIN(salary) 최소월급
FROM    employees;

-- 부서 60번 부서 인원수, 월급합, 월급평균
SELECT  COUNT(employee_id) 부서인원수, 
        SUM(salary) 월급합, 
        ROUND(AVG(salary),3) 월급평균
FROM    employees
WHERE  department_id NOT in (50, 60, 80);
/*WHERE   department_id = 60
OR      department_id = 50
OR      department_id = 80;*/

-- 직원이름, 부서번호, 부서명 - CASE WHEN
SELECT first_name|| ' ' ||last_name 직원이름,
       department_id,
       CASE
        WHEN department_id = 10 THEN 'Administration'
        WHEN department_id = 20 THEN 'Marketing'
        WHEN department_id = 30 THEN 'Purchasing'
        WHEN department_id = 40 THEN 'Human Resources'
        WHEN department_id = 50 THEN 'Shipping'
        WHEN department_id = 60 THEN 'IT'
        WHEN department_id = 70 THEN 'Public Realtions'
        WHEN department_id = 80 THEN 'Sales'
        WHEN department_id = 90 THEN 'Executive'
        WHEN department_id = 100 THEN 'Finance'
        WHEN department_id = 110 THEN 'Accounting'
        WHEN department_id IS NULL THEN '없음'
       END
FROM    employees;       

-- 부서별 사원수
SELECT department_id      부서번호,
       COUNT(employee_id) 사원수
FROM   employees
GROUP BY department_id -- 일반칼럼과 집계함수를 동시에 사용하면 ~별 통계의 의미로 쓴다
                       -- GROUP BY로 기준을 걸어줘야 에러가 안남
ORDER BY department_id ASC;                  

-- 부서별 인원수, 월급합
SELECT  department_id "부서번호",
        COUNT(employee_id) "부서별 인원수",
        SUM(salary)      "월급합"
FROM    employees
GROUP BY department_id
ORDER BY department_id ASC;

-- 부서별 인원수가 5명이상인 부서번호
SELECT  department_id,
        COUNT(employee_id)
FROM    employees
    -- WHERE   COUNT(employee_id) >= 5
GROUP BY department_id
    -- 집계함수는 조건문에 쓸수가 없다. 그럴땐 WHERE 대신 HAVING 사용
HAVING COUNT(employee_id) >= 5
ORDER BY department_id;

-- 부서별 월급총계가 20000 이상인 부서
SELECT  department_id "부서 번호",
        SUM(salary)   "월급 총계"
FROM    employees
    -- WHERE SUM 집계함수를 조건으로 넣을땐 WHERE 못씀 HAVING
HAVING SUM(salary) >= 20000
GROUP BY department_id
ORDER BY department_id;

-- JOB_ID별 인원수
SELECT  job_id,
        COUNT(employee_id) 인원수
FROM    employees
GROUP BY job_id
ORDER BY job_id;

SELECT  job_id,
        COUNT(employee_id) 인원수
FROM    employees
GROUP BY ROLLUP(job_id)
ORDER BY job_id;

SELECT  job_id,
        COUNT(employee_id) 인원수
FROM    employees
GROUP BY CUBE(job_id)
ORDER BY job_id;

-- 입사일 기준 월별 인원수, 2017년 기준
SELECT  TO_CHAR(hire_date,'MM') 입사월,
        COUNT(employee_id) 인원수
FROM    employees
WHERE   TO_CHAR(hire_date,'YYYY') = '2017'
GROUP BY TO_CHAR(hire_date,'MM')
ORDER BY 입사월;

-- 부서별 최대월급이 14000 이상인 부서의 부서번호와 최대월급
SELECT  department_id   부서번호,
        MAX(salary)     최대월급
FROM    employees
HAVING  MAX(salary) >= 14000
GROUP BY department_id
ORDER BY department_id;

-- 부서별 모우고 같은 부서는 직업별 인워수, 월급평균
SELECT  department_id   부서번호
       ,job_id          직업ID
       ,COUNT(job_id)   직업별인원수
       ,ROUND(AVG(salary)) 월급평균
FROM    employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id, job_id;

--------------------------------------------------------------

--  SUBQUERY : QUERY 문 안에 QUERY 가 들어간다.

-- IT 부서의 직원정보를 출력하시오.
--1) IT 부서의 부서번호 : DEPARTMENTS -- 60
SELECT  DEPARTMENT_ID
FROM    DEPARTMENTS
WHERE   DEPARTMENT_NAME = 'IT';

--2) 60번 부서의 직원정보를 출력
SELECT EMPLOYEE_ID                   사번
      ,FIRST_NAME||' '||LAST_NAME    이름
      ,DEPARTMENT_ID                 부서번호
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 60;

-- 1+2) 서브쿼리
-- 서로 다른 테이블의 겹치는 칼럼을 이용해서 한번에 뽑아내기
SELECT EMPLOYEE_ID                   사번
      ,FIRST_NAME||' '||LAST_NAME    이름
      ,DEPARTMENT_ID                 부서번호
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = (
        SELECT  DEPARTMENT_ID
        FROM    DEPARTMENTS
        WHERE   DEPARTMENT_NAME = 'IT'
);

-- 평균월급보다 많은 월급을 받는 사람의 명단
SELECT  EMPLOYEE_ID 사번
       ,SALARY      월급
FROM    EMPLOYEES
WHERE   SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEES);  -- 서브쿼리는 () 안에

-- SALES 부서의 평균월급보다 많은 월급을 받는 사람의 명단
-- 1) SALES 부서의 부서번호
SELECT  DEPARTMENT_ID
FROM    DEPARTMENTS
WHERE   UPPER(DEPARTMENT_NAME) = 'SALES';

-- 2) 80 번 부서의 평균월급
select  avg(salary)
from    employees
where   department_id = 80;

-- 3) 평균월급보다 많은 월급을 받는 사람의 명단
select  employee_id, first_name||' '||last_name, salary
from    employees
where   salary >= (8955.882352941176470588235294117647058824);

-- 1+2+3
select  employee_id, first_name||' '||last_name, salary
from    employees
where   salary >= (
    select  avg(salary)
    from    employees
    where   department_id = (
        SELECT  DEPARTMENT_ID
        FROM    DEPARTMENTS
        WHERE   UPPER(DEPARTMENT_NAME) = 'SALES'
    )
);

