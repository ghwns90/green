


-- 1) 직원번호, 직원이름, 월급, 입사일, 부서번호 조회
SELECT  EMPLOYEE_ID 직원번호, 
        FIRST_NAME || ' ' || LAST_NAME 직원이름, 
        SALARY 월급, 
        TO_CHAR(HIRE_DATE, 'YYYY-MM-DD HH24:MM:SS') 입사일, 
        DEPARTMENT_ID 부서번호
FROM    EMPLOYEES E;

-- 2) 직원번호, 이름, 월급, 연봉(월급*12 + 월급*COMMISSION_PCT) 출력
--      부서번호 '50,60,90 번 부서를 대상'으로 출력은 '월급 많은 순'으로

SELECT   EMPLOYEE_ID 직원번호,
         FIRST_NAME || ' ' || LAST_NAME 직원이름, 
         SALARY 월급,
         DECODE(COMMISSION_PCT, NULL, (SALARY*12), 
                                      (SALARY*12)+(SALARY*COMMISSION_PCT)) 연봉
FROM     EMPLOYEES E
WHERE    DEPARTMENT_ID IN (50, 60, 90)
ORDER BY 월급 DESC;

-- 3) 월요일 입사한 사람의 명단을 출력
SELECT  *
FROM    EMPLOYEES E
WHERE   TO_CHAR(HIRE_DATE, 'DAY') = '월요일';

-- 4) 전체 부서명과 직원명을 출력, 직원명이 없으면 null로 출력
--    출력시 '부서명순으로 정렬'하고 같은 부서인 경우 '직원명으로 정렬'

SELECT   D.DEPARTMENT_NAME 부서명,
         DECODE(E.FIRST_NAME || ' ' || E.LAST_NAME, ' ', NULL,
                                                       E.FIRST_NAME || ' ' || E.LAST_NAME) 직원명
FROM     DEPARTMENTS D LEFT JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
ORDER BY 부서명 ASC, 직원명 ASC;

DESC EMPLOYEES;