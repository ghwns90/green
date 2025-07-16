SELECT  FIRST_NAME, LAST_NAME, HIRE_DATE, EMAIL
FROM    EMPLOYEES
WHERE   LOWER(JOB_ID) = 'it_prog';

---- SHIPPING 부서의 직원 명단
-- 부서명 SHIPPING 의 부서번호 : 50
/*  SQL문 안에 SQL 문이 들어있으면 SUBQUERY
    반드시 () 안에서 표시된다
    두번 물어봐야 할때
SELECT  department_id
FROM    departments
WHERE   LOWER(department_name) = 'shipping'
*/
-- 50번 부서의 직원 명단
SELECT  FIRST_NAME, LAST_NAME, HIRE_DATE
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID = (
    SELECT  department_id
    FROM    departments
    WHERE   LOWER(department_name) = 'shipping'
);

-------------------------------------------------------

-- JOIN : 여러개의 다른 테이블에 있는 칼럼들을 가지고 와서 새로운 테이블을 만든다

------------- ORACLE OLD 문법

-- SALES 부서의 직원정보를 출력
-- 1) 카티션 프로덕트 == 'CROSS JOIN', 조건이 없는
SELECT first_name, last_name, department_name
FROM   employees, departments;

-- 2) INNER JOIN - 양쪽다 존재하는 데이터 합치기
-- 조건(WHERE) 이 필요하다
SELECT  first_name, last_name, departments.department_name
        ,employees.department_id, departments.department_id
FROM    employees, departments
WHERE   employees.department_id = departments.department_id;
-- 이런식으로 각각의 테이블명을 앞에 붙여서 사용
SELECT  E.employee_id, E.first_name, E.last_name, D.department_name
FROM    employees E, dpeartments D
WHERE   E.department_id = D.department_id;

-- 3) OUTER JOIN
--부서명, 부서직원 이름
--모든 부서명 출력 : departments 부서정보 27개 부서
--직원 정보는 해당 부서의 직원이 있으면 부서이름, 명단 출력
--                      직원이 없으면 부서이름, '직원없음'
-- (+) : 자료가 없는(NULL) 쪽에 붙인다

-- 3-1) LEFT OUTER JOIN : 기준이 왼쪽이다. (+)가 없는 쪽이다.
--                        기준칼럼(왼쪽)은 모두 출력하고, 반대쪽은 없으면 NULL임 
SELECT  D.department_name                  부서명, 
        DECODE(E.first_name || ' ' || E.last_name, ' ', 
                '직원없음', E.first_name || ' ' || E.last_name) 부서직원이름
FROM    departments D, employees E
WHERE   D.department_id = E.department_id(+);   --122, 

-- 3-2) RIGHT OUTER JOIN : 기준이 LEFT OUTER JOIN 과 반대
SELECT  D.department_name                  부서명, 
        DECODE(E.first_name || ' ' || E.last_name, ' ', 
                '직원없음', E.first_name || ' ' || E.last_name) 부서직원이름
FROM    departments D, employees E
WHERE   D.department_id(+) = E.department_id;   -- 109

-- 4) FULL OUTER JOIN 문법이 없다.

------------------------------------------------------------------
-------------------- ANSI 표준 문법
-- CROSS JOIN
SELECT first_name, last_name, department_name
FROM   employees CROSS JOIN departments;

-- (INNER) JOIN, ON : INNER JOIN 문법에 조건은 WHERE 대신 ON을 사용
SELECT  first_name, last_name, department_name
FROM    employees E INNER JOIN departments D ON E.department_id = D.department_id;

-- LEFT (OUTER) JOIN, ON
SELECT  first_name, last_name, department_name
FROM    employees E LEFT JOIN departments D ON E.department_id = D.department_id;

-- RIGHT (OUTER) JOIN, ON
SELECT  first_name, last_name, department_name
FROM    employees E RIGHT JOIN departments D ON E.department_id = D.department_id;

--FULL (OUTER) JOIN
SELECT  first_name, last_name, department_name
FROM    employees E FULL JOIN departments D ON E.department_id = D.department_id;

------------------------------------------------------------------------

---- 직원이름, 담당업무(JOB_TITLE)
-- OLD 문법
SELECT  E.first_name || ' ' || E.last_name 이름, 
        J.job_title 담당업무
FROM    employees E,
        jobs J
WHERE   E.job_id = J.job_id(+);
-- ANSI 문법
SELECT  E.first_name || ' ' || E.last_name 이름, job_title 담당업무
FROM    employees E LEFT JOIN jobs J ON E.job_id = J.job_id;

SELECT  E.first_name || ' ' || E.last_name 이름, job_title 담당업무
FROM    employees E JOIN jobs J ON E.job_id = J.job_id;

---- 부서명, 부서위치(CITY, STREET_ADDRESS)
-- OLD 문법
SELECT  D.department_name 부서명, 
        L.city 도시, 
        L.street_address 주소
FROM    departments D, 
        locations L
WHERE   D.location_id = L.location_id;
-- ANSI 문법
SELECT  D.department_name, L.city, L.street_address
FROM    departments D LEFT JOIN locations L ON D.location_id = L.location_id;

---- 직원명, 부서명, 부서위치(CITY, STREET_ADDRESS)
-- OLD 문법
SELECT  E.first_name|| ' ' ||E.last_name 이름,
        D.department_name 부서명,
        L.city 도시,
        L.street_address 주소
FROM    employees E, 
        departments D, 
        locations L
WHERE   E.department_id = D.department_id(+)
AND     D.location_id = L.location_id(+);
-- ANSI 문법
SELECT  E.first_name|| ' ' ||E.last_name 이름,
        D.department_name 부서명,
        L.city CITY,
        L.street_address 주소
FROM    employees E LEFT JOIN departments D ON E.department_id = D.department_id
                    LEFT JOIN locations L   ON D.location_id = L.location_id;
                    
-- 직원명, 부서명, 국가, 부서위치(CITY, STREET_ADDRESS)
SELECT  D.department_name     부서명, 
        E.first_name || ' ' || E.last_name 직원명, 
        C.country_name      국가, 
        L.state_province, L.city, L.street_address 부서위치
FROM    departments D 
        LEFT JOIN employees E ON D.department_id = E.department_id
        LEFT JOIN locations L ON D.location_id   = L.location_id
        LEFT JOIN countries C ON L.country_id    = C.country_id    
ORDER BY department_name ASC;

-----------------------------------------------------------------------
-- 부서명, 국가 : 부서 모든 부서 : 27줄 이상
SELECT  D.department_name 부서, 
        C.country_name 국가
FROM    departments D
        JOIN locations L ON D.location_id = L.location_id
        JOIN countries C ON L.country_id = C.country_id;

-- 직원명, 부서위치 단 it 부서만
SELECT  E.first_name||' '||E.last_name 이름,
        L.street_address 부서위치,
        D.department_name 부서명
FROM    employees E
        LEFT JOIN departments D ON E.department_id = D.department_id
        LEFT JOIN locations L   ON D.location_id   = L.location_id
WHERE   D.department_name = 'IT';

----------------------------------------------------------------------

-- 부서명별 월급평균
SELECT  D.department_name 부서명, 
        ROUND(AVG(E.salary),3) 월급평균
FROM    employees E RIGHT JOIN departments D ON E.department_id = D.department_id
GROUP BY D.department_name
ORDER BY 월급평균 ASC;

-----------------------------------------------------------------------

---- 결합연산자 - 줄단위 결합
--- 조건   - 두 테이블의 칸수와 타입이 동일해야한다
-- 1) UNION        중복 제거
-- 2) UNION ALL    중복 포함
-- 3) INTERSECT    교집합 공통부분
-- 4) MINUS        차집합 A-B

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;  -- 34
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;  -- 45
-- UNION ALL : 위와 아랫줄을 수직으로 결합
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80
UNION ALL
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;  -- 79

-- 주의사항 ) 규칙만 맞으면 의미없는 데이터도 UNION 가능 -> 할필요없음
SELECT employee_id, first_name FROM employees
UNION
SELECT department_id, department_name FROM departments;

-------------------------------------------------------------------------

SELECT  first_name||' '||last_name       이름,
        SYSDATE - hire_date              근무일수,
        TRUNC((SYSDATE - hire_date) / 365.2422) 근무연수,
        TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) 근무연수
FROM    employees;        