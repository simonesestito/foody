CREATE TABLE IF NOT EXISTS Restaurant
(
    id                   INT PRIMARY KEY AUTO_INCREMENT,
    name                 VARCHAR(255) NOT NULL,
    published            BOOLEAN      NOT NULL DEFAULT TRUE,
    address_street       VARCHAR(255) NOT NULL,
    address_house_number VARCHAR(10),
    address_latitude     FLOAT(10, 6) NOT NULL,
    address_longitude    FLOAT(10, 6) NOT NULL
);

CREATE TABLE IF NOT EXISTS RestaurantPhone
(
    phone      VARCHAR(14) NOT NULL,
    restaurant INT         NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (phone, restaurant)
);

CREATE TABLE IF NOT EXISTS OpeningHours
(
    weekday      INT  NOT NULL CHECK (weekday >= 0 AND weekday <= 6),
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    restaurant   INT  NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (weekday, restaurant, opening_time)
);

CREATE TABLE IF NOT EXISTS Menu
(
    id         INT          NOT NULL AUTO_INCREMENT,
    title      VARCHAR(255) NOT NULL,
    published  BOOLEAN      NOT NULL DEFAULT FALSE,
    restaurant INT          NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id, restaurant)
);

CREATE TABLE IF NOT EXISTS MenuCategory
(
    id         INT          NOT NULL AUTO_INCREMENT,
    title      VARCHAR(255) NOT NULL,
    menu       INT          NOT NULL,
    restaurant INT          NOT NULL,
    FOREIGN KEY (menu, restaurant) REFERENCES Menu (id, restaurant)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id, menu, restaurant)
);

CREATE TABLE IF NOT EXISTS Product
(
    id          INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    price       FLOAT(10, 2) NOT NULL CHECK (price > 0),
    restaurant  INT          NOT NULL,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    PRIMARY KEY (id, restaurant)
);

CREATE TABLE IF NOT EXISTS MenuCategoryContent
(
    category   INT NOT NULL,
    menu       INT NOT NULL,
    product    INT NOT NULL,
    restaurant INT NOT NULL,
    FOREIGN KEY (category, menu) REFERENCES MenuCategory (id, menu)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (product, restaurant) REFERENCES Product (id, restaurant)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (category, menu, product, restaurant)
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
    product    INT          NOT NULL,
    restaurant INT          NOT NULL,
    allergen   VARCHAR(100) NOT NULL,
    FOREIGN KEY (product, restaurant) REFERENCES Product (id, restaurant)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (allergen) REFERENCES Allergen (name)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (product, restaurant, allergen)
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
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS UserPhone
(
    user  INT NOT NULL,
    phone VARCHAR(14) PRIMARY KEY,
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Cart
(
    user       INT NOT NULL,
    restaurant INT NOT NULL,
    product    INT NOT NULL,
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (restaurant, product) REFERENCES Product (restaurant, id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user, restaurant, product)
);

CREATE TABLE IF NOT EXISTS LoginSession
(
    token      VARCHAR(60) PRIMARY KEY,
    agent      VARCHAR(255) NOT NULL,
    ip         VARCHAR(15)  NOT NULL,
    creation   DATETIME     NOT NULL DEFAULT NOW(),
    last_usage DATETIME     NOT NULL DEFAULT NOW(),
    user       INT          NOT NULL,
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Review
(
    creation   DATETIME NOT NULL,
    mark       INT      NOT NULL CHECK (mark > 0 AND mark < 6),
    title      VARCHAR(255),
    text       VARCHAR(255),
    restaurant INT,
    user       INT,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user, restaurant)
);

CREATE TABLE IF NOT EXISTS OrdersManager
(
    begin_date DATETIME NOT NULL,
    end_date   DATETIME,
    user       INT      NOT NULL,
    restaurant INT,
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (restaurant) REFERENCES Restaurant (id)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    PRIMARY KEY (user, restaurant, begin_date)
);

CREATE TABLE IF NOT EXISTS RiderService
(
    user            INT          NOT NULL,
    begin_time      DATETIME     NOT NULL,
    begin_latitude  FLOAT(10, 6) NOT NULL,
    begin_longitude FLOAT(10, 6) NOT NULL,
    end_time        DATETIME,
    end_latitude    FLOAT(10, 6),
    end_longitude   FLOAT(10, 6),
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user, begin_time)
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
    address_latitude     FLOAT(10, 6) NOT NULL,
    address_longitude    FLOAT(10, 6) NOT NULL,
    user                 INT,
    rider                INT,
    rider_service        DATETIME,
    FOREIGN KEY (status) REFERENCES OrderStatus (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (user) REFERENCES User (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (rider, rider_service) REFERENCES RiderService (user, begin_time)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS OrderContent
(
    product          INT NOT NULL,
    restaurant       INT NOT NULL,
    restaurant_order INT,
    quantity         INT NOT NULL CHECK (quantity > 0 AND quantity < 10),
    FOREIGN KEY (product, restaurant) REFERENCES Product (id, restaurant)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (restaurant_order) REFERENCES RestaurantOrder (id)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    PRIMARY KEY (product, restaurant, restaurant_order)
);

-- Views on some generalizations
CREATE VIEW IF NOT EXISTS RestaurantRating AS
SELECT restaurant, user, creation, mark
FROM Review
WHERE title IS NULL
  AND text IS NULL;

CREATE VIEW IF NOT EXISTS RestaurantReview AS
SELECT *
FROM Review
WHERE title IS NOT NULL
  AND text IS NOT NULL;

CREATE VIEW IF NOT EXISTS CurrentOrdersManager AS
SELECT begin_date, user, restaurant
FROM OrdersManager
WHERE end_date IS NULL;

CREATE VIEW IF NOT EXISTS OldOrdersManager AS
SELECT *
FROM OrdersManager
WHERE end_date IS NOT NULL;

CREATE VIEW IF NOT EXISTS CurrentMenu AS
SELECT id, title, restaurant
FROM Menu
WHERE published = TRUE;

CREATE VIEW IF NOT EXISTS DraftMenu AS
SELECT id, title, restaurant
FROM Menu
WHERE published = FALSE;


-- Triggers
