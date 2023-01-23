--
INSERT INTO departments 
VALUES (300, 'test', NULL, null);

INSERT INTO departments 
VALUES (310, 'test2', NULL, NULL);

INSERT INTO departments 
VALUES (320, 'test3', NULL , NULL );

INSERT INTO departments 
VALUES (330, 'test4', NULL , NULL );

SELECT * FROM departments;

ROLLBACK;

COMMIT;





INSERT INTO departments 
VALUES (340, 'test5', NULL, NULL);

SAVEPOINT s1;

INSERT INTO departments 
VALUES (350, 'test6', null, null );

SAVEPOINT s2;

INSERT INTO departments 
VALUES (370,'test7', NULL, NULL);

SELECT * FROM departments;

ROLLBACK TO s2;

--
CREATE TABLE test(
	a number(10, 5),
	b varchar2(100),
	c DATE,
	d char(100)
);

--테이블 생성, 컬럼수준에서 제약조건
-- prmary key는 무조건 하나의 테이블 안에 하나만 존재한다
CREATE TABLE test2(
	id number(3, 0) PRIMARY KEY,
	pw varchar2(100) NOT NULL,
	email varchar2(100) UNIQUE NOT NULL,
	age number(3) CHECK (age > 0)
);

-- 자기자신의 컬럼을 외래키로 설정하려면 테이블 수준에서 설정해 주어야 한다.
CREATE TABLE test3(
	order_number number(3) PRIMARY KEY,
	owner number(3) REFERENCES test2(id)
);

-- 테이블 수준
-- NOT NULL을 설정할 수 없다
CREATE TABLE test4(
	id number(3),
	pw varchar2(100) NOT NULL,
	email varchar2(100),
	age number(3),
	gender char(1),
	friend number(3),
	CONSTRAINT test4_pk PRIMARY KEY (id),
	CONSTRAINT test4_email_notnull check (email IS NOT NULL),
	CONSTRAINT test4_email_uq UNIQUE (email),
	CONSTRAINT test4_age_ch CHECK (age > 0),
	CONSTRAINT test4_gender_ch CHECK (gender IN ('F', 'M')),
	CONSTRAINT test4_fk FOREIGN KEY (friend) REFERENCES test4(id)	
);
