create table member
(
id          INT PRIMARY KEY AUTO_INCREMENT,
userid      VARCHAR(30) NOT NULL,
username    VARCHAR(30) NOT NULL,  
userpass    VARCHAR(30) NOT NULL,
email       VARCHAR(320),     
regdate     DATETIME DEFAULT NOW()
);

INSERT INTO MEMBER (USERID, USERNAME, USERPASS, EMAIL)
VALUES             ('sky', 'sky', '1234', 'sky@naver.com');

select * from member;