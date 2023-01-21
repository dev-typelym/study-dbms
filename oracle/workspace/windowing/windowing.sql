CREATE TABLE salgrade(
   grade number(3) PRIMARY KEY,
   losal number(5),
   hisal number(5)
);


INSERT INTO salgrade 
VALUES (1, 700, 1200);
INSERT INTO salgrade 
VALUES (2, 1201, 1500);
INSERT INTO salgrade 
VALUES (3, 1501, 6000);
INSERT INTO salgrade 
VALUES (4, 6001, 10000);
INSERT INTO salgrade 
VALUES (5, 10001, 15000);
--------------------------------------------------------------------------------------------------
SELECT e.first_name, s.grade
FROM employees e, salgrade s
WHERE e.salary BETWEEN s.losal AND s.hisal

-- 부서이름, 그 부서를 관리하는 관리자의 first_name
-- RIGHT OUTER JOIN
SELECT d.department_name, e.first_name
FROM departments d, employees e
WHERE d.manager_id(+) = e.employee_id;

-- LEFT OUTER JOIN
SELECT d.department_name, e.first_name
FROM departments d, employees e
WHERE d.manager_id = e.employee_id(+);

-- 표준 문법
SELECT d.department_name, e.first_name
FROM departments d RIGHT OUTER JOIN employees e 
ON e.employee_id = d.manager_id;

-- 자체조인
-- 직원의 이름과 상사의 이름
SELECT a.first_name, b.first_name
FROM employees a LEFT OUTER JOIN employees b
ON a.manager_id = b.employee_id

-- 서브쿼리
-- ki의 급료를 몰라 ki 급료를 찾은후 그 값보다 많이 받는 직원을 찾아야한다.
SELECT salary 
FROM employees 
WHERE first_name = 'Ki';

SELECT first_name, salary
FROM employees 
WHERE salary > 2400;

-- 단일행 서브쿼리 : 행결과값이 하나 나옴
SELECT salary
FROM employees
WHERE salary > (SELECT salary 
							FROM employees
							WHERE first_name = 'Ki'
							);

-- 다중행 연산자
-- David가 받는 봉급보다 많이 받는 사람의 first_name, salary 조회
-- David가 여러명이기 때문에 비교연산자는 오류뜸, 그래서 IN연산자 사용해봄
SELECT first_name, salary
FROM employees
WHERE salary > ANY (SELECT salary 
							FROM employees
							WHERE first_name = 'David'
							);

-- 매니저아이디가 존재하는 직원아이디 조회
SELECT first_name, employee_id 
FROM employees e 
WHERE EXISTS (
		SELECT 1
		FROM departments d
		WHERE e.employee_id = d.manager_id
		);
	
-- 매니저아이디가 존재하지 않는 직원아이디 조회
SELECT first_name, employee_id 
FROM employees e 
WHERE NOT EXISTS (
		SELECT 1
		FROM departments d
		WHERE e.employee_id = d.manager_id
		);
	
SELECT first_name, employee_id
FROM employees 
WHERE employee_id IN (
		SELECT manager_id 
		FROM departments 
);
						
-- JOIN을 사용하면 중복된 결과가 나타날 수 있다.

-- 전체 직원의 평균봉급보다 많이 받는 사원
-- 이름과 봉급 조회하기
SELECT first_name, salary
FROM employees 
WHERE salary > (
		SELECT AVG(salary)
 		FROM employees);

-- 부서별 봉급 내림차순 정렬하여 상위 3인의 이름, 봉급, 부서id 조회하기
SELECT first_name, salary, department_id
 FROM(
 			SELECT first_name, salary, department_id, 
				ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) a
			FROM employees 
)
WHERE a <= 3;

-- 부서별 최대 봉급을 받는 사람의 이름 조회하기
SELECT first_name, department_id, salary
FROM (
SELECT first_name,
		department_id,
		salary,
		max(salary) over(PARTITION BY department_id) a
FROM employees
)
WHERE salary = a;

-- 다중 컬럼 서브쿼리 이용한 경우
SELECT first_name, salary, department_id 
FROM employees
WHERE (department_id, salary) IN (
			SELECT department_id, max(salary)
			FROM employees 
			GROUP BY department_id
			);

SELECT department_id, SUM(salary)
FROM employees 
GROUP BY department_id;

-- FROM절에도 사용가능
SELECT d.department_name, a.total_salary
FROM departments d INNER JOIN (
		SELECT department_id, SUM(salary) total_salary
		FROM employees 
		GROUP BY department_id
)a 
ON d.department_id = a.department_id 

-- 집합연산자 
-- NULL, 10, 20, 30, ..., 110
SELECT department_id
FROM employees; 

-- 10, 20, 30, 40, ... 110, 120, 130, .. 270
SELECT department_id
FROM departments;

SELECT department_id
FROM employees
UNION
SELECT department_id
FROM departments;

SELECT department_id
FROM employees
UNION ALL
SELECT department_id
FROM departments;

SELECT department_id
FROM employees
INTERSECT
SELECT department_id
FROM departments;

SELECT department_id
FROM departments
MINUS
SELECT department_id
FROM employees;

-- 계층형 데이터
-- 사원의 이름, 상사의 이름
SELECT first_name
FROM employees 
START WITH employee_id = 152
CONNECT BY PRIOR manager_id = employee_id;
-- 자식 = 부모 --> 자식노드에서 부모노드로 탐색

SELECT first_name
FROM employees 
START WITH employee_id = 152
CONNECT BY PRIOR employee_id = manager_id;
-- 부모 = 자식 -- > 부모노드에서 자식노드로 탐색

SELECT first_name, employee_id, manager_id 
FROM employees 
START WITH manager_id IS NULL 
CONNECT BY PRIOR employee_id = manager_id;

CREATE TABLE emp(
   name varchar2(50) PRIMARY KEY,
   job_rank varchar2(50),
   manager_name varchar2(50),
   CONSTRAINT emp_fk FOREIGN KEY (manager_name) REFERENCES emp (name)
);

INSERT INTO emp
VALUES ('김철수', '사장', null);

INSERT INTO emp
VALUES ('유재석', '부장', '김철수');

INSERT INTO emp
VALUES ('박명수', '과장', '유재석');

INSERT INTO emp
VALUES ('정준하', '과장', '유재석');

INSERT INTO emp 
VALUES ('정형돈', '대리', '정준하');

INSERT INTO emp 
VALUES ('하하', '사원', '정형돈');

INSERT INTO emp 
VALUES ('노홍철', '사원', '정형돈');
----------------------------------------------------------------------------------
SELECT name 
FROM emp 
START WITH manager_name IS NULL 
CONNECT BY PRIOR name = manager_name;