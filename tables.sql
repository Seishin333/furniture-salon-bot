-- 1. Створюємо саму базу
SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

DROP DATABASE IF EXISTS furniture_salon;
CREATE DATABASE furniture_salon CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE furniture_salon;

-- 2. Створюємо таблиці, явно вказуючи назву бази через крапку
CREATE TABLE furniture_salon.client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200)
);

CREATE TABLE furniture_salon.employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE furniture_salon.supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(200)
);

CREATE TABLE furniture_salon.furniture (
    furniture_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    material VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    supplier_id INT,
    INDEX idx_furniture_supplier (supplier_id),
    CONSTRAINT fk_furniture_supplier FOREIGN KEY (supplier_id) REFERENCES furniture_salon.supplier(supplier_id) ON DELETE SET NULL
);

CREATE TABLE furniture_salon.`order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(30) DEFAULT 'Нове',
    client_id INT NOT NULL,
    employee_id INT,
    INDEX idx_order_client (client_id),
    INDEX idx_order_employee (employee_id),
    CONSTRAINT fk_order_client FOREIGN KEY (client_id) REFERENCES furniture_salon.client(client_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_employee FOREIGN KEY (employee_id) REFERENCES furniture_salon.employee(employee_id) ON DELETE SET NULL
);

CREATE TABLE furniture_salon.order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    furniture_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_sale DECIMAL(10,2) NOT NULL,
    INDEX idx_item_order (order_id),
    INDEX idx_item_furniture (furniture_id),
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES furniture_salon.`order`(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_item_furniture FOREIGN KEY (furniture_id) REFERENCES furniture_salon.furniture(furniture_id) ON DELETE CASCADE
);

-- 3. Наповнюємо даними, також через повне ім'я
INSERT INTO furniture_salon.client (full_name, phone, email, address) VALUES
('Олександр Іваненко', '+380501112233', 'ivanenko@email.com', 'Київ'),
('Марія Ковальчук', '+380672223344', 'kovalchuk@email.com', 'Львів'),
('Дмитро Бондар', '+380933334455', 'bondar@email.com', 'Одеса'),
('Олена Петренко', '+380504445566', 'petrenko@email.com', 'Харків'),
('Андрій Сидоренко', '+380675556677', 'sydorenko@email.com', 'Дніпро'),
('Світлана Ткаченко', '+380936667788', 'tkachenko@email.com', 'Запоріжжя'),
('Ігор Мороз', '+380507778899', 'moroz@email.com', 'Вінниця'),
('Тетяна Шевченко', '+380678889900', 'shevchenko@email.com', 'Полтава'),
('Василь Кравченко', '+380939990011', 'kravchenko@email.com', 'Черкаси'),
('Наталія Лисенко', '+380500001122', 'lysenko@email.com', 'Житомир');

INSERT INTO furniture_salon.employee (full_name, position, phone) VALUES
('Микола Степанов', 'Менеджер', '+380671002030'),
('Ганна Мельник', 'Консультант', '+380672003040'),
('Віктор Павлов', 'Менеджер', '+380673004050'),
('Юлія Соколова', 'Дизайнер', '+380674005060'),
('Артем Бєлов', 'Логіст', '+380675006070'),
('Ольга Рябова', 'Касир', '+380676007080'),
('Максим Колос', 'Менеджер', '+380677008090'),
('Ірина Вовк', 'Адміністратор', '+380678009010'),
('Сергій Кушнір', 'Консультант', '+380679001020'),
('Олена Гаврилюк', 'Завідувач', '+380670001122');

INSERT INTO furniture_salon.supplier (name, phone, address) VALUES
('Меблі Люкс', '0441234567', 'Київ'),
('Дерево Плюс', '0327654321', 'Львів'),
('Комфорт Майстер', '0481112233', 'Одеса'),
('Еко Меблі', '0572223344', 'Харків'),
('Скандинавія Хаус', '0563334455', 'Дніпро'),
('Дуб та Сосна', '0445556677', 'Київ'),
('М’яка Лінія', '0614445566', 'Запоріжжя'),
('Стиль Декор', '0432221100', 'Вінниця'),
('Еліт Фурнітура', '0532223344', 'Полтава'),
('Техно Меблі', '0412556677', 'Житомир');

INSERT INTO furniture_salon.furniture (name, type, material, price, stock_quantity, supplier_id) VALUES
('Стілець', 'Стільці', 'Пластик', 1200, 50, 1),
('Диван', 'Дивани', 'Оксамит', 15500, 5, 7),
('Стіл', 'Столи', 'Дуб', 4800, 12, 2),
('Шафа', 'Шафи', 'ДСП', 8200, 8, 3),
('Ліжко', 'Ліжка', 'Бук', 12300, 4, 6),
('Крісло', 'Крісла', 'Тканина', 3500, 15, 7),
('Полиця', 'Полиці', 'МДФ', 950, 20, 5),
('Тумба', 'Тумби', 'Скло', 2800, 10, 10),
('Комод', 'Комоди', 'Сосна', 5400, 7, 6),
('Стіл офісний', 'Столи', 'Горіх', 6200, 6, 2);

INSERT INTO furniture_salon.`order` (total_amount, status, client_id, employee_id) VALUES
(2400, 'Завершено', 1, 1), (15500, 'Завершено', 2, 2), (4800, 'Оплачено', 3, 3),
(8200, 'Доставка', 4, 4), (12300, 'Нове', 5, 5), (7000, 'Завершено', 6, 6),
(1900, 'Завершено', 7, 7), (2800, 'Оплачено', 8, 8), (5400, 'Нове', 9, 9), (12400, 'Нове', 10, 1);

INSERT INTO furniture_salon.order_item (order_id, furniture_id, quantity, price_at_sale) VALUES
(1, 1, 2, 1200), (2, 2, 1, 15500), (3, 3, 1, 4800), (4, 4, 1, 8200), (5, 5, 1, 12300),
(6, 6, 2, 3500), (7, 7, 2, 950), (8, 8, 1, 2800), (9, 9, 1, 5400), (10, 10, 2, 6200);

-- Перевірка
SELECT * FROM furniture_salon.employee;