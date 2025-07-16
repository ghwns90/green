CREATE TABLE BOARD
(
    num     INT             PRIMARY KEY     AUTO_INCREMENT,
    title   VARCHAR(300)    NOT NULL,
    content TEXT(64999),
    writer  VARCHAR(60),
    wdate   DATETIME        DEFAULT NOW(),
    hit     INT
);

select * from board;

INSERT INTO BOARD (title, content, writer, hit) 
VALUES            ('제목', '콘텐트야이야이야', '작까', 55);
INSERT INTO BOARD (title, content, writer, hit) 
VALUES            ('제목1', '콘텐트야이야이야ㅋㅋㅋ', '작작', 111);
INSERT INTO BOARD (title, content, writer, hit) 
VALUES            ('제목2', '콘텐트야이야이야ㄹㅇ', 'ㅋㅋ', 130);
INSERT INTO BOARD (title, content, writer, hit) 
VALUES            ('제목3', '콘텐ㅎㅎ', '작까2', 13);
INSERT INTO BOARD (title, content, writer, hit) 
VALUES            ('제목4', '콘텐트야 ㅇㅇㅇ', '작까1', 28);

DELETE FROM BOARD WHERE num = 5;
DELETE FROM BOARD WHERE title = '제목3';

UPDATE BOARD SET title = '제제목' WHERE num=1;
UPDATE BOARD SET writer = '쭈' WHERE num=3;