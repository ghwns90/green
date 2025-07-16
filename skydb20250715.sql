


-- 시퀀스 : 번호 자동 증가

CREATE TABLE TABLE3 (
    ID      NUMBER(6) PRIMARY KEY,
    TITLE   VARCHAR2(4000),
    MEMO    VARCHAR2(4000)
);

CREATE SEQUENCE SEQ_ID;

INSERT INTO TABLE3 VALUES(SEQ_ID.NEXTVAL, 'A', 'AAAA');
INSERT INTO TABLE3 VALUES(SEQ_ID.NEXTVAL, 'B', 'BBzdz');
INSERT INTO TABLE3 VALUES(SEQ_ID.NEXTVAL, 'C', 'CCCfsdf');
COMMIT;

DELETE FROM TABLE3 WHERE ID IN (4, 5, 6);
COMMIT;

INSERT INTO TABLE3 VALUES((SELECT MAX(ID)+1 FROM TABLE3), 'C', 'CCCfsdf');

DELETE FROM TABLE3 WHERE ID = 10;
COMMIT;
-- 번호를 자동으로 입력

--------------------------------------------------------------

-- 인덱스 : 검색 속도를 빠르게 만드는 객체
  -- 인덱스가 생성된 칼럼을 WHERE 문에 사용해야 효과있다.
CREATE INDEX IDX_NAME
ON  EMP1(FIRST_NAME);

-------------------------------------------------------------

트리거 : TRIGGER
  회원정보가 추가되면 로그에 기록을 남기는 작업을 해야할때
   
   상황 
  1)  INSERT 회원정보
  2)  INSERT 로그기록
   두번실행
  
   자동화 
  1)  INSERT 회원정보 -> 트리거가  INSERT 로그기록 호출해서 실행
  
   단점 : 로직추적이 쉽지 않다 
          트리거를 남발하지 맣라.
          
 https://docs.oracle.com/database/121/TDDDG/tdddg_triggers.htm#BABDAGJJ  


---------------------------------------------------------------- 

트랜잭션 ( TRANSACTION )
송금
  1) 내계좌 금액   -
  2) 상대계좌 금액 +
 
  
  1) UPDATE  TABLE1 
    SET   내계좌   = 내계좌 - 100;
    
  2) UPDATE  TABLE1 
    SET   샹대계좌 = 상대계좌 + 100;  
 
 두 동작을 하나의 트랜잭션으로 묶어주면 
  COMMIT을 만나기 전에는 DB에 저장되지 않으므로 
  송금실패시 DATA 가 잘못되는일이 없다
    
  BEGIN TRANS
  1) UPDATE  TABLE1 
      SET   내계좌   = 내계좌 - 100;
    
  2) UPDATE  TABLE1 
      SET   샹대계좌 = 상대계좌 + 100;  
    
    COMMIT; -- ROLLBACK;
  END

---------------------------------------------------------------

LOCK;
    INSERT INTO TABLE2 (EMPID, ENAME, TEL, EMAIL)
        VALUES (100, '김일', '010', 'KIM1');
COMMIT;
select * from table2;

-- 한쪽이 COMMIT 하기전에 INSERT를 한번 더 하면 LOCK 상태에 걸림

        