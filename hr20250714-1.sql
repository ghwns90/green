
SELECT D.department_name 부서명, E.first_name 직원이름, E.phone_number 전화번호, e.email 이메일
FROM   departments D LEFT JOIN employees E ON D.department_id = E.department_id
WHERE  E.employee_id = 110;

-- ORACLE의 부프로그램 : 프로그램의 조각
---- 1. PROCEDURE : SUBROUTINE 프로시저
--              필요에 따라 0개 이상의 결과를 처리할 수 있다.
--              RDB에서는 STORED PROCEDURE
---- 2. FUNCTION : 함수
--              반드시 한개의 RETURN 값을 가져야 한다


-- ORACLE에 함수를 저장 한다.
SELECT  first_name || ' ' || last_name 직원이름,
        salary 월급
FROM    EMPLOYEES
WHERE   employee_id = 107;


CREATE PROCEDURE GET_EMPSAL(IN_EMPID IN NUMBER)
IS
  V_NAME VARCHAR2(45);
  V_SAL  NUMBER(8,2);
  BEGIN
    SELECT  first_name || ' ' || last_name, salary
    INTO    V_NAME,                         V_SAL
    FROM    EMPLOYEES
    WHERE   employee_id = IN_EMPID;
    DBMS_OUTPUT.PUT_LINE(V_NAME);
    DBMS_OUTPUT.PUT_LINE(V_SAL);
  END;
/
SET  SERVEROUTPUT ON;
CALL GET_EMPSAL(120);

---------------------------------------------------------------------

---- 부서번호입력, 해당부서의 최고월급자의 이름, 월급 출력
CREATE PROCEDURE GET_NAME_MAXSAL(IN_DEPTID IN NUMBER, O_NAME OUT VARCHAR2, O_SAL OUT VARCHAR2)
IS
    V_MAXSAL NUMBER(8,2);
    BEGIN
        SELECT  MAX(SALARY)
        INTO    V_MAXSAL
        FROM    EMPLOYEES
        WHERE   DEPARTMENT_ID = IN_DEPTID;
        
        
        SELECT  first_name || ' ' || last_name, salary
        INTO    O_NAME,                         O_SAL
        FROM    EMPLOYEES
        WHERE   SALARY        = V_MAXSAL
        AND     DEPARTMENT_ID = IN_DEPTID;
        
        DBMS_OUTPUT.PUT_LINE(O_NAME);
        DBMS_OUTPUT.PUT_LINE(O_SAL);
    END;
/

SET SERVEROUTPUT ON;
VAR O_NAME VARCHAR2;
VAR O_SAL NUMBER;
CALL GET_NAME_MAXSAL(50, :O_NAME, :O_SAL);
PRINT O_NAME;
PRINT O_SAL;

---- 90번 부서번호 입력, 직원들 출력 (한줄 이상의 출력 못함 - 에러)
CREATE OR REPLACE PROCEDURE GETEMPLIST( IN_DEPTID NUMBER )
IS
    VEID    NUMBER(8,2);
    VFNAME  VARCHAR2(4000); 
    VLNAME  VARCHAR2(4000);
    VPHONE  VARCHAR2(4000);
    BEGIN
        SELECT  employee_id, first_name, last_name, phone_number
        INTO    VEID,       VFNAME,     VLNAME,     VPHONE
        FROM    employees
        WHERE   department_id = IN_DEPTID;
        
        DBMS_OUTPUT.PUT_LINE(VEID);
    END;
/

EXEC    GETEMPLIST(90); -- 에러가 뜸

-- ** SELECT INTO 는 결과가 한줄일때만 사용 가능
-- 해결책 ) 커서(CURSOR) 사용


-- 여러줄 뽑기 CURSOR 예제
CREATE OR REPLACE PROCEDURE GET_EMPLIST(
                        IN_DEPTID IN NUMBER,
                        O_CUR     OUT SYS_REFCURSOR )
AS  
    BEGIN
      OPEN O_CUR FOR
        SELECT  employee_id, first_name, last_name, phone_number          
        FROM    employees
        WHERE   department_id = IN_DEPTID;        
    END;
/

VARIABLE O_CUR REFCURSOR;
EXECUTE GET_EMPLIST(50, :O_CUR);
PRINT O_CUR;