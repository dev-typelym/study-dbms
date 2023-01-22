SELECT * FROM emp;

SELECT name, 
	job_rank,
	manager_name,
	LEVEL,
	CONNECT_BY_ISLEAF,
	CONNECT_BY_ISCYCLE
FROM emp 
START WITH manager_name IS NULL 
CONNECT BY NOCYCLE PRIOR name = manager_name
ORDER siblings BY name DESC;

UPDATE emp  
SET manager_name = '하하'
WHERE manager_name IS NULL; 

SELECT * FROM emp;

SELECT name, job_rank, manager_name, connect_by_iscycle
FROM emp 
START WITH name = '김철수'
CONNECT BY nocycle PRIOR name = manager_name;

-- 함수
SELECT name, job_rank, manager_name,
		SYS_CONNECT_BY_PATH(MANAGER_NAME , '->'),
		CONNECT_by_root(name)
FROM emp
START WITH name = '김철수'
CONNECT BY nocycle PRIOR name = manager_name;

-- 데이터삽입
INSERT INTO departments(department_id, department_name, manager_id, location_id)
VALUES(300, 'test',  150, 1700);

INSERT INTO departments(department_id, department_name, location_id)
VALUES(310, 'test2', 1700);

INSERT INTO departments
VALUES(320, 'test3', 151, 1700);

INSERT INTO departments
VALUES(330, 'test4', NULL, 1700);

CREATE TABLE TBL_USER(
   user_id varchar2(30) NOT NULL PRIMARY KEY,
   user_pw varchar2(30) NOT NULL,
   user_gender char(1) NOT NULL,
   user_age number(3) NOT NULL,
   user_address varchar2(30),
   join_date DATE,
   grade varchar2(10) DEFAULT 'normal' NOT NULL
);
CREATE TABLE USER_ACCESS_DATE(
   user_id varchar2(30) PRIMARY KEY,
   last_access_date DATE DEFAULT sysdate NOT NULL,
   CONSTRAINT access_date_fk FOREIGN KEY(user_id)
   REFERENCES TBL_USER(user_id)
);

--회원정보
--id : abc123
--pw : 1234
--성별 : 'F'
--나이 : 20
--주소 : 서울시 역삼동
--회원가입일자 : 현재시각
--grade : 'normal'
--최근접속일 : 현재시각
INSERT INTO TBL_USER(USER_ID, USER_PW, USER_GENDER, USER_AGE, USER_ADDRESS, JOIN_DATE, GRADE)
VALUES ('abc123', '1234', 'F', 20, '서울시 역삼동', sysdate, 'normal');

INSERT INTO USER_ACCESS_DATE(user_id, LAST_ACCESS_DATE)
values('abc123', sysdate);

--회원정보
--id : def123
--pw : 5555
--성별 : 'M'
--나이 : 25
--회원가입일자 : 2020 / 5 / 15
--grade : normal
--최근접속일 : 2020/6/1
INSERT INTO TBL_USER(USER_ID, USER_PW, USER_GENDER, USER_AGE, JOIN_DATE)
VALUES ('def123', '5555', 'M', 25, to_date('200515', 'yymmdd'));

INSERT INTO USER_ACCESS_DATE(user_id, LAST_ACCESS_DATE)
values('def123', to_date('200601', 'yymmdd'));

--id : aaa
--pw : 0000
--성별 : 'F'
--나이 : 15,
--주소지 미입력
--회원가입일자 : 2020 / 2 / 1
--grade : normal
--최근접속일 : 21 / 6 / 1

INSERT INTO TBL_USER(USER_ID, USER_PW, USER_GENDER, USER_AGE, JOIN_DATE)
VALUES ('aaa', '0000', 'F', 15, to_date('200201', 'yymmdd'));

INSERT INTO USER_ACCESS_DATE(user_id, LAST_ACCESS_DATE)
values('aaa', to_date('210601', 'yymmdd'));


-- 수정하기
UPDATE TBL_USER 
SET USER_ADDRESS = '서울시 봉천동'
WHERE USER_ID = 'def123';

-- 현재 시각으로부터 회원가입한 일자가 1년이 경과했다면
-- grade를 vip로 수정하기

UPDATE TBL_USER 
SET grade = 'vip'
WHERE months_between(sysdate,  join_date) >= 12;

SELECT grade
FROM tbl_user;

-- 우리가 추가한 부서들 삭제하기
DELETE departments
WHERE department_id IN (300, 310, 320, 330);

-- 현재로부터 최근 접속일이 1년이 넘은 회원들의 정보 삭제하기 
DELETE user_access_date
WHERE months_between(sysdate, last_access_date) >= 12; 

DELETE tbl_user 
WHERE NOT EXISTS (
		SELECT 1
		FROM USER_ACCESS_DATE
		WHERE tbl_user.USER_id = user_access_date.user_id 
);

SELECT *
FROM tbl_user a
WHERE user_id NOT IN (
		SELECT USER_ID
		FROM USER_ACCESS_DATE b
);

