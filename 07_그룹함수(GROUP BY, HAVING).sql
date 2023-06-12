
-- 그룹 함수 AVG, MAX, MIN, SUM, COUNT

-- 그룹화를 하지 않고 그룹 함수만을 사용하면 테이블 전체를 그룹화해서 실행
SELECT
    AVG(salary),
    MAX(salary),
    MIN(salary),
    SUM(salary),
    COUNT(salary)
FROM employees;

SELECT COUNT(*) FROM employees; -- 총 행 데이터의 수 (null 포함)
SELECT COUNT(first_name) FROM employees;
SELECT COUNT(commission_pct) FROM employees; -- null이 아닌 행의 수
SELECT COUNT(manager_id) FROM employees; -- null이 아닌 행의 수

-- 부서별로 그룹화, 그룹함수의 사용
SELECT
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id;

-- 주의할 점
-- 그룹 함수는 일반 컬럼과 동시에 그냥 출력할 수는 없습니다.
SELECT
    department_id,
    AVG(salary)
FROM employees; -- 에러

-- GROUP BY 절을 사용할 때 GROUP 절에 묶이지 않으면 다른 컬럼을 조회할 수 없습니다.
SELECT
    job_id,
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id; -- 에러

-- GROUP BY절 2개 이상 사용
SELECT
    job_id,
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;

-- GROUP BY를 통해 그룹화를 할 때 조건을 걸 경우 HAVING을 사용.
SELECT
    department_id,
    AVG(salary)
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 100000;

SELECT
    job_id,
    COUNT(job_id)
FROM employees
GROUP BY job_id
HAVING COUNT(*) >= 5;

-- 부서 아이디가 50 이상인 것들을 그룹화 시키고, 그룹 월급 평균이 5000 이상만 조회
SELECT
    department_id,
    AVG(salary) AS 평균
FROM employees
WHERE department_id >= 50
GROUP BY department_id
HAVING AVG(salary) >= 5000
ORDER BY department_id DESC;
