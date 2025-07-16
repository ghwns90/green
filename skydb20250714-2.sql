성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성 
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
  
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 CREATE TABLE STUDENT
 (
    STID      NUMBER(6)  PRIMARY KEY, 
    STNAME    VARCHAR2(30) NOT NULL,   
    PHONE     VARCHAR2(20) UNIQUE,   
    INDATE    DATE  DEFAULT SYSDATE
 );
 
INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE) 
    VALUES      (1, '가나', '010', SYSDATE);
INSERT INTO STUDENT (STID, STNAME, PHONE) 
    VALUES      (2, '나나', '011');
INSERT INTO STUDENT
    VALUES      (3, '가나', '012', SYSDATE);
INSERT INTO STUDENT
    VALUES      (4, '라나', '013', SYSDATE); 
INSERT INTO STUDENT
    VALUES      (5, '라나', '014', SYSDATE);
INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE)
    VALUES      (6, NULL, '015', SYSDATE);
INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE)
    VALUES      (7, '하나', NULL, SYSDATE);
commit;

 
 CREATE TABLE SCORES 
 (
    SCID    NUMBER(6),
    SUBJECT VARCHAR2(30)  NOT NULL,
    SCORE   NUMBER(3)  CHECK(SCORE BETWEEN 0 AND 100),
    STID    NUMBER(6),
    CONSTRAINT SCID_PK
        PRIMARY KEY (SCID, SUBJECT),
    CONSTRAINT SCID_FK
        FOREIGN KEY (STID)
        REFERENCES STUDENT(STID)
 );
 
INSERT INTO SCORES VALUES (1, '국어', 100, 1);
INSERT INTO SCORES VALUES (2, '영어', 100, 1);
INSERT INTO SCORES VALUES (3, '수학', 100, 1);
INSERT INTO SCORES VALUES (4, '국어', 100, 2);
INSERT INTO SCORES VALUES (5, '수학', 80, 2);
INSERT INTO SCORES VALUES (6, '국어', 70, 4);
INSERT INTO SCORES VALUES (7, '영어', 80, 4);
INSERT INTO SCORES VALUES (8, '수학', 85, 4);
INSERT INTO SCORES VALUES (9, '국어', 805, 5);
INSERT INTO SCORES VALUES (10, '영어', 100, 6);
COMMIT;

DROP TABLE SCORES;

select * from student;

 /* 학생
    학번 이름
    1   a
    2   b
    3   c
    4   d
    5   e
    
    성적
    번호  국어  영어  수학  학번
    1   100     90    100   1
    2   100           80    2
    3   80      90    0     4
    4   90      80    70    6  
 */
 
  1. INSERT -- 줄(DATA) 추가 COMMIT 필수
    1) INSERT INTO SCORES (SCID, SUBJECT, SCORE, STID)
        VALUES             (1, '국어', 100, 1);
        
    2) INSERT INTO EMP4 -- 여러줄 추가
        SELECT * FROM HR.EMPLOYEES;
        
    3) INSERT ALL -- 한번에 여러줄을 입력하는 방법
        INTO ex VALUES (103, '강감찬')
        INTO ex VALUES (103, '강감찬')
       SELECT * FROM DUAL;
       
  2. DELETE -- 줄(DATA) 을 삭제 한다 기본적으로 여러줄이 대상 COMMIT 필수
    FROM 테이블명
    WHERE 조건;
    
  3. UPDATE -- 줄에 변화없고 칸에 있는 정보만 수정, COMMIT 필수
            -- WHERE 이 없으면 전체가 대상
        UPDATE  MYMEMBER
        SET     TEL = '010-1234-5678',
                EMAIL = 'SKY@GREEN.COM'
        WHERE EMPID = 10;
        
---------------------------------------------------------------------------

DATA 제거
    
    1. DROP TABLE SCORES; -- 구조도 안남기고 삭제
    
    2. TRUNCATE TABLE SCORES; -- 구조만 남기고 삭제 : 속도 빠름
    
    3. DELETE FROM SCORES; -- 한줄씩 삭제 수행
        
        SCORES DATA 삭제
        
        SELECT * FROM SCORES;
        DELETE FROM SCORES;
        ROLLBACK;
        
        SELECT * FROM STUDENT;
        DELETE FROM STUDENT;
        ROLLBACK;
        
    INSERT INTO STUDENT VALUES (11, '히나', '0111', SYSDATE);
    COMMIT;
    
    DELETE FROM STUDENT
    WHERE STID = 1;     -- 무결성 제약조건이 위배
    
    DELETE FROM STUDENT
    WHERE STID = 11;
    
    외래키 관계에서는 자식테이블의 DATA를 지우고 부모테이블의 DATA를 삭제하면 된다
    
    DELETE FROM SCORES
    WHERE STID = 1;     -- 자식먼저 삭제
    DELETE FROM STUDENT
    WHERE STID = 1;     -- 부모키를 삭제
    
-- 4번 학생의 국어점수를 100점으로 수정

UPDATE  SCORES
SET     score = 100
WHERE   SCID = 6;
--WHERE   stid = 4 AND subject = '국어';

TRUNCATE TABLE SCORES;

DROP TABLE SCORES;

DROP TABLE STUDENT;

----------------------------------------------------------------------------

-- 조회
-- 학번, 이름, 점수(국어)
SELECT st.STID, st.stname, sc.score 
FROM    STUDENT st, SCORES sc
WHERE st.stid = sc.stid AND sc.subject = '국어';
-- 학번, 이름, 총점, 평균
SELECT  st.stid, st.stname, SUM(sc.score), AVG(sc.score)
FROM    STUDENT st, SCORES sc
WHERE st.stid = sc.stid
GROUP BY st.stid, st.stname;
-- 모든 학생의 학번, 이름, 총점, 평균
SELECT  st.stid, st.stname, 
        DECODE(SUM(sc.score),null,'미응시', SUM(sc.score)), 
        CASE
            WHEN     AVG(sc.score) IS NULL THEN '미응시'
            ELSE     TO_CHAR(AVG(sc.score), '990.999')
        END
FROM    STUDENT st LEFT JOIN SCORES sc ON st.stid = sc.stid
GROUP BY st.stid, st.stname;

-- 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차
SELECT  st.stid, 
        st.stname, 
        DECODE(SUM(sc.score),null,'미응시', SUM(sc.score)), 
        CASE
            WHEN     AVG(sc.score) IS NULL THEN '미응시'
            ELSE     TO_CHAR(AVG(sc.score), '990.999')
        END 평균,
        CASE
            WHEN ROUND(AVG(score),3) BETWEEN 90 AND 100 THEN    'A'
            WHEN ROUND(AVG(score),3)  BETWEEN 80 AND 89.999 THEN 'B'
            WHEN ROUND(AVG(score),3)  BETWEEN 70 AND 79.999 THEN 'C'
            WHEN ROUND(AVG(score),3)  BETWEEN 60 AND 69.999 THEN 'D'
            WHEN ROUND(AVG(score),3)  BETWEEN  0 AND 59.999 THEN 'F'
            ELSE                                            '미응시'
        END 등급,
        RANK() OVER(ORDER BY SUM(SCORE) DESC NULLS LAST) 석차
FROM    STUDENT st LEFT JOIN SCORES sc ON st.stid = sc.stid
GROUP BY st.stid, st.stname;

-- 비등가 조인 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차

----------------------------------------------------------------------

-- 학번, 이름, 국어, 영어, 수학, 총점, 평균
1. ORACLE 10G 방식
1-1) 
SELECT SC.STID 학번,
       ST.STNAME 이름, 
       SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
       SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
       SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학
FROM   SCORES SC, STUDENT ST
WHERE SC.STID = ST.STID
GROUP BY SC.STID, ST.STNAME;

SELECT ST.STID 학번,
       ST.STNAME 이름, 
       SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
       SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
       SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학
FROM   SCORES SC, STUDENT ST
WHERE SC.STID(+) = ST.STID
GROUP BY ST.STID, ST.STNAME;

SELECT ST.STID 학번,
       ST.STNAME 이름, 
       SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
       SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
       SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학,
       SUM(SC.SCORE) 총점,
       ROUND(AVG(SC.SCORE),3) 평균
FROM   SCORES SC, STUDENT ST
WHERE SC.STID(+) = ST.STID
GROUP BY ST.STID, ST.STNAME;

-- 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
-- 미응시자는 '미응시'로 출력

SELECT ST.STID 학번,
       ST.STNAME 이름, 
       SUM(DECODE(SC.SUBJECT, '국어', SC.SCORE)) 국어,
       SUM(DECODE(SC.SUBJECT, '영어', SC.SCORE)) 영어,
       SUM(DECODE(SC.SUBJECT, '수학', SC.SCORE)) 수학,
       SUM(SC.SCORE) 총점,
       ROUND(AVG(SC.SCORE),3) 평균,
       CASE
        WHEN AVG(SC.SCORE) BETWEEN 90 AND 100 THEN 'A'
        WHEN AVG(SC.SCORE) BETWEEN 80 AND 89.999 THEN 'B'
        WHEN AVG(SC.SCORE) BETWEEN 70 AND 79.999 THEN 'C'
        WHEN AVG(SC.SCORE) BETWEEN 60 AND 69.999 THEN 'D'
        WHEN AVG(SC.SCORE) BETWEEN 50 AND 59.999 THEN 'F'
        ELSE                                       '미응시'
       END 등급,
       DENSE_RANK() OVER(ORDER BY AVG(SC.SCORE) DESC NULLS LAST) 순위
FROM   SCORES SC, STUDENT ST
WHERE SC.STID(+) = ST.STID
GROUP BY ST.STID, ST.STNAME;

CREATE TABLE SCOREGRADE
(
    GRADE VARCHAR2(1) PRIMARY KEY,
    LOSCORE NUMBER(7,3),
    HISCORE NUMBER(7,3)
);

INSERT INTO SCOREGRADE VALUES ('A', 90, 100);
INSERT INTO SCOREGRADE VALUES ('B', 80, 89.9);
INSERT INTO SCOREGRADE VALUES ('C', 70, 79.9);
INSERT INTO SCOREGRADE VALUES ('D', 60, 69.9);
INSERT INTO SCOREGRADE VALUES ('F', 0, 59.9);

-------------------------------------------------------------------------
 SELECT   T.학번, T.이름, T.국어, T.영어, T.수학, T.총점, T.평균, 
          SG.GRADE      등급, 
          RANK() OVER(ORDER BY T.총점 DESC NULLS LAST ) 석차
  FROM  
   (
    SELECT    ST.STID                                         학번,
              ST.STNAME                                       이름,
              SUM( DECODE( SC.SUBJECT, '국어', SC.SCORE) )    국어, 
              SUM( DECODE( SC.SUBJECT, '영어', SC.SCORE) )    영어, 
              SUM( DECODE( SC.SUBJECT, '수학', SC.SCORE) )    수학,
              SUM (SC.SCORE)                                  총점,
              ROUND( AVG(SC.SCORE), 3)                        평균
    FROM      SCORES    SC, STUDENT   ST
    WHERE     SC.STID(+)    =     ST.STID
    GROUP BY  ST.STID, ST.STNAME   
   )  T LEFT JOIN SCOREGRADE  SG
      ON  T.평균 BETWEEN  SG.LOSCORE AND SG.HISCORE;


-------------------------------------------------------------------------

2. ORACLE 11G PIVOT 문법 통계를 생성 - 일반적으로 집계함수와 같이 사용

1) 학번, 국어, 영어, 수학
SELECT * FROM (
    SELECT STID, SUBJECT, SCORE
    FROM   SCORES
)
PIVOT
(
    SUM(SCORE)
        FOR SUBJECT
            IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
);

2) 학번, 이름, 국어, 영어, 수학, 총점, 평균, 학점, 석차
SELECT ST.STID 학번, ST.STNAME 이름, T.국어, T.영어, T.수학, 
       (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0)) 총점, 
       (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0)) / 3 평균,
       SG.GRADE 학점, 
       RANK() OVER (ORDER BY ( NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0) ) DESC NULLS LAST) 석차
FROM    
(
    SELECT * FROM (
        SELECT STID, SUBJECT, SCORE
        FROM   SCORES
    )
    PIVOT
    (
        SUM(SCORE)
            FOR SUBJECT
                IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
    )
) T RIGHT JOIN STUDENT ST    ON T.STID = ST.STID
     LEFT JOIN SCOREGRADE SG ON (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0)) / 3 BETWEEN SG.LOSCORE AND SG.HISCORE

