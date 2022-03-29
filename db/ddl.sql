CREATE TABLE IF NOT EXISTS Restaurant
(
    id                   INT PRIMARY KEY AUTO_INCREMENT,
    name                 VARCHAR(255) NOT NULL,
    published            BOOLEAN      NOT NULL DEFAULT TRUE,
    address_street       VARCHAR(255) NOT NULL,
    address_house_number VARCHAR(10),
    address_city         VARCHAR(64)  NOT NULL,
    address_latitude     FLOAT(10, 6) NOT NULL,
    address_longitude    FLOAT(10, 6) NOT NULL
);

CREATE TABLE IF NOT EXISTS RestaurantPhone
(
    phone      VARCHAR(14) NOT NULL,
    restaurant INT         NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (phone, restaurant)
);

CREATE TABLE IF NOT EXISTS OpeningHours
(
    weekday      INT  NOT NULL CHECK (weekday >= 0 AND weekday <= 6),
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    restaurant   INT  NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (weekday, restaurant, opening_time)
);

CREATE TABLE IF NOT EXISTS Menu
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    title      VARCHAR(255) NOT NULL,
    published  BOOLEAN      NOT NULL DEFAULT FALSE,
    restaurant INT          NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MenuCategory
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    title      VARCHAR(255) NOT NULL,
    menu       INT          NOT NULL,
    FOREIGN KEY (menu) REFERENCES Menu (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Product
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    price       FLOAT(10, 2) NOT NULL CHECK (price > 0),
    restaurant  INT          NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS MenuCategoryContent
(
    category INT NOT NULL,
    product  INT NOT NULL,
    FOREIGN KEY (category) REFERENCES MenuCategory (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (product) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Allergen
(
    name VARCHAR(100) PRIMARY KEY
);
INSERT INTO Allergen (name)
VALUES ('cereals'),
       ('crustaceans'),
       ('eggs'),
       ('fish'),
       ('peanuts'),
       ('soybeans'),
       ('milk'),
       ('nuts'),
       ('celery'),
       ('mustard'),
       ('sesame'),
       ('sulphurDioxide'),
       ('lupin'),
       ('molluscs');

CREATE TABLE IF NOT EXISTS ProductAllergens
(
    product  INT          NOT NULL,
    allergen VARCHAR(100) NOT NULL,
    FOREIGN KEY (product) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (allergen) REFERENCES Allergen (name) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (product, allergen)
);

CREATE TABLE IF NOT EXISTS User
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    name     VARCHAR(255) NOT NULL,
    surname  VARCHAR(255) NOT NULL,
    password VARCHAR(60)  NOT NULL,
    rider    BOOLEAN      NOT NULL DEFAULT FALSE,
    admin    BOOLEAN      NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS UserEmail
(
    user  INT NOT NULL,
    email VARCHAR(255) PRIMARY KEY,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS UserPhone
(
    user  INT NOT NULL,
    phone VARCHAR(14) PRIMARY KEY,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Cart
(
    user    INT NOT NULL,
    product INT NOT NULL,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (product) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user, product)
);

CREATE TABLE IF NOT EXISTS LoginSession
(
    token      VARCHAR(60) PRIMARY KEY,
    agent      VARCHAR(255) NOT NULL,
    ip         VARCHAR(15)  NOT NULL,
    creation   DATETIME     NOT NULL DEFAULT NOW(),
    last_usage DATETIME     NOT NULL DEFAULT NOW(),
    user       INT          NOT NULL,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Review
(
    creation   DATETIME NOT NULL,
    mark       INT      NOT NULL CHECK (mark > 0 AND mark < 6),
    title      VARCHAR(255),
    text       VARCHAR(255),
    restaurant INT,
    user       INT,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user, restaurant)
);

CREATE TABLE IF NOT EXISTS OrdersManager
(
    begin_date DATETIME NOT NULL,
    end_date   DATETIME,
    user       INT      NOT NULL,
    restaurant INT,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id) ON UPDATE CASCADE ON DELETE NO ACTION,
    PRIMARY KEY (user, restaurant, begin_date)
);

CREATE TABLE IF NOT EXISTS RiderService
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    user            INT          NOT NULL,
    begin_time      DATETIME     NOT NULL,
    begin_latitude  FLOAT(10, 6) NOT NULL,
    begin_longitude FLOAT(10, 6) NOT NULL,
    end_time        DATETIME,
    end_latitude    FLOAT(10, 6),
    end_longitude   FLOAT(10, 6),
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (user, begin_time)
);

CREATE TABLE IF NOT EXISTS OrderStatus
(
    id INT PRIMARY KEY
);
INSERT INTO OrderStatus (id)
VALUES (100),
       (200),
       (300),
       (400);

CREATE TABLE IF NOT EXISTS RestaurantOrder
(
    id                   INT PRIMARY KEY AUTO_INCREMENT,
    status               INT                   DEFAULT 100,
    creation             DATETIME     NOT NULL DEFAULT NOW(),
    notes                VARCHAR(255),
    address_street       VARCHAR(255) NOT NULL,
    address_house_number VARCHAR(10),
    address_city         VARCHAR(64)  NOT NULL,
    address_latitude     FLOAT(10, 6) NOT NULL,
    address_longitude    FLOAT(10, 6) NOT NULL,
    user                 INT,
    rider_service        INT,
    FOREIGN KEY (status) REFERENCES OrderStatus (id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (user) REFERENCES User (id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (rider_service) REFERENCES RiderService (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS OrderContent
(
    product          INT NOT NULL,
    restaurant       INT NOT NULL,
    restaurant_order INT,
    quantity         INT NOT NULL CHECK (quantity > 0 AND quantity < 10),
    FOREIGN KEY (product) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (restaurant_order) REFERENCES RestaurantOrder (id) ON UPDATE CASCADE ON DELETE NO ACTION,
    PRIMARY KEY (product, restaurant, restaurant_order)
);

-- Views
CREATE VIEW ProductWithAllergens AS
SELECT Product.*, PA.allergen
FROM Product
         LEFT JOIN ProductAllergens PA ON Product.id = PA.product;

CREATE VIEW RestaurantDetails AS
SELECT Restaurant.*,
       OpeningHours.opening_time,
       OpeningHours.closing_time,
       OpeningHours.weekday,
       RestaurantPhone.phone,
       R.average_rating
FROM Restaurant
         RIGHT JOIN OpeningHours ON Restaurant.id = OpeningHours.restaurant
         LEFT JOIN RestaurantPhone ON Restaurant.id = RestaurantPhone.restaurant
         LEFT JOIN (SELECT Restaurant.id, AVG(Review.mark) as average_rating
                    FROM Restaurant
                             LEFT JOIN Review ON Restaurant.id = Review.restaurant) R ON Restaurant.id = R.id;

CREATE VIEW RestaurantsWithMenus AS
SELECT RestaurantDetails.*,
       Menu.title     AS menu_title,
       Menu.published AS menu_published,
       Menu.id        AS menu_id,
       MC.id          AS category_id,
       MC.title       AS category_title,
       P.id           AS product_id,
       P.name         AS product_name,
       P.description  AS product_description,
       P.price        AS product_price,
       P.allergen
FROM RestaurantDetails
         LEFT JOIN Menu ON Menu.restaurant = RestaurantDetails.id
         LEFT JOIN MenuCategory MC ON Menu.id = MC.menu
         LEFT JOIN MenuCategoryContent MCC on MC.id = MCC.category
         LEFT JOIN ProductWithAllergens P on MCC.product = P.id;


-- Triggers
-- TODO


-- Apply the haversine formula to calculate
-- the distance between 2 points on Earth in KMs
DROP FUNCTION IF EXISTS DISTANCE_KM;
DELIMITER $$
CREATE FUNCTION DISTANCE_KM(lat0 FLOAT(10, 6),
                            lon0 FLOAT(10, 6),
                            lat1 FLOAT(10, 6),
                            lon1 FLOAT(10, 6)) RETURNS FLOAT(10, 3)
    DETERMINISTIC
BEGIN
    DECLARE lat1Rad FLOAT(10, 9);
    DECLARE lat0Rad FLOAT(10, 9);
    DECLARE deltaLon FLOAT(10, 9);

    SET lat1Rad = radians(lat1);
    SET lat0Rad = radians(lat0);
    SET deltaLon = radians(lon1 - lon0);

    RETURN 6371 * acos(sin(lat0Rad) * sin(lat1Rad) + cos(lat0Rad) * cos(lat1Rad) * cos(deltaLon));
END$$
DELIMITER ;

