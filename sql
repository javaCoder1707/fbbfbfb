-- ===========================================
-- АВТОСАЛОН - СОЗДАНИЕ БАЗЫ ДАННЫХ
-- ===========================================

-- 1. СОЗДАНИЕ БАЗЫ ДАННЫХ
CREATE DATABASE IF NOT EXISTS `autosalon` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `autosalon`;

-- 2. ТАБЛИЦА ПОЛЬЗОВАТЕЛЕЙ СИСТЕМЫ
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(50) UNIQUE NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100),
    `role` ENUM('Администратор', 'Менеджер', 'Консультант') NOT NULL DEFAULT 'Консультант',
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `last_login` TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. ТАБЛИЦА МАРОК АВТОМОБИЛЕЙ
CREATE TABLE IF NOT EXISTS `brands` (
    `BrandID` INT PRIMARY KEY AUTO_INCREMENT,
    `BrandName` VARCHAR(50) UNIQUE NOT NULL,
    `Country` VARCHAR(50),
    `Description` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. ТАБЛИЦА АВТОМОБИЛЕЙ
CREATE TABLE IF NOT EXISTS `cars` (
    `CarID` INT PRIMARY KEY AUTO_INCREMENT,
    `BrandID` INT NOT NULL,
    `Model` VARCHAR(100) NOT NULL,
    `Year` INT NOT NULL,
    `Color` VARCHAR(30),
    `Price` DECIMAL(12, 2) NOT NULL,
    `VIN` VARCHAR(17) UNIQUE NOT NULL,
    `InStock` BOOLEAN DEFAULT TRUE,
    `ArrivalDate` DATE DEFAULT (CURRENT_DATE),
    `Description` TEXT,
    `Mileage` INT DEFAULT 0,
    `EngineVolume` DECIMAL(3,1),
    `FuelType` ENUM('Бензин', 'Дизель', 'Электричество', 'Гибрид') DEFAULT 'Бензин',
    `Transmission` ENUM('Механика', 'Автомат', 'Робот', 'Вариатор') DEFAULT 'Механика',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`BrandID`) REFERENCES `brands`(`BrandID`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. ТАБЛИЦА ПОКУПАТЕЛЕЙ
CREATE TABLE IF NOT EXISTS `customers` (
    `CustomerID` INT PRIMARY KEY AUTO_INCREMENT,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(100) UNIQUE,
    `Phone` VARCHAR(20) NOT NULL,
    `Address` TEXT,
    `BirthDate` DATE,
    `Passport` VARCHAR(20) UNIQUE,
    `Notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. ТАБЛИЦА СОТРУДНИКОВ
CREATE TABLE IF NOT EXISTS `employees` (
    `EmployeeID` INT PRIMARY KEY AUTO_INCREMENT,
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Position` VARCHAR(100) NOT NULL,
    `Department` VARCHAR(100),
    `Phone` VARCHAR(20) NOT NULL,
    `Email` VARCHAR(100) UNIQUE,
    `Address` TEXT,
    `BirthDate` DATE,
    `HireDate` DATE DEFAULT (CURRENT_DATE),
    `Salary` DECIMAL(10, 2) DEFAULT 0,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. ТАБЛИЦА ПРОДАЖ
CREATE TABLE IF NOT EXISTS `sales` (
    `SaleID` INT PRIMARY KEY AUTO_INCREMENT,
    `CarID` INT NOT NULL,
    `CustomerID` INT NOT NULL,
    `EmployeeID` INT NOT NULL,
    `SaleDate` DATE NOT NULL DEFAULT (CURRENT_DATE),
    `SalePrice` DECIMAL(12, 2) NOT NULL,
    `PaymentMethod` ENUM('Наличные', 'Карта', 'Кредит', 'Рассрочка') DEFAULT 'Наличные',
    `Commission` DECIMAL(10, 2) DEFAULT 0,
    `Notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`CarID`) REFERENCES `cars`(`CarID`) ON DELETE RESTRICT,
    FOREIGN KEY (`CustomerID`) REFERENCES `customers`(`CustomerID`) ON DELETE RESTRICT,
    FOREIGN KEY (`EmployeeID`) REFERENCES `employees`(`EmployeeID`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. ТАБЛИЦА ИСТОРИИ ЛОГИНОВ
CREATE TABLE IF NOT EXISTS `login_history` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `login_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `ip_address` VARCHAR(45),
    `user_agent` TEXT,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===========================================
-- ЗАПОЛНЕНИЕ ТЕСТОВЫМИ ДАННЫМИ
-- ===========================================

-- 1. ДОБАВЛЕНИЕ ПОЛЬЗОВАТЕЛЕЙ (пароль: admin123)
INSERT INTO `users` (`username`, `password`, `full_name`, `email`, `role`, `is_active`) VALUES
-- Пароль в SHA-256: admin123
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Иванов Иван Иванович', 'admin@autosalon.ru', 'Администратор', TRUE),
('manager', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Петрова Мария Сергеевна', 'manager@autosalon.ru', 'Менеджер', TRUE),
('consultant1', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Сидоров Алексей Петрович', 'consultant1@autosalon.ru', 'Консультант', TRUE),
('consultant2', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Кузнецова Елена Владимировна', 'consultant2@autosalon.ru', 'Консультант', TRUE);

-- 2. ДОБАВЛЕНИЕ МАРОК АВТОМОБИЛЕЙ
INSERT INTO `brands` (`BrandName`, `Country`) VALUES
('Toyota', 'Япония'),
('BMW', 'Германия'),
('Mercedes-Benz', 'Германия'),
('Audi', 'Германия'),
('Volkswagen', 'Германия'),
('Hyundai', 'Южная Корея'),
('Kia', 'Южная Корея'),
('Lada', 'Россия'),
('Skoda', 'Чехия'),
('Ford', 'США'),
('Honda', 'Япония'),
('Nissan', 'Япония'),
('Mazda', 'Япония'),
('Lexus', 'Япония'),
('Volvo', 'Швеция');

-- 3. ДОБАВЛЕНИЕ АВТОМОБИЛЕЙ
INSERT INTO `cars` (`BrandID`, `Model`, `Year`, `Color`, `Price`, `VIN`, `InStock`, `EngineVolume`, `FuelType`, `Transmission`) VALUES
(1, 'Camry', 2023, 'Черный', 3500000.00, 'JTDBT123456789012', TRUE, 2.5, 'Бензин', 'Автомат'),
(1, 'RAV4', 2023, 'Белый', 3200000.00, 'JTMBF123456789013', TRUE, 2.0, 'Бензин', 'Автомат'),
(1, 'Land Cruiser', 2023, 'Серый', 8500000.00, 'JTEHT123456789014', TRUE, 4.5, 'Бензин', 'Автомат'),
(2, 'X5', 2023, 'Синий', 6500000.00, 'WBA12345678901234', TRUE, 3.0, 'Бензин', 'Автомат'),
(2, '3 Series', 2023, 'Красный', 4200000.00, 'WBA22345678901235', TRUE, 2.0, 'Бензин', 'Автомат'),
(2, '5 Series', 2023, 'Черный', 5500000.00, 'WBA32345678901236', TRUE, 2.5, 'Дизель', 'Автомат'),
(3, 'E-Class', 2023, 'Серый', 5500000.00, 'WDD12345678901235', TRUE, 2.0, 'Дизель', 'Автомат'),
(3, 'S-Class', 2023, 'Черный', 12500000.00, 'WDD22345678901236', TRUE, 3.0, 'Бензин', 'Автомат'),
(3, 'GLE', 2023, 'Белый', 7800000.00, 'WDD32345678901237', TRUE, 3.0, 'Дизель', 'Автомат'),
(4, 'A6', 2023, 'Красный', 5200000.00, 'WAU12345678901236', FALSE, 2.0, 'Бензин', 'Автомат'),
(4, 'Q7', 2023, 'Серебристый', 6800000.00, 'WAU22345678901237', TRUE, 3.0, 'Дизель', 'Автомат'),
(4, 'A4', 2023, 'Синий', 3800000.00, 'WAU32345678901238', TRUE, 1.8, 'Бензин', 'Автомат'),
(5, 'Tiguan', 2023, 'Серебристый', 2800000.00, 'WVG12345678901237', TRUE, 1.4, 'Бензин', 'Автомат'),
(5, 'Passat', 2023, 'Черный', 2200000.00, 'WVG22345678901238', TRUE, 1.8, 'Бензин', 'Автомат'),
(5, 'Polo', 2023, 'Белый', 1500000.00, 'WVG32345678901239', TRUE, 1.6, 'Бензин', 'Механика'),
(6, 'Solaris', 2023, 'Белый', 1500000.00, 'KMH12345678901238', TRUE, 1.6, 'Бензин', 'Механика'),
(6, 'Tucson', 2023, 'Оранжевый', 2500000.00, 'KMH22345678901239', TRUE, 2.0, 'Бензин', 'Автомат'),
(6, 'Creta', 2023, 'Красный', 1800000.00, 'KMH32345678901240', TRUE, 1.6, 'Бензин', 'Автомат'),
(7, 'Sportage', 2023, 'Оранжевый', 2500000.00, 'KNA12345678901239', TRUE, 2.0, 'Бензин', 'Автомат'),
(7, 'Rio', 2023, 'Серый', 1200000.00, 'KNA22345678901240', TRUE, 1.6, 'Бензин', 'Механика'),
(7, 'Sorento', 2023, 'Черный', 3500000.00, 'KNA32345678901241', TRUE, 2.5, 'Бензин', 'Автомат'),
(8, 'Vesta', 2023, 'Коричневый', 1200000.00, 'XTA12345678901240', TRUE, 1.6, 'Бензин', 'Механика'),
(8, 'Granta', 2023, 'Белый', 900000.00, 'XTA22345678901241', TRUE, 1.6, 'Бензин', 'Механика'),
(8, 'Niva', 2023, 'Зеленый', 1100000.00, 'XTA32345678901242', TRUE, 1.7, 'Бензин', 'Механика'),
(9, 'Octavia', 2023, 'Зеленый', 2200000.00, 'TMB12345678901241', TRUE, 1.4, 'Бензин', 'Автомат'),
(9, 'Kodiaq', 2023, 'Коричневый', 3200000.00, 'TMB22345678901242', TRUE, 2.0, 'Дизель', 'Автомат'),
(9, 'Superb', 2023, 'Черный', 2800000.00, 'TMB32345678901243', TRUE, 2.0, 'Бензин', 'Автомат'),
(10, 'Focus', 2023, 'Синий', 1800000.00, 'WF02345678901244', TRUE, 1.6, 'Бензин', 'Автомат'),
(10, 'Mondeo', 2023, 'Серый', 2400000.00, 'WF12345678901245', TRUE, 2.0, 'Дизель', 'Автомат'),
(10, 'Explorer', 2023, 'Черный', 4500000.00, 'WF22345678901246', TRUE, 3.5, 'Бензин', 'Автомат');

-- 4. ДОБАВЛЕНИЕ ПОКУПАТЕЛЕЙ
INSERT INTO `customers` (`FirstName`, `LastName`, `Email`, `Phone`, `Address`, `BirthDate`, `Passport`) VALUES
('Александр', 'Смирнов', 'smirnov@mail.ru', '+79161234567', 'ул. Ленина, д. 10, кв. 5, Москва', '1985-03-15', '4510123456'),
('Екатерина', 'Иванова', 'ivanova@mail.ru', '+79162345678', 'пр. Победы, д. 25, кв. 12, Санкт-Петербург', '1990-07-22', '4510765432'),
('Дмитрий', 'Петров', 'petrov@mail.ru', '+79163456789', 'ул. Мира, д. 3, кв. 7, Екатеринбург', '1978-11-30', '4510987654'),
('Ольга', 'Сидорова', 'sidorova@mail.ru', '+79164567890', 'ул. Гагарина, д. 15, кв. 3, Новосибирск', '1992-02-14', '4510543210'),
('Михаил', 'Кузнецов', 'kuznetsov@mail.ru', '+79165678901', 'ул. Советская, д. 8, кв. 9, Казань', '1988-09-05', '4510234567'),
('Анна', 'Попова', 'popova@mail.ru', '+79166789012', 'ул. Кирова, д. 45, кв. 13, Нижний Новгород', '1995-04-18', '4510876543'),
('Сергей', 'Васильев', 'vasiliev@mail.ru', '+79167890123', 'пр. Ленина, д. 78, кв. 21, Самара', '1982-12-03', '4510345678'),
('Наталья', 'Морозова', 'morozova@mail.ru', '+79168901234', 'ул. Пушкина, д. 34, кв. 8, Челябинск', '1993-06-25', '4510654321'),
('Андрей', 'Волков', 'volkov@mail.ru', '+79169012345', 'ул. Чехова, д. 12, кв. 15, Омск', '1987-08-14', '4510890123'),
('Елена', 'Лебедева', 'lebedeva@mail.ru', '+79160123456', 'ул. Горького, д. 56, кв. 4, Ростов-на-Дону', '1991-01-30', '4510456789');

-- 5. ДОБАВЛЕНИЕ СОТРУДНИКОВ
INSERT INTO `employees` (`FirstName`, `LastName`, `Position`, `Department`, `Phone`, `Email`, `HireDate`, `Salary`) VALUES
('Анна', 'Волкова', 'Менеджер по продажам', 'Продажи', '+79166789012', 'volkova@autosalon.ru', '2020-05-10', 80000.00),
('Сергей', 'Попов', 'Старший консультант', 'Продажи', '+79167890123', 'popov@autosalon.ru', '2021-03-15', 60000.00),
('Наталья', 'Лебедева', 'Консультант', 'Продажи', '+79168901234', 'lebedeva@autosalon.ru', '2022-01-20', 50000.00),
('Артем', 'Козлов', 'Администратор', 'Администрация', '+79169012345', 'kozlov@autosalon.ru', '2019-08-05', 90000.00),
('Марина', 'Новикова', 'Бухгалтер', 'Бухгалтерия', '+79160123456', 'novikova@autosalon.ru', '2020-11-12', 75000.00),
('Игорь', 'Федоров', 'Консультант', 'Продажи', '+79161234567', 'fedorov@autosalon.ru', '2023-02-01', 45000.00),
('Татьяна', 'Михеева', 'Менеджер по клиентам', 'Продажи', '+79162345678', 'mikheeva@autosalon.ru', '2021-09-15', 70000.00),
('Павел', 'Захаров', 'Специалист по гарантии', 'Сервис', '+79163456789', 'zakharov@autosalon.ru', '2020-07-20', 65000.00),
('Юлия', 'Орлова', 'Маркетолог', 'Маркетинг', '+79164567890', 'orlova@autosalon.ru', '2022-03-10', 55000.00),
('Владимир', 'Антонов', 'Технический специалист', 'Сервис', '+79165678901', 'antonov@autosalon.ru', '2021-11-05', 60000.00);

-- 6. ДОБАВЛЕНИЕ ПРОДАЖ
INSERT INTO `sales` (`CarID`, `CustomerID`, `EmployeeID`, `SaleDate`, `SalePrice`, `PaymentMethod`, `Commission`) VALUES
(10, 1, 2, '2023-10-15', 5200000.00, 'Кредит', 260000.00),
(2, 3, 1, '2023-10-18', 3200000.00, 'Карта', 160000.00),
(7, 2, 3, '2023-10-20', 5500000.00, 'Рассрочка', 275000.00),
(4, 5, 2, '2023-11-05', 6500000.00, 'Наличные', 325000.00),
(13, 4, 1, '2023-11-10', 2800000.00, 'Карта', 140000.00),
(16, 6, 3, '2023-11-15', 1500000.00, 'Кредит', 75000.00),
(22, 7, 2, '2023-11-20', 1200000.00, 'Наличные', 60000.00),
(25, 8, 1, '2023-11-25', 2200000.00, 'Рассрочка', 110000.00),
(28, 9, 3, '2023-12-01', 1800000.00, 'Карта', 90000.00),
(3, 10, 2, '2023-12-05', 8500000.00, 'Кредит', 425000.00);

-- ===========================================
-- СОЗДАНИЕ ИНДЕКСОВ ДЛЯ УСКОРЕНИЯ РАБОТЫ
-- ===========================================

CREATE INDEX idx_users_username ON `users`(`username`);
CREATE INDEX idx_users_role ON `users`(`role`);
CREATE INDEX idx_brands_name ON `brands`(`BrandName`);
CREATE INDEX idx_cars_instock ON `cars`(`InStock`);
CREATE INDEX idx_cars_price ON `cars`(`Price`);
CREATE INDEX idx_cars_brand_year ON `cars`(`BrandID`, `Year`);
CREATE INDEX idx_customers_name ON `customers`(`LastName`, `FirstName`);
CREATE INDEX idx_customers_phone ON `customers`(`Phone`);
CREATE INDEX idx_employees_name ON `employees`(`LastName`, `FirstName`);
CREATE INDEX idx_employees_position ON `employees`(`Position`);
CREATE INDEX idx_sales_date ON `sales`(`SaleDate`);
CREATE INDEX idx_sales_customer ON `sales`(`CustomerID`);
CREATE INDEX idx_sales_employee ON `sales`(`EmployeeID`);
CREATE INDEX idx_login_history_user ON `login_history`(`user_id`);

-- ===========================================
-- СОЗДАНИЕ ПРЕДСТАВЛЕНИЙ (VIEWS)
-- ===========================================

-- Представление для автомобилей в наличии
CREATE OR REPLACE VIEW `available_cars` AS
SELECT 
    c.CarID,
    b.BrandName,
    c.Model,
    c.Year,
    c.Color,
    c.Price,
    c.VIN,
    c.FuelType,
    c.Transmission,
    c.EngineVolume,
    c.Mileage
FROM `cars` c
JOIN `brands` b ON c.BrandID = b.BrandID
WHERE c.InStock = TRUE
ORDER BY b.BrandName, c.Model;

-- Представление для отчета по продажам
CREATE OR REPLACE VIEW `sales_report` AS
SELECT 
    s.SaleID,
    s.SaleDate,
    b.BrandName,
    c.Model,
    CONCAT(cust.FirstName, ' ', cust.LastName) AS CustomerName,
    CONCAT(emp.FirstName, ' ', emp.LastName) AS EmployeeName,
    s.SalePrice,
    s.PaymentMethod,
    s.Commission,
    s.SalePrice - s.Commission AS NetIncome
FROM `sales` s
JOIN `cars` c ON s.CarID = c.CarID
JOIN `brands` b ON c.BrandID = b.BrandID
JOIN `customers` cust ON s.CustomerID = cust.CustomerID
JOIN `employees` emp ON s.EmployeeID = emp.EmployeeID
ORDER BY s.SaleDate DESC;

-- Представление для статистики по месяцам
CREATE OR REPLACE VIEW `monthly_statistics` AS
SELECT 
    DATE_FORMAT(SaleDate, '%Y-%m') AS Month,
    COUNT(*) AS SalesCount,
    SUM(SalePrice) AS TotalRevenue,
    AVG(SalePrice) AS AverageSale,
    SUM(Commission) AS TotalCommission,
    SUM(SalePrice - Commission) AS NetProfit
FROM `sales`
GROUP BY DATE_FORMAT(SaleDate, '%Y-%m')
ORDER BY Month DESC;

-- Представление для лучших продавцов
CREATE OR REPLACE VIEW `top_sellers` AS
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.Position,
    COUNT(s.SaleID) AS SalesCount,
    SUM(s.SalePrice) AS TotalSales,
    SUM(s.Commission) AS TotalCommission
FROM `employees` e
LEFT JOIN `sales` s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Position
ORDER BY TotalSales DESC;

-- ===========================================
-- ПРОЦЕДУРЫ И ФУНКЦИИ
-- ===========================================

-- Процедура для расчета комиссии сотрудника
DELIMITER //
CREATE PROCEDURE `calculate_employee_commission`(
    IN employee_id INT,
    IN start_date DATE,
    IN end_date DATE,
    OUT total_commission DECIMAL(12,2)
)
BEGIN
    SELECT COALESCE(SUM(Commission), 0) INTO total_commission
    FROM `sales`
    WHERE EmployeeID = employee_id
    AND SaleDate BETWEEN start_date AND end_date;
END //
DELIMITER ;

-- Функция для проверки наличия автомобиля
DELIMITER //
CREATE FUNCTION `check_car_availability`(car_vin VARCHAR(17))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_available BOOLEAN;
    
    SELECT InStock INTO is_available
    FROM `cars`
    WHERE VIN = car_vin;
    
    RETURN COALESCE(is_available, FALSE);
END //
DELIMITER ;

-- Процедура для оформления продажи
DELIMITER //
CREATE PROCEDURE `register_sale`(
    IN p_car_id INT,
    IN p_customer_id INT,
    IN p_employee_id INT,
    IN p_sale_price DECIMAL(12,2),
    IN p_payment_method VARCHAR(20)
)
BEGIN
    DECLARE commission_amount DECIMAL(10,2);
    
    -- Расчет комиссии (5%)
    SET commission_amount = p_sale_price * 0.05;
    
    -- Начало транзакции
    START TRANSACTION;
    
    -- Добавление записи о продаже
    INSERT INTO `sales` (CarID, CustomerID, EmployeeID, SalePrice, PaymentMethod, Commission)
    VALUES (p_car_id, p_customer_id, p_employee_id, p_sale_price, p_payment_method, commission_amount);
    
    -- Обновление статуса автомобиля
    UPDATE `cars` 
    SET InStock = FALSE 
    WHERE CarID = p_car_id;
    
    -- Фиксация транзакции
    COMMIT;
END //
DELIMITER ;

-- ===========================================
-- ТРИГГЕРЫ
-- ===========================================

-- Триггер для обновления времени последнего входа
DELIMITER //
CREATE TRIGGER `update_last_login`
AFTER INSERT ON `login_history`
FOR EACH ROW
BEGIN
    UPDATE `users`
    SET last_login = NEW.login_time
    WHERE id = NEW.user_id;
END //
DELIMITER ;

-- Триггер для проверки цены автомобиля
DELIMITER //
CREATE TRIGGER `check_car_price`
BEFORE INSERT ON `cars`
FOR EACH ROW
BEGIN
    IF NEW.Price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Цена автомобиля должна быть больше 0';
    END IF;
END //
DELIMITER ;

-- ===========================================
-- СОЗДАНИЕ ПОЛЬЗОВАТЕЛЯ ДЛЯ ПРИЛОЖЕНИЯ
-- ===========================================

-- Создание пользователя для приложения (закомментировано, раскомментируйте при необходимости)
/*
CREATE USER IF NOT EXISTS 'autosalon_app'@'localhost' IDENTIFIED BY 'AppPassword123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON `autosalon`.* TO 'autosalon_app'@'localhost';
GRANT EXECUTE ON PROCEDURE `autosalon`.`calculate_employee_commission` TO 'autosalon_app'@'localhost';
GRANT EXECUTE ON PROCEDURE `autosalon`.`register_sale` TO 'autosalon_app'@'localhost';
FLUSH PRIVILEGES;
*/

-- ===========================================
-- ВЫВОД ИНФОРМАЦИИ О СОЗДАННЫХ ТАБЛИЦАХ
-- ===========================================

SELECT 
    TABLE_NAME AS 'Таблица',
    TABLE_ROWS AS 'Кол-во записей',
    CREATE_TIME AS 'Дата создания',
    UPDATE_TIME AS 'Последнее обновление'
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'autosalon'
ORDER BY TABLE_NAME;

-- ===========================================
-- ПРОВЕРКА ДАННЫХ
-- ===========================================

SELECT 'Пользователи:' AS '';
SELECT id, username, full_name, role, is_active FROM `users`;

SELECT 'Марки автомобилей:' AS '';
SELECT BrandID, BrandName, Country FROM `brands` LIMIT 5;

SELECT 'Автомобили в наличии:' AS '';
SELECT COUNT(*) AS 'Кол-во авто в наличии' FROM `cars` WHERE InStock = TRUE;

SELECT 'Покупатели:' AS '';
SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS Name, Phone FROM `customers` LIMIT 5;

SELECT 'Сотрудники:' AS '';
SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS Name, Position, Salary FROM `employees` LIMIT 5;

SELECT 'Продажи:' AS '';
SELECT COUNT(*) AS 'Общее кол-во продаж', 
       SUM(SalePrice) AS 'Общая выручка',
       AVG(SalePrice) AS 'Средний чек'
FROM `sales`;

-- ===========================================
-- КОНЕЦ СКРИПТА
-- ===========================================