
/*
���ν����� guguProc
�������� ���޹޾� �ش� �ܼ��� ����ϴ� procedure�� �����ϼ���.
*/
CREATE OR REPLACE PROCEDURE guguProc
    (
    p_dan IN NUMBER
    )
IS
BEGIN
    dbms_output.put_line(p_dan || '��');
    FOR i IN 1..9
    LOOP
        dbms_output.put_line(p_dan || ' x ' || i || ' = ' || p_dan*i);
    END LOOP;
END;

EXEC guguProc(14);

/*
�μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
depts ���̺� 
���� INSERT, UPDATE, DELETE �ϴ� depts_proc �� �̸��� ���ν����� ������.
�׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
*/
ALTER TABLE depts ADD CONSTRAINT depts_pk PRIMARY KEY(department_id);

CREATE OR REPLACE PROCEDURE depts_proc
    (
    flag IN VARCHAR2,
    p_depts_id NUMBER,
    p_depts_name VARCHAR2 := '���Է�',
    p_mng_id NUMBER := null,
    p_loc_id NUMBER := 1700
    )
IS
    v_cnt NUMBER := 0;
BEGIN

    SELECT COUNT(*)
    INTO v_cnt
    FROM depts
    WHERE department_id = p_depts_id;

    IF flag = 'I' THEN
        INSERT INTO depts
        VALUES(p_depts_id, p_depts_name, p_mng_id, p_loc_id);
    ELSIF flag = 'U' THEN
        UPDATE depts
        SET department_name = p_depts_name,
        manager_id = p_mng_id,
        location_id = p_loc_id
        WHERE department_id = p_depts_id;
    ELSIF flag = 'D' THEN
        IF v_cnt = 0 THEN
            dbms_output.put_line('�����ϰ��� �ϴ� �μ��� �������� �ʽ��ϴ�.');
            RETURN;
        END IF;
        DELETE depts
        WHERE department_id = p_depts_id;
    ELSE
        dbms_output.put_line(flag || '��(��) �ùٸ��� ���� �Ű���.');
    END IF;
    
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RETURN;
    
    COMMIT;
    
END;

SELECT * FROM depts;

EXEC depts_proc('I', 210);
EXEC depts_proc('U', 210, '�ȳ�μ�', 200, 1900);
EXEC depts_proc('D', 1568);

/*
employee_id�� �Է¹޾� employees�� �����ϸ�,
�ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���. (�͸��Ͽ��� ���ν����� ����)
���ٸ� exceptionó���ϼ���
*/
CREATE OR REPLACE PROCEDURE emp_hire
    (
    p_emp_id IN employees.employee_id%TYPE,
    p_year OUT NUMBER
    )
IS
    v_hire_date DATE;
BEGIN
    SELECT
        hire_date
    INTO
        v_hire_date
    FROM employees
    WHERE employee_id = p_emp_id;
    
    p_year := (sysdate - v_hire_date) / 365;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line(p_emp_id || '��(��) �������� �ʴ� id�Դϴ�.');
            RETURN;
        WHEN OTHERS THEN
            dbms_output.put_line('�� �� ���� ���� �߻�!');
            RETURN;
END;

DECLARE
    v_year NUMBER(10);
BEGIN
    emp_hire(100, v_year);
    dbms_output.put_line('�ټӳ�� : ' || v_year || '��');
END;

SELECT * FROM employees;

/*
���ν����� - new_emp_proc
employees ���̺��� ���� ���̺� emps�� �����մϴ�.
employee_id, last_name, email, hire_date, job_id�� �Է¹޾�
�����ϸ� �̸�, �̸���, �Ի���, ������ update, 
���ٸ� insert�ϴ� merge���� �ۼ��ϼ���

������ �� Ÿ�� ���̺� -> emps
���ս�ų ������ -> ���ν����� ���޹��� employee_id�� dual�� select ������ ��.
���ν����� ���޹޾ƾ� �� �� : ���, last_name, email, hire_date, job_id
*/
CREATE OR REPLACE PROCEDURE new_emp_proc
    (
    p_emp_id IN emps.employee_id%TYPE,
    p_last_name IN emps.last_name%TYPE,
    p_email IN emps.email%TYPE,
    p_hire_date IN emps.hire_date%TYPE,
    p_job_id IN emps.job_id%TYPE
    )
IS
BEGIN
    MERGE INTO emps a
        USING
            (SELECT p_emp_id AS emp_id FROM dual) b
        ON
            (a.employee_id = b.emp_id)
    WHEN MATCHED THEN
        UPDATE SET
            a.last_name = p_last_name,
            a.email = p_email,
            a.hire_date = p_hire_date,
            a.job_id = p_job_id
    WHEN NOT MATCHED THEN
        INSERT (a.employee_id, a.last_name, a.email, a.hire_date, a.job_id) VALUES
            (p_emp_id, p_last_name, p_email, p_hire_date, p_job_id);
            
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('�� �� ���� ���� �߻�!');
            dbms_output.put_line('SQL ERROR CODE : ' || SQLCODE);
            dbms_output.put_line('SQL ERROR MSG : ' || SQLERRM);
            RETURN;
END;

EXEC new_emp_proc(210, 'hihiname', 'hiemail', sysdate, 'CEO');

SELECT * FROM emps;
