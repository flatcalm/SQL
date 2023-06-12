
-- 형 변환함수 TO_CHAR, TO_NUMBER, TO_DATE

-- 날짜를 문자로 TO_CHAR(값, 형식)
SELECT TO_CHAR(sysdate) FROM dual;
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD DY PM HH:MI:SS') FROM dual;
SELECT TO_CHAR(sysdate, 'YY-MM-DD HH24:MI:ss') FROM dual;

-- 사용하고 싶은 문자를 ""로 묶어 전달합니다.
SELECT first_name, TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"')
FROM employees;

-- 숫자를 문자로 TO_CHAR(값, 형식)
SELECT TO_CHAR(20000, '99999') FROM dual;
-- 주어진 자릿수에 숫자를 모두 표기할 수 없어서 모두 #으로 표기됩니다.
SELECT TO_CHAR(20000, '9999') FROM dual;
-- 소수점은 반올림해서 표기
SELECT TO_CHAR(20000.29, '99999.9') FROM dual;
SELECT TO_CHAR(20000, '99,999') FROM dual;

SELECT TO_CHAR(salary, 'L99,999') AS salary
FROM employees;

-- 문자를 숫자로 TO_NUMBER(값, 형식)
SELECT '2000' + 2000 FROM dual; -- 자동 형 변환 (문자 -> 숫자)
SELECT TO_NUMBER('2000') + 2000 FROM dual; -- 명시적 형 변환
SELECT '$3,300' + 2000 FROM dual; -- 에러
SELECT TO_NUMBER('$3,300', '$9,999') + 2000 FROM dual;

-- 문자를 날짜로 변환하는 함수 TO_DATE(값, 형식)
SELECT TO_DATE('2023-04-13') FROM dual;
SELECT sysdate - TO_DATE('2021-03-26') FROM dual;
SELECT TO_DATE('2020/12/25', 'YY-MM-DD') FROM dual;
-- 주어진 문자열을 모두 변환해야 합니다.
SELECT TO_DATE('2021-03-31 12:23:50', 'YY-MM-DD HH:MI:SS') FROM dual;

-- xxxx년 xx월 xx일 문자열 형식으로 변환해 보세요.
-- 조회 컬럼명은 dateInfo 라고 하겠습니다.
SELECT TO_CHAR(TO_DATE('20050102', 'YYYYMMDD'), 'YYYY"년" MM"월" DD"일"') AS dateInfo FROM dual;

-- NULL 제거 함수 NVL(컬럼, 변환할 타겟값)
SELECT null FROM dual;
SELECT NVL(null, 0) FROM dual;

SELECT
    first_name,
    NVL(commission_pct, 0) AS comm_pct
FROM employees;

-- NULL 제거 함수 NVL2(컬럼, null이 아닐 경우의 값, null일 경우의 값)
SELECT
    NVL2('abc', '널아님', '널임')
FROM dual;

SELECT
    first_name, NVL2(commission_pct, 'true', 'false') AS commission
FROM employees;

SELECT
    first_name,
    commission_pct,
    NVL2(commission_pct, salary + (salary * commission_pct), salary) AS real_salary
FROM employees;

-- DECODE(컬럼 혹은 표현식, 항목1, 결과1, 항목2, 결과2 ........ default)
SELECT
    DECODE('C', 'A', 'A입니다.', 'B', 'B입니다', 'C', 'C입니다', '모르겠는데요?')
FROM dual;

SELECT
    job_id,
    salary,
    DECODE(
        job_id,
        'IT_PROG',
        salary*1.1,
        'FI_MGR',
        salary*1.2,
        'AD_VP',
        salary*1.3
    ) AS result
FROM employees;

-- CASE WHEN THEN END
SELECT
    first_name,
    job_id,
    salary,
    (CASE job_id
        WHEN 'IT_PROG' THEN salary*1.1
        WHEN 'FI_MGR' THEN  salary*1.2
        WHEN 'AD_VP' THEN salary*1.3
        WHEN 'FI_ACCOUNT' THEN salary*1.4
        ELSE salary
    END) AS result
FROM employees;

-- 문제 1.
-- 현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 17년 이상인
-- 사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
-- 조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.
SELECT
    employee_id AS 사원번호,
    first_name || last_name AS 사원명,
    hire_date AS 입사일자,
    TRUNC((sysdate - hire_date) / 365) AS 근속년수
FROM employees
WHERE TRUNC((sysdate - hire_date) / 365) >= 17
ORDER BY 근속년수 DESC;

/*
SQL 실행 순서에 의해 FROM에서 테이블 결정 이후 WHERE에서 조건을 설정하고
SELECT에서 AS에 의해 별칭이 결정된 후에 ORDER BY가 실행되기 때문에
ORDER BY에서는 별칭을 사용할 수 있지만 WHERE에서는 별칭을 사용할 수 없다.
(WHERE는 SELECT보다 먼저 실행되기 때문에 별칭이 설정되기 이전)
*/

-- 문제 2.
-- EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
-- 100이라면 ‘사원’, 
-- 120이라면 ‘주임’
-- 121이라면 ‘대리’
-- 122라면 ‘과장’
-- 나머지는 ‘임원’ 으로 출력합니다.
-- 조건 1) department_id가 50인 사람들을 대상으로만 조회합니다.

-- 내가 한거
SELECT
    first_name AS 이름,
    manager_id AS 직급코드,
    (CASE manager_id
        WHEN 100 THEN '사원'
        WHEN 120 THEN '주임'
        WHEN 121 THEN '대리'
        WHEN 122 THEN '과장'
        ELSE '임원'
    END) AS 직급
FROM employees
WHERE department_id = 50;

-- 강사님
SELECT
    first_name AS 이름,
    manager_id AS 직급코드,
    DECODE(
        manager_id,
        100, '사원',
        120, '주임',
        121, '대리',
        122, '과장',
        '임원'
    ) AS 직급
FROM employees
WHERE department_id = 50;

----------------------------------------------

-- 에러 (DECODE에는 범위를 지정할 수 없다)
SELECT
    salary,
    employee_id,
    first_name,
    DECODE(
        salary,
        salary >= 4000 , 'A',
        salary >= 3000 AND salary <= 3999, 'B',
        salary >= 2000 AND salary <= 2999, 'C',
        salary >= 1000 AND salary <= 1999, 'D',
        salary >= 0 AND salary <= 999, 'E'
    ) AS grade
FROM employees
ORDER BY salary DESC;

-- 기준값을 만들어주어서 작성해야 함
SELECT
    salary,
    employee_id,
    first_name,
    DECODE(
        TRUNC(salary / 1000),
        0 , 'E',
        1, 'D',
        2, 'C',
        3, 'B',
        'A'
    ) AS grade
FROM employees
ORDER BY salary DESC;

-- CASE 뒤 조건 부분을 생략할 수 있다.
-- WHEN을 기준으로 바로 적용
SELECT
    salary,
    employee_id,
    first_name,
    (CASE
        WHEN salary BETWEEN 0 AND 999 THEN 'E'
        WHEN salary BETWEEN 1000 AND 1999 THEN 'D'
        WHEN salary BETWEEN 2000 AND 2999 THEN 'C'
        WHEN salary BETWEEN 3000 AND 3999 THEN 'B'
        ELSE 'A'
    END) AS grade
FROM employees
ORDER BY salary DESC;