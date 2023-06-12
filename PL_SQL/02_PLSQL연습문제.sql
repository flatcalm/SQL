
-- 1. ������ �� 3���� ����ϴ� �͸� ����� ����� ����. (��¹� 9���� �����ؼ� ������)
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

-- 2. employees ���̺��� 201�� ����� �̸��� �̸��� �ּҸ� ����ϴ� 
-- �͸� ����� ����� ����. (������ ��Ƽ� ����ϼ���.)
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
    
    dbms_output.put_line('�̸� : ' || v_emp_name || ' �̸��� : ' || v_emp_email);
END;

-- 3. employees ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� �� (MAX �Լ� ���) 
-- �� ��ȣ + 1������ �Ʒ��� ����� emps ���̺� 
-- employee_id, last_name, email, hire_date, job_id�� �ű� �����ϴ� �͸� ����� ���弼��.
-- SELECT�� ���Ŀ� INSERT�� ����� �����մϴ�.
/*
<�����> : steven
<�̸���> : stevenjobs
<�Ի�����> : ���ó�¥
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
