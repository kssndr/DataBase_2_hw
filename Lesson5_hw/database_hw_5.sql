-- 1. Реализовать практические задания на примере других таблиц и запросов.
-- Транзакции
USE geodata;
LOCK TABLES geodata READ;
-- http://www.mysql.ru/docs/man/LOCK_TABLES.html 
-- Что такое потоки?
-- блокировка на время внесения доп данных по региону в стране 22
LOCK TABLES _countries READ, _regions WRITE;
SELECT COUNT(*) FROM _regions WHERE country_id=22;
INSERT INTO _regions SET title = 'BBBBB', country_id = 22;

UNLOCK TABLES;
-- проверка
SELECT * FROM _regions WHERE title = 'BBBBB';
-- EXPLAIN
EXPLAIN SELECT COUNT(*) FROM geodata._regions WHERE country_id=22;
EXPLAIN SELECT * FROM _cities;
EXPLAIN SELECT _regions.title AS Region, COUNT(_cities.id) FROM _regions LEFT JOIN _cities ON _regions.id = _cities.region_id GROUP BY _regions.title;

-- 2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.
-- В MySQL транзакции поддерживаются только таблицами innoDB. Таблицы MyISAM транзакции не поддерживают. 
-- В innoDB по умолчанию включен autocommit, это значит, что по умолчанию каждый запрос эквивалентен одной транзакции.
-- http://momjian.us/main/writings/pgsql/mvcc.pdf
Start transaction;
INSERT INTO _countries (id, title) VALUES (11111, 'OZ');
INSERT INTO _regions (id, country_id, title) VALUES (2222222, 11111, 'Zhivuny'); 
commit;
SELECT * FROM _countries WHERE title ='OZ';

-- 3. Проанализировать несколько запросов с помощью EXPLAIN.

USE employees;
SHOW TABLES; 
EXPLAIN SELECT * FROM delete_employee_max_salary;
SHOW WARNINGS;
-- no warnings
-- работа с новой базой
USE test;
EXPLAIN SELECT * FROM
orderdetails d
INNER JOIN orders o ON d.orderNumber = o.orderNumber
INNER JOIN products p ON p.productCode = d.productCode
INNER JOIN productlines l ON p.productLine = l.productLine
INNER JOIN customers c on c.customerNumber = o.customerNumber
WHERE o.orderNumber = 10101;

-- описание к результату EXPLAIN:
-- тип соединения ALL - MySQL не смог определить ни одного ключа, который бы мог использоваться при соединении. 
-- rows показывает, что MySQL сканирует все записи каждой таблицы для запроса 
-- после добавление ключей (см ниже) мы получаем результат EXPLAIN где: 
-- тип соединения – “const”, самым быстрым типом соединения для таблиц с более, чем одной записью. 
-- MySQL смогла использовать PRIMARY KEY как индекс
-- В поле “ref” отображается “const”

-- ДОБАВИМ ОСНОВНЫЕ КЛЮЧИ
ALTER TABLE customers
    ADD PRIMARY KEY (customerNumber);
ALTER TABLE employees
    ADD PRIMARY KEY (employeeNumber);
ALTER TABLE offices
    ADD PRIMARY KEY (officeCode);
ALTER TABLE orderdetails
    ADD PRIMARY KEY (orderNumber, productCode);
ALTER TABLE orders
    ADD PRIMARY KEY (orderNumber),
    ADD KEY (customerNumber);
ALTER TABLE payments
    ADD PRIMARY KEY (customerNumber, checkNumber);
ALTER TABLE productlines
    ADD PRIMARY KEY (productLine);
ALTER TABLE products 
    ADD PRIMARY KEY (productCode),
    ADD KEY (buyPrice),
    ADD KEY (productLine);
ALTER TABLE productvariants 
    -- ADD PRIMARY KEY (variantId),
    ADD KEY (buyPrice),
    ADD KEY (productCode);
    
EXPLAIN SELECT * FROM (
SELECT p.productName, p.productCode, p.buyPrice, l.productLine, p.status, l.status AS lineStatus FROM
products p
INNER JOIN productlines l ON p.productLine = l.productLine
UNION
SELECT v.variantName AS productName, v.productCode, p.buyPrice, l.productLine, p.status, l.status AS lineStatus FROM productvariants v
INNER JOIN products p ON p.productCode = v.productCode
INNER JOIN productlines l ON p.productLine = l.productLine
) products
WHERE status = 'Active' AND lineStatus = 'Active' AND buyPrice BETWEEN 30 AND 50;

-- вопросы к таблице по результатам этого EXPLAIN:
-- ПРОБЛЕМЫ: products и productvarians сканируются полностью - нет индексов для столбцов productLine и buyPrice
-- полях possible_keys и key отображаются значения NULL. 
-- Статус таблиц products и productlines проверяется после UNION’а
-- в Extra есть Using temporary

-- Добавляем индексы:

CREATE INDEX idx_buyPrice ON products(buyPrice);
CREATE INDEX idx_buyPrice ON productvariants(buyPrice);
CREATE INDEX idx_productCode ON productvariants(productCode);
CREATE INDEX idx_productLine ON products(productLine);

-- проверяем:

EXPLAIN SELECT * FROM (
SELECT p.productName, p.productCode, p.buyPrice, l.productLine, p.status, l.status as lineStatus FROM products p
INNER JOIN productlines AS l ON (p.productLine = l.productLine AND p.status = 'Active' AND l.status = 'Active') 
WHERE buyPrice BETWEEN 30 AND 50
UNION
SELECT v.variantName AS productName, v.productCode, p.buyPrice, l.productLine, p.status, l.status FROM productvariants v
INNER JOIN products p ON (p.productCode = v.productCode AND p.status = 'Active') 
INNER JOIN productlines l ON (p.productLine = l.productLine AND l.status = 'Active')
WHERE
v.buyPrice BETWEEN 30 AND 50
) product;

-- число rows уменьшилось

