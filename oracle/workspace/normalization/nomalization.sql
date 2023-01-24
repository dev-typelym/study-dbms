-- 컬럼 추가
ALTER TABLE TEST4
ADD test number(3) NOT NULL;

-- 제약조건 추가
ALTER TABLE TEST4
ADD CONSTRAINT test4_test_uq UNIQUE (test);

-- 컬럼 수정
-- 기존에 설정된 제약조건은 건들지 않는다.
-- 따라서 제약조건이 수정하고자 하는 컬럼과 충돌된다면 오류 발생
ALTER TABLE TEST4
MODIFY test varchar2(100);

-- 컬럼 삭제
ALTER TABLE TEST4 	
DROP COLUMN test;

-- 제약조건만 삭제
ALTER TABLE test4
DROP CONSTRAINT test4_gender_ch;

-- 컬럼명 수정
ALTER TABLE TEST4 
RENAME COLUMN friend TO a;

-- 제약조건 이름 수정
ALTER TABLE TEST4 
RENAME CONSTRAINT sys_c007024 TO test4_pw_not_null;

-- 테이블명 수정 
ALTER TABLE TEST4
RENAME TO test10;

-- 제약조건 비활성화 
ALTER TABLE test10
disable CONSTRAINT test4_age_ch;

-- 제약조건 활성화
ALTER TABLE test10
enable CONSTRAINT test4_age_ch;

-- 테이블 삭제
DROP TABLE test10;

--삭제할 때 외래키로 제공하고 있는 부모테이블을 먼저 삭제할 수 없다.
-- 자식테이블 먼저 DROP 후 보무 DROP
-- CASCADE CONSTRAINTS를 사용하면 자식테이블에서 외래키제약이 사라지고.
-- 부모테이블이 삭제가 된다.
-- 다른 테이블들이 TEST2테이블을 참조하고 있다면, 참조하지 않게 만들고, TEST2 삭제
DROP TABLE test2;

TRUNCATE TABLE test2;


-- 스키마(사용자 계정) 만들기
CREATE USER myuser IDENTIFIED BY 1234;

GRANT SELECT ON employees TO myuser;

GRANT INSERT, SELECT, DELETE, UPDATE ON test3 TO myuser;

REVOKE INSERT ON test3 FROM myuser;

-- 자신이 부여한 권한 확인하기
SELECT * FROM USER_TAB_PRIVS_MADE;

SELECT * FROM user_tab_privs_recd;
----------------------------------------------------------------------------------
CREATE TABLE 무한상사( 
		이름 varchar2(100),
		직급 varchar2(100),
		상사 varchar2(100),
		CONSTRAINT muhan_pk PRIMARY KEY (이름),
		CONSTRAINT muhan_fk FOREIGN KEY (상사) REFERENCES 무한상사(이름)
);

INSERT INTO 무한상사
VALUES ('유재석', '부장', NULL); 

INSERT INTO 무한상사
VALUES ('박명수', '과장', '유재석');

INSERT INTO 무한상사
VALUES ('정준하', '과장', '유재석');

INSERT INTO 무한상사
VALUES ('정형돈', '대리', '박명수');

UPDATE 무한상사 
SET 상사 = '정형돈'
WHERE 이름 = '유재석';

-- 정준하 사원을 삭제
-- DELETE 무한상사
-- WHERE 이름 = '박명수';

UPDATE 무한상사
SET 상사 = NULL 
WHERE 상사 = '박명수';

DELETE 무한상사
WHERE 이름 = '박명수'

SELECT * FROM 무한상사;

ROLLBACK;

-- 프로시져 만들기
CREATE PROCEDURE DELETE_emp(v_name IN varchar2)
IS 
BEGIN 
	UPDATE 무한상사
	SET 상사 = NULL 
	WHERE 상사 = v_name;
	DELETE 무한상사
	WHERE 이름 = v_name;
END;

BEGIN 
	delete_emp('박명수');
END;

BEGIN
	delete_emp('유재석');
END;

SELECT * FROM 무한상사;
END

----------------------
-- 새로운 사원이 입사했을때, 
-- EMPLOYEES 테이블에다가 사원 추가하기 

CREATE PROCEDURE ins_emp(v_name IN varchar2)
IS 
	v_id number(3)
BEGIN
	SELECT max(employee_id) + 1
	INTO v_id
	FROM employees;
	INSERT INTO EMPLOYEES
	VALUES (v_id, v_name, 'last', 'email', NULL, sysdate, 'SA_REP', NULL, NULL, NULL, NULL);
END;

BEGIN 
	ins_emp('임의택');
END;


