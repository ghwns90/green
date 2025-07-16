SELECT  first_name, last_name
FROM    employees
WHERE   salary = (
    SELECT MIN(E.salary) FROM employees E
    WHERE E.department_id = (
        SELECT department_id FROM departments
        WHERE department_name = 'IT'
    )
);

SELECT  employee_id,
        TO_CHAR(start_date,'YYYY-MM-DD'),
        TO_CHAR(end_date,'YYYY-MM-DD'),
        job_id,
        department_id
FROM    job_history
UNION
SELECT  employee_id, 
        TO_CHAR(hire_date,'YYYY-MM-DD'), '근무중', job_id, department_id
FROM    employees
ORDER BY employee_id;

-------------------------------------------------------------------------

---- VIEW

-- 1) INLINE VIEW
--SQL문을 테이블처럼 사용하는 기술
--FROM 뒤에 INLINE VIEW 뒤에 ORDER BY 사용가능
--그외는 SUBQUERY 내부에 ORDER BY 사용 불가능

SELECT * FROM
(
    SELECT  employee_id                사번, 
            first_name||' '||last_name 이름,
            email || '@green.com'      이메일,
            phone_number               전화
    FROM    employees
) T
WHERE T.사번 IN (100, 101, 102);

-- 2) VIEW 생성 **중요 : 한번 저장하면 영구 보관되고 
CREATE OR REPLACE VIEW "HR"."VIEW_T" ("사번", "이름", "이메일", "전화") AS 
SELECT  employee_id                사번, 
        first_name||' '||last_name 이름,
        email || '@green.com'      이메일,
        phone_number               전화
FROM    employees;

SELECT * FROM VIEW_T;

-- 3) WITH
WITH A AS (
    SELECT  employee_id                사번, 
            first_name||' '||last_name 이름,
            email || '@green.com'      이메일,
            phone_number               전화
    FROM    employees
)
SELECT * FROM A;

----------------------------------------------------------------------------
--사번, 업무시작일, 업무종료일, 담당업무, 부서번호
SELECT * FROM
(
    SELECT  employee_id                       EMPID,
            TO_CHAR(start_date,'YYYY-MM-DD')  SDATE,
            TO_CHAR(end_date,'YYYY-MM-DD')    EDATE,
            job_id                            JOBID,
            department_id                     DEPTID
    FROM    job_history
    UNION
    SELECT  employee_id, 
            TO_CHAR(hire_date,'YYYY-MM-DD'), '근무중', job_id, department_id
    FROM    employees
) T
WHERE SUBSTR(T.SDATE, 1,4) = '2015';

-- CROSS JOIN - 카티션 프로덕트 : 조건없는 조인

-- 등가 조인 : EQUI JOIN - 조건에 =을 사용하는 조인
-- INNER JOIN : 양쪽 다 존재하는 DATA만, NULL 빼고
SELECT  d.department_name, e.first_name, e.last_name
FROM    departments d, employees e
WHERE   d.department_id = e.department_id
ORDER BY d.department_name, first_name;

---- SELF JOIN
SELECT e1.employee_id, e1.first_name, e1.last_name, e2.first_name, e2.last_name
FROM employees e1, employees e2
WHERE e2.employee_id = e1.manager_id
ORDER BY e1.employee_id;

SELECT e1.employee_id, e1.first_name, e1.last_name, e2.first_name, e2.last_name
FROM employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
ORDER BY e1.employee_id;

-- 계층형 쿼리 CASCADING
--계층형 쿼리 - 계층구조 hirerachy  
-- LEVEL  :  계층형 쿼리의 레벨을 구하는 예약어
-- 직원번호, 직원명, 레벨, 부서명
 SELECT              E.EMPLOYEE_ID                       직원번호, 
                     LPAD(' ', 3*(LEVEL-1)) || E.FIRST_NAME || ' ' || E.LAST_NAME  직원명, 
                     LEVEL                               레벨,    -- 1~
                     D.DEPARTMENT_NAME                   부서명
  FROM               EMPLOYEES  E, DEPARTMENTS D
  WHERE              E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
 --START WITH         E.MANAGER_ID = 100
  START WITH         E.MANAGER_ID  IS NULL
  CONNECT BY PRIOR   E.EMPLOYEE_ID = E.MANAGER_ID;

-- START WITH : 시작점
-- CONNECT BY PRIOR - 연결 조건
-- LEVEL : 계층형구조에서만 사용하는 의사칼럼으로 자동으로 레벨을 부여  
--------------------------------------------------------------------------

---- NOT EQUI JOIN : 비등가 조인 조인 조건에 = 을 사용하지 않는 조인

--직원등급
-- 월급
--  20000  초과   : S
--  15001 ~ 20000 : A
--  10001 ~ 15000 : B
--   5001 ~ 10000 : C
--   3001 ~  5000 : D
--      0 ~  3000 : E

SELECT  employee_id                     직원번호,
        first_name || ' ' || last_name  직원명,
        salary                          월급,
        CASE
            WHEN salary > 20000 THEN                 'S'
            WHEN salary between 15001 AND 20000 THEN 'A'
            WHEN salary between 10001 AND 15000 THEN 'B'
            WHEN salary between 5001 AND 10000  THEN 'C'
            WHEN salary between 3001 AND 5000   THEN 'D'
            WHEN salary between 0 AND 3000      THEN 'E'
        END    등급
FROM    employees;

-- TABLE 생성
--- PRIMARY KEY : 데이터 중복안됨, NULL 이 들어갈 수 없음

--직원등급
--  20000  초과   : S--  15001 ~ 20000 : A--  10001 ~ 15000 : B--   5001 ~ 10000 : C--   3001 ~  5000 : D--      0 ~  3000 : E

CREATE TABLE SALGRADE
(
    GRADE   VARCHAR2(1) PRIMARY KEY
   ,LOSAL   NUMBER(11)
   ,HISAL   NUMBER(11)
);

INSERT INTO SALGRADE (GRADE, LOSAL, HISAL)
VALUES               ('S'  , 20001, 99999999999);
INSERT INTO SALGRADE VALUES ('A', 15001, 20000);
INSERT INTO SALGRADE VALUES ('B', 10001, 15000);
INSERT INTO SALGRADE VALUES ('C',  5001, 10000);
INSERT INTO SALGRADE VALUES ('D',  3001,  5000);
INSERT INTO SALGRADE VALUES ('E',     0,  3000);

DELETE FROM salgrade where grade = 'E';
COMMIT;
select * from salgrade ORDER BY grade;

SELECT  e.employee_id                      직원번호,
        e.first_name || ' ' || e.last_name 직원명,
        e.salary                           월급,
        sg.grade                           등급
FROM    employees e, salgrade sg
WHERE   e.salary BETWEEN sg.losal AND sg.hisal
ORDER BY e.employee_id;

-------------------------------------------------------------------

-- 분석함수와 WINDOW 함수
--- 1. ROW_NUMBER() : 줄번호
--- 2. RANK()       : 석차
--- 3. DENSE_RANK() : 석차
--- 4. NTILE()      : 그룹으로 분류
--- 5. LISTAGG()

-- 자료를 10개만 출력 - 페이징기법 : DATABASE 에서 자료를 10개만 조회한다
SELECT      employee_id, first_name, last_name, salary
FROM        employees e
ORDER BY    salary DESC NULLS LAST;

-- ) OLD 문법 ROWNUM - 의사칼럼 기능
-- 정렬하거나 할 때 순서 문제로 사용하기가 어려운 점 있다 - 비추
SELECT  ROWNUM, employee_id, first_name, last_name, salary
FROM    employees E
WHERE   ROWNUM BETWEEN 1 AND 10
ORDER BY salary desc NULLS LAST;

-- ) ANSI 문법 : ROW_NUMBER()

SELECT *
FROM
(
    SELECT ROW_NUMBER() OVER(ORDER BY salary DESC NULLS LAST) AS RN,
           employee_id, first_name, last_name, salary
    FROM   employees
) T
WHERE RN BETWEEN 11 AND 20;

    --MYSQL 페이징 
    -- SELECT * FROM TABLE1 LIMIT 1, 10; - 1~10까지 조회한다 ROW_NUMBER() 보다 속도 빠름 

-- ) OFFSET (ORACLE 12C 부터 가능한)
SELECT *
FROM    employees
ORDER BY salary DESC NULLS LAST
OFFSET  0 ROWS FETCH NEXT 10 ROWS ONLY;
-- 0번부터 10개

--------------------------------------------------------------------------

-- RANK()
--월급순으로 석차를 출력
SELECT *
FROM
(
SELECT  employee_id 사번,
        first_name  이름,
        salary      월급,
        RANK() OVER (ORDER BY salary DESC NULLS LAST) 석차
FROM    employees
) T
WHERE T.석차 BETWEEN 1 AND 10; 


------------------------------------------------------------------------

-- LISTAGG()
SELECT department_id
FROM employees;

SELECT DISTINCT department_id
FROM employees;

SELECT LISTAGG(DISTINCT department_id, ',')
FROM employees;

SELECT LISTAGG(DISTINCT department_id, ',') WITHIN GROUP(ORDER BY department_id DESC)
FROM employees;












