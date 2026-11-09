-- PHẦN 1: TẠO BẢNG VÀ THÊM DỮ LIỆU
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
);

CREATE TABLE restaurant (
    res_id SERIAL PRIMARY KEY,
    res_name VARCHAR(255),
    image VARCHAR(255),
    "desc" VARCHAR(255)
);

CREATE TABLE food_type (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(255)
);

CREATE TABLE food (
    food_id SERIAL PRIMARY KEY,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    "desc" VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

CREATE TABLE sub_food (
    sub_id SERIAL PRIMARY KEY,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE "order" (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES "user"(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "user"(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "user"(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

INSERT INTO "user" (full_name, email, password) VALUES 
('Nguyen Van A', 'a@gmail.com', '123'),
('Tran Thi B', 'b@gmail.com', '123'),
('Le Van C', 'c@gmail.com', '123'),
('Pham Thi D', 'd@gmail.com', '123'),
('Ngo Van E', 'e@gmail.com', '123'),
('Vu Thi F', 'f@gmail.com', '123'), 
('Hoang Van G', 'g@gmail.com', '123'); 

INSERT INTO restaurant (res_name, image, "desc") VALUES 
('Nhà hàng 1', 'img1.jpg', 'Ngon'),
('Nhà hàng 2', 'img2.jpg', 'Bổ'),
('Nhà hàng 3', 'img3.jpg', 'Rẻ');

INSERT INTO food_type (type_name) VALUES ('Đồ ăn nhanh'), ('Đồ uống');

INSERT INTO food (food_name, image, price, "desc", type_id) VALUES 
('Gà rán', 'ga.jpg', 50000, 'Giòn', 1),
('Trà sữa', 'trasua.jpg', 30000, 'Ngọt', 2);

INSERT INTO like_res (user_id, res_id, date_like) VALUES 
(1, 1, '2023-10-01'), (1, 2, '2023-10-01'), (1, 3, '2023-10-01'), 
(2, 1, '2023-10-02'), (2, 2, '2023-10-02'),
(3, 1, '2023-10-03'),
(4, 1, '2023-10-04'), (4, 3, '2023-10-04'),
(5, 2, '2023-10-05');

INSERT INTO "order" (user_id, food_id, amount, code, arr_sub_id) VALUES 
(1, 1, 2, 'ORD01', ''),
(1, 2, 1, 'ORD02', ''),
(2, 1, 5, 'ORD03', ''),
(3, 2, 1, 'ORD04', '');

INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES 
(1, 1, 5, '2023-10-01');


-- PHẦN 2: CÂU TRUY VẤN BÀI TẬP YÊU CẦU

-- 1. Tìm 5 người đã like nhà hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(l.res_id) AS total_likes
FROM "user" u
JOIN like_res l ON u.user_id = l.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_likes DESC
LIMIT 5;

-- 2. Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT r.res_id, r.res_name, COUNT(l.user_id) AS total_likes
FROM restaurant r
JOIN like_res l ON r.res_id = l.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_likes DESC
LIMIT 2;

-- 3. Tìm người đã đặt hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(o.food_id) AS total_orders
FROM "user" u
JOIN "order" o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_orders DESC
LIMIT 1;

-- 4. Tìm người dùng không hoạt động trong hệ thống
SELECT u.user_id, u.full_name
FROM "user" u
LEFT JOIN "order" o ON u.user_id = o.user_id
LEFT JOIN like_res l ON u.user_id = l.user_id
LEFT JOIN rate_res r ON u.user_id = r.user_id
WHERE o.user_id IS NULL 
  AND l.user_id IS NULL 
  AND r.user_id IS NULL;