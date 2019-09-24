/*
База данных «Страны и города мира»:

1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.

2. Выбрать все города из Московской области.
*/

USE geodata;

-- ищем город Москва

SELECT _cities.title AS city, _regions.title AS region, _countries.title AS country FROM _cities 
LEFT JOIN _regions ON _cities.region_id = _regions.id 
LEFT JOIN _countries ON _regions.country_id = _countries.id 
WHERE _cities.title = 'Москва' ORDER BY _countries.title DESC;

-- ищем все города Московсой области

SELECT _regions.title AS region,_cities.title AS city FROM _cities 
LEFT JOIN  _regions ON _cities.region_id = _regions.id 
WHERE _regions.title LIKE 'Московская%' ORDER BY _cities.title ASC;


 /*
База данных «Сотрудники»:

1. Выбрать среднюю зарплату по отделам.

2. Выбрать максимальную зарплату у сотрудника.

3. Удалить одного сотрудника, у которого максимальная зарплата.

4. Посчитать количество сотрудников во всех отделах.

5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

source /Users/mac/Desktop/Database/Lesson3/employees/employees.sql;
*/
-- 1. Выбрать среднюю зарплату по отделам.

SELECT d.dept_name Department, AVG(salary) FROM salaries s
LEFT JOIN employees e ON s.emp_no = e.emp_no
LEFT JOIN dept_emp ON dept_emp.emp_no = e.emp_no
LEFT JOIN departments d ON d.dept_no = dept_emp.dept_no
GROUP BY d.dept_name;

-- 2. Выбрать максимальную зарплату у сотрудника.

SELECT s.emp_no, CONCAT(e.last_name,' ', e.first_name) employeer, MAX(salary)
FROM salaries s
LEFT JOIN employees e ON e.emp_no = s.emp_no 
LEFT JOIN dept_emp ON dept_emp.emp_no = e.emp_no
WHERE s.emp_no = 49965;

-- с указанием департамента

SELECT s.emp_no, CONCAT(e.last_name,' ', e.first_name) employeer, d.dept_name Department, MAX(salary) 
FROM salaries s 
LEFT JOIN employees e ON e.emp_no = s.emp_no 
LEFT JOIN dept_emp ON dept_emp.emp_no = e.emp_no
LEFT JOIN departments d ON d.dept_no = dept_emp.dept_no 
WHERE s.emp_no = 48888
GROUP BY d.dept_name;

-- 3. Удалить одного сотрудника, у которого максимальная зарплата.

-- список 5 сотрудников с максимальной зарплатой

SELECT e.emp_no, CONCAT(e.last_name,' ', e.first_name) employeer, MAX(salary) AS max_salary
FROM salaries s
LEFT JOIN employees e ON e.emp_no = s.emp_no
GROUP BY s.emp_no
ORDER BY max_salary DESC
LIMIT 5;

-- удаление сотрудника с максим зарплатой по номеру сотрудника из всех таблиц где есть номер сотрудника

DELETE de, dm, e, s, t FROM dept_emp de
LEFT JOIN dept_manager dm ON de.emp_no = dm.emp_no
LEFT JOIN employees e ON de.emp_no = e.emp_no
LEFT JOIN salaries s ON de.emp_no = s.emp_no
LEFT JOIN titles t ON de.emp_no = t.emp_no
WHERE de.emp_no = 43624;

-- 4. Посчитать количество сотрудников во всех отделах.

-- сколько всего сотрудников на данный момент

SELECT COUNT(emp_no) FROM employees WHERE emp_no IN (SELECT DISTINCT emp_no FROM titles WHERE to_date = '9999-01-01');

-- всего в каждом департаменте на текущий момент

SELECT de.dept_no, COUNT(de.emp_no) AS q 
FROM dept_emp de 
WHERE de.emp_no IN (SELECT DISTINCT emp_no FROM titles WHERE to_date = '9999-01-01') 
GROUP BY de.dept_no 
ORDER BY q DESC;

-- видимо часть сотрудников находиться в нескольких департаментах одновременно, проверка

-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

-- всего в каждом департаменте на текущий момент период 1990-1991


SELECT de.dept_no,d.dept_name, COUNT(de.emp_no) AS number_of_employees 
FROM dept_emp de 
LEFT JOIN departments d ON d.dept_no = de.dept_no 
WHERE de.emp_no IN (SELECT DISTINCT emp_no FROM titles WHERE de.from_date > '1990%' AND de.to_date < '1991%') 
GROUP BY de.dept_no  
ORDER BY number_of_employees DESC;

-- общая сумма зарплат по отделам в период 1990-1991


SELECT de.dept_no, d.dept_name, SUM(s.salary) AS salary_total
FROM dept_emp de
LEFT JOIN salaries s ON s.emp_no = de.emp_no
LEFT JOIN departments d ON d.dept_no = de.dept_no
WHERE de.emp_no IN (SELECT DISTINCT emp_no FROM titles WHERE de.from_date > '1990%' AND de.to_date < '1991%')                                                                    
GROUP BY de.dept_no
ORDER BY salary_total DESC;
