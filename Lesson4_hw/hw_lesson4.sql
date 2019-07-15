USE employees;
-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
-- Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
USE geodata;

CREATE VIEW Moscow_info AS
	SELECT s.title AS City, r.title AS Region, c.title AS Country FROM _cities s
	LEFT JOIN _regions r ON s.region_id = r.id
	LEFT JOIN _countries c ON s.country_id = c.id
	WHERE s.title = 'Москва';

SELECT * FROM Moscow_info;

-- Выбрать все города из Московской области.

CREATE VIEW Moscow_area_cities AS
SELECT r.title AS Area, c.title AS City
FROM _cities c
LEFT JOIN _regions r ON r.id = c.region_id
WHERE r.title= "Московская область";

SELECT * FROM Moscow_area_cities;

-- 2. База данных «Сотрудники»:

-- Выбрать среднюю зарплату по отделам
USE employees;

CREATE VIEW Dept_AVG_Salary AS
SELECT AVG(salary), d.dept_name
FROM salaries s
LEFT JOIN dept_emp de
	ON de.emp_no = s.emp_no
LEFT JOIN departments d
ON d.dept_no = de.dept_no
GROUP BY d.dept_name;

SELECT * FROM Dept_AVG_Salary;

-- Выбрать максимальную зарплату у сотрудника.

CREATE VIEW Max_salary AS
	SELECT emp_no, MAX(salary) 
		FROM salaries
        GROUP BY emp_no
        LIMIT 1;
        
SELECT emp_no FROM MAX_salary;

-- ВЫВЕСТИ(Удалить) данные одного сотрудника, у которого максимальная зарплата. - 
DROP VIEW Delete_Employee_max_salary;
CREATE VIEW Delete_Employee_max_salary AS 
	SELECT d.dept_name, e.emp_no, e.hire_date, e.birth_date, e.last_name, e.first_name, s.salary, s.to_date FROM dept_emp de
    LEFT JOIN departments d ON d.dept_no = de.dept_no
	LEFT JOIN dept_manager dm ON de.emp_no = dm.emp_no
	LEFT JOIN employees e ON de.emp_no = e.emp_no
	LEFT JOIN salaries s ON de.emp_no = s.emp_no
	LEFT JOIN titles t ON de.emp_no = t.emp_no WHERE de.emp_no = (SELECT emp_no FROM Max_salary);

SELECT * FROM Delete_Employee_max_salary;

-- Посчитать количество сотрудников во всех отделах.

CREATE VIEW Staff_dept AS
	SELECT d.dept_name AS Department, COUNT(de.emp_no) AS Staff
    FROM departments d
		LEFT JOIN dept_emp de ON de.dept_no = d.dept_no
        WHERE to_date = '9999-01-01'
        GROUP BY d.dept_name;
        
SELECT * FROM Staff_dept;

-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

CREATE VIEW Staff_Salary_Dept AS
	SELECT COUNT(s.emp_no), SUM(s.salary), de.dept_no
    FROM salaries s
		LEFT JOIN dept_emp de ON de.emp_no = s.emp_no
        WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
        GROUP BY de.dept_no;

SELECT * FROM Staff_Salary_Dept;

-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.

DESCRIBE employees;


DROP FUNCTION IF EXISTS Person_find;

DELIMITER //
CREATE FUNCTION Person_find(f_name VARCHAR(14), l_name VARCHAR(16))
RETURNS INT(11)
DETERMINISTIC
BEGIN
	DECLARE tabl_no INT(11);
	SELECT 
    emp_no
INTO tabl_no FROM
    employees
WHERE
    first_name = f_name
	AND last_name = l_name;
	RETURN tabl_no;
END
//
DELIMITER ;

SELECT Person_find('Bezalel', 'Simmel');
    
-- 3. Создать триггер, который при добавлении нового сотрудника будет 
-- выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

DROP TRIGGER IF EXISTS Wellcome_bonus;

DELIMITER //
CREATE TRIGGER Wellcome_bonus AFTER INSERT ON employees
FOR EACH ROW 
BEGIN
	INSERT INTO salaries SET emp_no = NEW.emp_no, salary = '1000000',
    from_date = curdate(), to_date = '9999-01-01';
END
//
DELIMITER ;

INSERT INTO employees(emp_no, birth_date, first_name, last_name, gender, hire_date) VALUE ('1','1111-11-11', '1', '1', '1', '1111-11-11');

-- для проверки
SELECT * FROM salaries WHERE salary = '1000000';

INSERT INTO employees(emp_no, birth_date, first_name, last_name, gender, hire_date) VALUE ('5','2222-2-2', '2', '2', '2', '2222-2-2');