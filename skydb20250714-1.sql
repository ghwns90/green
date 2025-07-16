계정생성
 sky / 1234
 

Microsoft Windows [Version 10.0.19045.6093]
(c) Microsoft Corporation. All rights reserved.

C:\Users\GGG>sqlplus /nolog

SQL*Plus: Release 21.0.0.0.0 - Production on 월 7월 14 14:31:00 2025
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SQL> conn / as sysdba
연결되었습니다.
SQL> alter session set "_ORACLE_SCRIPT"=true;

세션이 변경되었습니다.

SQL> create user sky identified by 1234;

사용자가 생성되었습니다.

SQL> grant connect, resource to sky;

권한이 부여되었습니다.

SQL> alter user sky default tablespace
  2  users quota unlimited on users;

사용자가 변경되었습니다.

SQL> conn sky/1234
연결되었습니다.
SQL> show user
USER은 "SKY"입니다
SQL> select * from tab;

선택된 레코드가 없습니다.

------------------------------------------------------------------------------

sky에서 hr 계정의 data를 가져온다
SQLPLUS 에서 작업
1. 먼저 hr로 로그인 한다.
WIN+R : CMD
 C:> SQLPLUS HR/1234
 
2. HR 에서 다른계정인 sky에게 select 할 수 있는 권한을 부여
sql> GRANT SELECT ON EMPLOYEES TO sky;
권한이 부여되었습니다
    -- sql> GRANT SELECT, INSERT, UPDATE, DELETE ON EMPLOYEES TO sky;

3. sky로 로그인한다.
sql> conn sky/1234

4. sky에서 hr 계정의 employees 를 조회

select * from hr.employees;
select * from hr.departmets;

-------------------------------------------------------------------------

ORACLE의 TABLE 복사하기
HR의 EMPLOYEES TABLE 복사해서 SKY로 가져온다

[1]  테이블 생성
1. 테이블 복사 
  대상 : 테이블 구조, 데이터 (제약조건의 일부만 복사 (NOT NULL))
    
    1) 구조, 데이터 다 복사, 제약조건은 일부만 복사
    CREATE TABLE EMP1
     AS 
       SELECT * FROM  HR.EMPLOYEES;

    2) 구조, 데이터 복사, 50번, 80번 부서만 복사
     CREATE TABLE EMP2
     AS 
       SELECT * FROM  HR.EMPLOYEES
        WHERE DEPARTMENT_ID IN (  50, 80  );
   
   3) 구조만 복사, DATA 뻬고
     CREATE TABLE EMP3
     AS 
       SELECT * FROM  HR.EMPLOYEES
        WHERE 1 = 0;
        
   4) 구조만 복사된 TABLE EMP3 에 DATA 만 추가
      CREATE TABLE EMP4
      AS 
       SELECT * FROM  HR.EMPLOYEES
        WHERE 1 = 0; 
        
      DATA 만 추가
        INSERT INTO  EMP4 
          SELECT  * FROM HR.EMPLOYEES;
        COMMIT;  
        
     5) 일부칼럼만 복사해서 새로운 테이블 생성
      CREATE  TABLE  EMP5
      AS 
        SELECT  EMPLOYEE_ID                      EMPID,
                FIRST_NAME || ' ' || LAST_NAME   ENAME,
                SALARY                           SAL,
                SALARY * COMMISSION_PCT          COMM,
                MANAGER_ID                       MGR,
                DEPARTMENT_ID                    DEPTID
         FROM   HR.EMPLOYEES;
      
2. SQLDEVEOPER 메뉴에서 TABLE 을 생성
        HTH 계정
           테이블 메뉴 클릭 -> 새 테이블 클릭 -> TABLE1 생성
           EMPID   NUMBER(6,0)           No
           ENAME   VARCHAR2(30 BYTE)     No
           TEL     VARCHAR2(20 BYTE)     Yes
           EMAIL   VARCHAR2(320 BYTE)    Yes
             
     
3.  SQL SCRIPT  로 테이블 생성
       CREATE  TABLE  TABLE2 (
           EMPID   NUMBER(6,0)         NOT NULL   PRIMARY KEY
          ,ENAME   VARCHAR2(30 BYTE)   NOT NULL
          ,TEL     VARCHAR2(20 BYTE)   NULL
          ,EMAIL   VARCHAR2(320 BYTE)   
       );
        
 [2] 테이블 제거 - 영구적으로 구조와 데이터가 제거된다
   
    DROP TABLE EMP1;    
      -- drop 되는 테이블이 부모테이블일 경우 자식을 먼저 지워야 삭제가능
          
    hr 에서 drop table departments; 
    drop table departments   --  삭제 안됨
    오류 보고 -
    ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
    02449. 00000 -  "unique/primary keys in table referenced by foreign keys"
    
     drop table 테이블명 cascade;  -- relationship 에 상관없이 삭제 가능
    
 [3] 구조(테이블) 변경
     1. 칼럼추가
       ALTER  TABLE  EMP5
        ADD ( LOC  VARCHAR2(6)  );  -- 추가된 DATA : NULL
        
        변경 사항 확인은 새로 고침하라
    
    2. 칼럼제거
       ALTER TABLE  EMP5
        DROP COLUMN   LOC;
    
    3. 데이블 이름 변경 -- ORACLE에서 사용
       RENAME   EMP4  TO NEWEMP;    
    
    4. 칼럼속성변경  -- 크기를 늘리거나 줄인다
       ALTER  TABLE  EMP5
        MODIFY (  ENAME  VARCHAR2(60) ); -- 46 -> 60