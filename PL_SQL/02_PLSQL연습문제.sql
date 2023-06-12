
-- 1. 구구단 중 3단을 출력하는 익명 블록을 만들어 보자. (출력문 9개를 복사해서 쓰세요)
DECLARE
    x NUMBER := 3;
BEGIN
    dbms_output.put_line(x || ' x 1 = ' || x*1);
    dbms_output.put_line(x || ' x 2 = ' || x*2);
    dbms_output.put_line(x || ' x 3 = ' || x*3);
    dbms_output.put_line(x || ' x 4 = ' || x*4);
    dbms_output.put_line(x || ' x 5 = ' || x*5);
    dbms_output.put_line(x || ' x 6 = ' || x*6);
    dbms_output.put_line(x || ' x 7 = ' || x*7);
    dbms_output.put_line(x || ' x 8 = ' || x*8);
    dbms_output.put_line(x || ' x 9 = ' || x*9);
END;

-- 2. employees 테이블에서 201번 사원의 이름과 이메일 주소를 출력하는 
-- 익명 블록을 만들어 보자. (변수에 담아서 출력하세요.)
DECLARE
    v_emp_name employees.first_name%TYPE;
    v_emp_email employees.email%TYPE;
BEGIN
    SELECT
        first_name, email
    INTO
        v_emp_name, v_emp_email
    FROM employees
    WHERE employee_id = 201;
    
    dbms_output.put_line('이름 : ' || v_emp_name || ' 이메일 : ' || v_emp_email);
END;

-- 3. employees 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤 (MAX 함수 사용) 
-- 이 번호 + 1번으로 아래의 사원을 emps 테이블에 
-- employee_id, last_name, email, hire_date, job_id를 신규 삽입하는 익명 블록을 만드세요.
-- SELECT절 이후에 INSERT문 사용이 가능합니다.
/*
<사원명> : steven
<이메일> : stevenjobs
<입사일자> : 오늘날짜
<JOB_ID> : CEO
*/
DROP TABLE emps;
CREATE TABLE emps AS (SELECT * FROM employees WHERE 1=2);

DECLARE
    emp_num employees.employee_id%TYPE;
BEGIN
    SELECT MAX(employee_id) INTO emp_num FROM employees;
    
    INSERT INTO emps (employee_id, last_name, email, hire_date, job_id)
    VALUES(emp_num+1, 'steven', 'stevenjobs', sysdate, 'CEO');
    
    COMMIT;
    
END;

SELECT * FROM emps;
