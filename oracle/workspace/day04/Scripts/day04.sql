/*JOBS 테이블에서 JOB_ID로 직원들의 JOB_TITLE, EMAIL, 성, 이름 검색*/
SELECT JOB_TITLE, e.EMAIL, e.LAST_NAME || ' ' || e.FIRST_NAME 이름 FROM JOBS j  JOIN EMPLOYEES e  
ON j.JOB_ID = e.JOB_ID ;

/*EMP 테이블의 SAL을 SALGRADE 테이블의 등급으로 나누기*/
SELECT *
FROM SALGRADE S JOIN EMP E
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;
/*세타 조인*/
SELECT E.ENAME, E.JOB, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

/*EMPLOYEES 테이블에서 HIREDATE가 2003~2005년까지인 사원의 정보와 부서명 검색*/
SELECT e.*, d.DEPARTMENT_NAME FROM EMPLOYEES e JOIN DEPARTMENTS d 
ON e.DEPARTMENT_ID  = d.DEPARTMENT_ID  AND HIRE_DATE > '2003-01-01' AND HIRE_DATE < '2005-01-01';

SELECT D.DEPARTMENT_NAME, E.*
FROM EMPLOYEES E JOIN DEPARTMENTS D ON
E.DEPARTMENT_ID = D.DEPARTMENT_ID AND
E.HIRE_DATE BETWEEN TO_DATE('2003', 'YYYY') AND TO_DATE('2005', 'YYYY'); 

SELECT SYS_CONTEXT('USERENV', 'NLS_DATE_FORMAT') FROM DUAL;
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

/*JOB_TITLE 중 'Manager'라는 문자열이 포함된 직업들의 평균 연봉을 JOB_TITLE별로 검색*/
SELECT j.JOB_TITLE, AVG(e.SALARY) "AVERAGE OF SALARY" FROM EMPLOYEES e  JOIN JOBS j  
ON e.JOB_ID = j.JOB_ID  AND j.JOB_TITLE LIKE '%Manager%'
GROUP BY j.JOB_TITLE;

/*EMP 테이블에서 ENAME에 L이 있는 사원들의 DNAME과 LOC 검색*/
SELECT e.ENAME, d.DNAME, d.LOC FROM EMP e JOIN DEPT d 
ON e.DEPTNO = d.DEPTNO AND e.ENAME LIKE '%L%'

/*축구 선수들 중에서 각 팀별로 키가 가장 큰 선수들 전체 정보 검색*/
SELECT p.*  FROM PLAYER p 
WHERE (HEIGHT) IN (SELECT MAX(HEIGHT)
				   FROM PLAYER 
				   WHERE p.TEAM_ID = TEAM_ID 
				   );
				  
SELECT p.*  FROM PLAYER p 
WHERE (TEAM_ID, HEIGHT) IN (SELECT TEAM_ID, MAX(HEIGHT)
				   FROM PLAYER 
				   GROUP BY TEAM_ID 
				   );
				  
SELECT P1.*
FROM PLAYER P1 JOIN
(
	SELECT TEAM_ID , MAX(HEIGHT) HEIGHT FROM PLAYER 
	GROUP BY TEAM_ID 
)P2
ON P1.TEAM_ID = P2.TEAM_ID AND P1.HEIGHT = P2.HEIGHT
ORDER BY P1.TEAM_ID;

/*EMP 테이블에서 사원의 이름과 매니저 이름을 검색*/
SELECT EMPLOYEE.ENAME 사원명, MANAGER.ENAME 관리자명
FROM EMP EMPLOYEE, EMP MANAGER
WHERE EMPLOYEE.MGR=MANAGER.EMPNO;

SELECT E1.ENAME EMPLOYEE, E2.ENAME MANAGER FROM EMP E1 JOIN EMP E2
ON E1.MGR = E2.EMPNO 

/*SQL 실행 순서*/
/*FROM > ON > JOIN > WHERE > GROUP BY > HAVING > SELECT > ORDER BY*/

/*[브론즈]*/
/*PLAYER 테이블에서 키가 NULL인 선수들은 키를 170으로 변경하여 평균 구하기(NULL 포함)*/
SELECT AVG(NVL(HEIGHT,170)) "평균 키" FROM PLAYER;

/*[실버]*/
/*PLAYER 테이블에서 팀 별 최대 몸무게*/
SELECT P.TEAM_ID, P.WEIGHT FROM PLAYER p 
WHERE (WEIGHT) IN (SELECT MAX(WEIGHT)
				   FROM PLAYER 
				   WHERE p.TEAM_ID = TEAM_ID 
				   );
				  
SELECT P.TEAM_ID, MAX(WEIGHT)"최대 몸무게" FROM PLAYER p 
GROUP BY TEAM_ID;

/*[골드]*/
/*AVG 함수를 쓰지 않고 PLAYER 테이블에서 선수들의 평균 키 구하기(NULL 포함)*/
SELECT SUM(NVL(HEIGHT,0))/COUNT(NVL(HEIGHT,0))FROM PLAYER; 
				  
/*[플래티넘]*/
/*DEPT 테이블의 LOC별 평균 급여를 반올림한 값과 각 LOC별 SAL 총 합을 조회, 반올림 : ROUND()*/
SELECT d.LOC, ROUND(AVG(e.SAL)), SUM(e.SAL)  FROM DEPT d JOIN EMP e 
ON d.DEPTNO = e.DEPTNO 
GROUP BY d.LOC ;

/*[다이아]*/
/*PLAYER 테이블에서 팀별 최대 몸무게인 선수 검색*/
SELECT P.* FROM PLAYER p 
WHERE (WEIGHT) IN (SELECT MAX(WEIGHT)
				   FROM PLAYER 
				   WHERE p.TEAM_ID = TEAM_ID 
				   );
				  
SELECT P2.* FROM
(
SELECT TEAM_ID, MAX(WEIGHT) MAX_WEIGHT FROM PLAYER
GROUP BY TEAM_ID
)P1 
JOIN PLAYER P2
ON P1.TEAM_ID = P2.TEAM_ID AND P1.MAX_WEIGHT = P2.WEIGHT
ORDER BY P1.TEAM_ID;

/*[마스터]*/
/*EMP 테이블에서 HIREDATE가 FORD의 입사년도와 같은 사원 전체 정보 조회*/
SELECT * FROM EMP 
WHERE TO_CHAR(HIREDATE, 'YYYY') = (SELECT TO_CHAR(HIREDATE, 'YYYY') FROM EMP WHERE ENAME = 'FORD'); 

/*외부 조인*/
/*JOIN 할 때 선행 또는 후행 중 하나의 테이블 정보를 모두 확인하고 싶을 때 사용한다.*/
SELECT TEAM_NAME, S.*
FROM TEAM T RIGHT OUTER JOIN STADIUM S
ON T.TEAM_ID = S.HOMETEAM_ID;

/*DEPARTMENT 테이블에서 매니저 이름 검색, 매니저가 없더라도 부서명 모두 검색*/
SELECT NVL(e.FIRST_NAME, 'NO') ||' ' || NVL(e.LAST_NAME, 'NAME') "매니저 이름",
d.DEPARTMENT_NAME  
FROM DEPARTMENTS d LEFT OUTER JOIN EMPLOYEES e 
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID AND d.MANAGER_ID = e.EMPLOYEE_ID 
ORDER BY d.MANAGER_ID;

/*EMPLOYEES 테이블에서 사원의 매니저 이름, 사원의 이름 조회, 매니저가 없는 사원은 본인이 매니저임을 표시*/
SELECT NVL(E2.FIRST_NAME, E1.FIRST_NAME) || ' ' || NVL(E2.LAST_NAME, E1.LAST_NAME) "매니저 이름",
E1.FIRST_NAME|| ' ' || E1.LAST_NAME "사원의 이름", E1.MANAGER_ID, E1.EMPLOYEE_ID 
FROM EMPLOYEES E2 RIGHT OUTER JOIN EMPLOYEES E1
ON E1.MANAGER_ID = E2.EMPLOYEE_ID;

/*EMPLOYEES 테이블에서 사원들의 FIRST_NAME 모두 조회, 사원들 중 매니저는 JOB_ID 조회*/
SELECT E1.FIRST_NAME, E2.JOB_ID, E1.MANAGER_ID, E1.EMPLOYEE_ID 
FROM EMPLOYEES E1 LEFT OUTER JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID;

/*EMPLOYEES에서 각 사원별로 관리부서(매니저)와 소속부서(사원) 조회*/
SELECT E1.JOB_ID 관리부서, E2.JOB_ID 소속부서, E2.FIRST_NAME 이름
FROM
(
   SELECT JOB_ID, MANAGER_ID FROM EMPLOYEES
   GROUP BY JOB_ID, MANAGER_ID
) E1 
FULL OUTER JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID
ORDER BY 소속부서 DESC;


/*VIEW*/
/*CREATE VIEW [이름] AS [쿼리문]
 *
 * 기존의 테이블을 그대로 놔둔 채 필요한 컬럼들 및 새로운 컬럼을 만든 가상 테이블.
 * 실제 데이터가 저장되는 것은 아니지만 VIEW를 통해서 데이터를 관리할 수 있다.
 * 
 * -독립성 : 다른 곳에서 접근하지 못하도록 하는 성질.
 * -편리성 : 길고 복잡한 쿼리문을 매번 작성할 필요가 없다.
 * -보안성 : 가존의 쿼리문이 보이지 않는다.
 * 
 * */

/*PLAYER 테이블에 나이 컬럼 추가한 뷰 만들기*/
CREATE VIEW VIEW_PLAYER AS SELECT FLOOR((SYSDATE - BIRTH_DATE)/365)AGE, P.* FROM PLAYER P;

SELECT * FROM VIEW_PLAYER WHERE AGE < 40;

/*EMPLOYEES 테이블에서 사원 이름과 그 사원의 매니저 이름이 있는 VIEW 만들기*/
CREATE VIEW EMPLOYEES_NAME AS SELECT NVL(E2.FIRST_NAME, E1.FIRST_NAME) || ' ' || NVL(E2.LAST_NAME, E1.LAST_NAME) "매니저 이름",
E1.FIRST_NAME|| ' ' || E1.LAST_NAME "사원의 이름"
FROM EMPLOYEES E2 RIGHT OUTER JOIN EMPLOYEES E1
ON E1.MANAGER_ID = E2.EMPLOYEE_ID;

SELECT * FROM EMPLOYEES_NAME;

/*PLAYER 테이블에서 TEAM_NAME 컬럼을 추가한 VIEW 만들기*/
CREATE VIEW VIEW_TEAM_NAME AS SELECT  TEAM_NAME, P.* 
FROM TEAM T JOIN PLAYER P 
ON P.TEAM_ID = T.TEAM_ID;

SELECT * FROM VIEW_TEAM_NAME;
