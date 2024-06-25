-- CREACIÓN DE LA BASE DE DATOS --

/*
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS rental;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS film_category;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS film_actor;
DROP TABLE IF EXISTS film;
DROP TABLE IF EXISTS language;
DROP TABLE IF EXISTS actor;
*/

/******************************** CREATE ********************************/
-- Creación de la tabla 'actor'
CREATE TABLE actor (
    actor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creación de la tabla 'language'
CREATE TABLE language (
    language_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creación de la tabla 'film'
CREATE TABLE film (
    film_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(60) NOT NULL,
    description VARCHAR(255),
    release_year INT,
    language_id INT,
    rental_duration INT,
    rental_rate DECIMAL(5,2),
    length INT,
    replacement_cost DECIMAL(5,2),
    rating VARCHAR(5) CHECK (rating IN ('G', 'PG', 'PG-13', 'R', 'NC-17')),
		-- General Audience, Parental Guidance Suggested, Parents Strongly Cautioned, Restricted and No children under 17 admitted.
    special_features VARCHAR(255),
    fulltext VARCHAR(255),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (language_id) REFERENCES language (language_id)
);

-- Creación de la tabla 'film_actor'
CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor (actor_id),
    FOREIGN KEY (film_id) REFERENCES film (film_id)
);

-- Creación de la tabla 'category'
CREATE TABLE category (
    category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creación de la tabla 'film_category'
CREATE TABLE film_category (
    film_id INT,
    category_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (film_id, category_id),
    FOREIGN KEY (film_id) REFERENCES film (film_id),
    FOREIGN KEY (category_id) REFERENCES category (category_id)
);

-- Creación de la tabla 'country'
CREATE TABLE country (
    country_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country VARCHAR(20) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creación de la tabla 'city'
CREATE TABLE city (
    city_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES country (country_id)
);

-- Creación de la tabla 'address'
CREATE TABLE address (
    address_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20) NOT NULL,
    city_id INT NOT NULL,
    postal_code VARCHAR(5),
    phone VARCHAR(8) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES city (city_id)
);

-- Creación de la tabla 'store'
CREATE TABLE store (
    store_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES address (address_id)
);

-- Creación de la tabla 'staff'
CREATE TABLE staff (
    staff_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_id INT NOT NULL,
    email VARCHAR(50),
    store_id INT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(40) NOT NULL,
	picture VARCHAR(500), -- direccion de imagen (url)
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES address (address_id),
    FOREIGN KEY (store_id) REFERENCES store (store_id)
);

-- Creación de la tabla 'inventory'
CREATE TABLE inventory (
    inventory_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film_id INT,
    store_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (film_id) REFERENCES film (film_id),
    FOREIGN KEY (store_id) REFERENCES store (store_id)
);

-- Creación de la tabla 'customer'
CREATE TABLE customer (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    store_id INT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(50),
    address_id INT NOT NULL,
    activebool BOOLEAN NOT NULL DEFAULT true,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (store_id) REFERENCES store (store_id),
    FOREIGN KEY (address_id) REFERENCES address (address_id)
);

-- Creación de la tabla 'rental'
CREATE TABLE rental (
    rental_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rental_date DATE NOT NULL,
    inventory_id INT,
    customer_id INT,
    return_date DATE,
    staff_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

-- Creación de la tabla 'payment'
CREATE TABLE payment (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT,
    staff_id INT,
    rental_id INT,
    amount DECIMAL(8,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id),
    FOREIGN KEY (rental_id) REFERENCES rental (rental_id)
);



/******************************** INSERT ********************************/
-- Inserciones para la tabla 'actor'
INSERT INTO actor (first_name, last_name)
VALUES
('Tom', 'Hanks'),
('Brad', 'Pitt'),
('Leonardo', 'DiCaprio'), 
('Matt', 'Damon'),
('Scarlett', 'Johansson'),
('Jennifer', 'Lawrence'),
('Robert', 'Downey Jr.'),
('Johnny', 'Depp'),
('Will', 'Smith'), 
('Meryl', 'Streep'),
('Emma', 'Stone'),
('Chris', 'Hemsworth'),
('Natalie', 'Portman'),
('Denzel', 'Washington'),
('Angelina', 'Jolie'),
('Ryan', 'Reynolds'),
('Samuel', 'L. Jackson'),
('Natalie', 'Dormer'),
('Idris', 'Elba'),
('Gal', 'Gadot'),
('Jason', 'Statham'),
('Emily', 'Blunt'),
('Chris', 'Pratt'),
('Tom', 'Hardy'),
('Emma', 'Watson'),
('Vin', 'Diesel'),
('Margot', 'Robbie'),
('Keanu', 'Reeves'),
('Zoe', 'Saldana'),
('Margot', 'Robbie'),
('Idris', 'Elba'),
('Emilia', 'Clarke'),
('Jennifer', 'Garner'),
('Michael', 'Fassbender'),
('Sophie', 'Turner'),
('Alicia', 'Vikander');

-- Inserciones para la tabla 'language'
INSERT INTO language (name)
VALUES
('English'),
('French'),
('Spanish'),
('German');

-- Inserciones para la tabla 'film'
INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, fulltext) 
VALUES 
('Forrest Gump', 'A man with a low IQ has accomplished great things in his life and been present during significant historic events—in each case, far exceeding what anyone imagined he could do.', 1994, 1, 7, 3.99, 142, 19.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'Forrest Gump, while not intelligent, has accidentally been present at many historic moments, but his true love, Jenny Curran, eludes him.'),
('Inception', 'A thief who enters the dreams of others to steal their secrets gets the chance to redeem himself when he is given the inverse task: to plant an idea in someones mind.', 2010, 1, 5, 2.99, 148, 20.99, 'PG-13', 'Behind the Scenes|Alternate Ending', 'A thief who enters the dreams of others to steal their secrets gets the chance to redeem himself when he is given the inverse task: to plant an idea in someones mind.'),
('Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 1997, 1, 7, 3.99, 195, 19.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.'),
('The Bourne Identity', 'A man is picked up by a fishing boat, bullet-riddled and suffering from amnesia, before racing to elude assassins and regain his memory.', 2002, 1, 5, 2.99, 119, 18.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'A man is picked up by a fishing boat, bullet-riddled and suffering from amnesia, before racing to elude assassins and regain his memory.'),
('Lost in Translation', 'A faded movie star and a neglected young woman form an unlikely bond after crossing paths in Tokyo.', 2003, 2, 7, 3.99, 102, 17.99, 'R', 'Behind the Scenes|Commentaries', 'A faded movie star and a neglected young woman form an unlikely bond after crossing paths in Tokyo.'),
('The Matrix', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.', 1999, 1, 7, 3.99, 136, 20.99, 'R', 'Behind the Scenes|Alternate Ending', 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.'),
('The Shawshank Redemption', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 1994, 1, 7, 3.99, 142, 19.99, 'R', 'Deleted Scenes|Behind the Scenes', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.'),
('The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 1972, 1, 7, 3.99, 175, 24.99, 'R', 'Deleted Scenes|Behind the Scenes', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.'),
('The Dark Knight', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', 2008, 1, 7, 3.99, 152, 22.99, 'PG-13', 'Behind the Scenes|Alternate Ending', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.'),
('Pulp Fiction', 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', 1994, 1, 7, 3.99, 154, 20.99, 'R', 'Deleted Scenes|Behind the Scenes', 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.'),
('Harry Potter and the Sorcerer''s Stone', 'An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world.', 2001, 1, 7, 3.99, 152, 19.99, 'PG', 'Deleted Scenes|Behind the Scenes', 'An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world.'),
('Harry Potter and the Chamber of Secrets', 'An ancient prophecy seems to be coming true when a mysterious presence begins stalking the corridors of a school of magic and leaving its victims paralyzed.', 2002, 1, 7, 3.99, 161, 19.99, 'PG', 'Deleted Scenes|Behind the Scenes', 'An ancient prophecy seems to be coming true when a mysterious presence begins stalking the corridors of a school of magic and leaving its victims paralyzed.'),
('Harry Potter and the Prisoner of Azkaban', 'It''s Harry''s third year at Hogwarts; not only does he have a new "Defense Against the Dark Arts" teacher, but there is also trouble brewing. Convicted murderer Sirius Black has escaped the Wizards'' Prison and is coming after Harry.', 2004, 1, 7, 3.99, 142, 19.99, 'PG', 'Deleted Scenes|Behind the Scenes', 'It''s Harry''s third year at Hogwarts; not only does he have a new "Defense Against the Dark Arts" teacher, but there is also trouble brewing. Convicted murderer Sirius Black has escaped the Wizards'' Prison and is coming after Harry.'),
('Harry Potter and the Goblet of Fire', 'Harry finds himself mysteriously selected as an under-aged competitor in a dangerous tournament between three schools of magic.', 2005, 1, 7, 3.99, 157, 19.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'Harry finds himself mysteriously selected as an under-aged competitor in a dangerous tournament between three schools of magic.'),
('Harry Potter and the Order of the Phoenix', 'With their warning about Lord Voldemort''s return scoffed at, Harry and Dumbledore are targeted by the Wizard authorities as an authoritarian bureaucrat slowly seizes power at Hogwarts.', 2007, 1, 7, 3.99, 138, 19.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'With their warning about Lord Voldemort''s return scoffed at, Harry and Dumbledore are targeted by the Wizard authorities as an authoritarian bureaucrat slowly seizes power at Hogwarts.'),
('Harry Potter and the Half-Blood Prince', 'As Harry Potter begins his sixth year at Hogwarts, he discovers an old book marked as "the property of the Half-Blood Prince" and begins to learn more about Lord Voldemort''s dark past.', 2009, 1, 7, 3.99, 153, 19.99, 'PG', 'Deleted Scenes|Behind the Scenes', 'As Harry Potter begins his sixth year at Hogwarts, he discovers an old book marked as "the property of the Half-Blood Prince" and begins to learn more about Lord Voldemort''s dark past.'),
('Harry Potter and the Deathly Hallows – Part 1', 'As Harry, Ron, and Hermione race against time and evil to destroy the Horcruxes, they uncover the existence of the three most powerful objects in the wizarding world: the Deathly Hallows.', 2010, 1, 7, 3.99, 146, 19.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'As Harry, Ron, and Hermione race against time and evil to destroy the Horcruxes, they uncover the existence of the three most powerful objects in the wizarding world: the Deathly Hallows.'),
('Harry Potter and the Deathly Hallows – Part 2', 'Harry, Ron, and Hermione search for Voldemort''s remaining Horcruxes in their effort to destroy the Dark Lord as the final battle rages on at Hogwarts.', 2011, 1, 7, 3.99, 130, 19.99, 'PG-13', 'Deleted Scenes|Behind the Scenes', 'Harry, Ron, and Hermione search for Voldemort''s remaining Horcruxes in their effort to destroy the Dark Lord as the final battle rages on at Hogwarts.');

-- Inserciones para la tabla 'film_actor'
INSERT INTO film_actor (actor_id, film_id)
VALUES
(1, 2), (1, 4), (1, 5), (1, 8), (1, 14),
(2, 1), (2, 2), (2, 6), (2, 7), (2, 16),
(3, 3), (3, 5), (3, 8), (3, 11), (3, 12),
(4, 1), (4, 2), (4, 3), (4, 6), (4, 10),
(5, 3), (5, 4), (5, 7), (5, 9), (5, 13),
(6, 1), (6, 3), (6, 4), (6, 6), (6, 10),
(7, 2), (7, 3), (7, 6), (7, 8), (7, 12),
(8, 3), (8, 4), (8, 5), (8, 7), (8, 14),
(9, 1), (9, 4), (9, 6), (9, 8), (9, 15),
(10, 2), (10, 3), (10, 5), (10, 9), (10, 16),
(11, 4), (11, 6), (11, 7), (11, 8), (11, 13),
(12, 1), (12, 2), (12, 4), (12, 5), (12, 10),
(13, 2), (13, 5), (13, 6), (13, 9), (13, 15),
(14, 1), (14, 3), (14, 4), (14, 7), (14, 11),
(15, 3), (15, 6), (15, 8), (15, 10), (15, 13),
(16, 2), (16, 4), (16, 5), (16, 7), (16, 12),
(17, 1), (17, 3), (17, 5), (17, 8), (17, 14),
(18, 2), (18, 4), (18, 6), (18, 9), (18, 15),
(19, 1), (19, 3), (19, 7), (19, 10), (19, 11),
(20, 2), (20, 4), (20, 5), (20, 8), (20, 12),
(21, 1), (21, 3), (21, 6), (21, 9), (21, 13),
(22, 2), (22, 5), (22, 7), (22, 8), (22, 16),
(23, 1), (23, 3), (23, 5), (23, 6), (23, 11),
(24, 2), (24, 4), (24, 6), (24, 8), (24, 14),
(25, 3), (25, 5), (25, 7), (25, 9), (25, 15),
(26, 1), (26, 4), (26, 6), (26, 7), (26, 10),
(27, 2), (27, 5), (27, 7), (27, 9), (27, 13),
(28, 3), (28, 4), (28, 6), (28, 8), (28, 12),
(29, 1), (29, 3), (29, 5), (29, 7), (29, 11),
(30, 2), (30, 4), (30, 6), (30, 8), (30, 14),
(31, 1), (31, 2), (31, 5), (31, 7), (31, 10),
(32, 3), (32, 4), (32, 6), (32, 9), (32, 12),
(33, 1), (33, 2), (33, 4), (33, 7), (33, 13),
(34, 3), (34, 5), (34, 7), (34, 8), (34, 15),
(35, 1), (35, 3), (35, 6), (35, 9), (35, 14),
(36, 2), (36, 4), (36, 5), (36, 7), (36, 15);

-- Inserciones para la tabla 'category'
INSERT INTO category (name)
VALUES
('Drama'),
('Action'),
('Romance'),
('Thriller');

-- Inserciones para la tabla 'film_category'
INSERT INTO film_category (film_id, category_id)
VALUES
(1, 1), (1, 2),
(2, 1), (2, 2),
(3, 1), (3, 2),
(4, 1), (4, 2),
(5, 3), (5, 4),
(6, 3), (6, 4),
(7, 3), (7, 4),
(8, 3), (8, 4),
(9, 3), (9, 4),
(10, 3), (10, 4),
(11, 2), (11, 3),
(12, 2), (12, 1),
(13, 2), (13, 3),
(14, 2), (14, 1),
(15, 4), (15, 3),
(16, 4), (16, 2),
(17, 4), (17, 1),
(18, 4), (18, 2);

-- Inserciones para la tabla 'country'
INSERT INTO country (country) VALUES 
('United States'),
('United Kingdom'),
('Canada'),
('Australia'),
('Germany'),
('France'),
('Spain'),
('Italy'),
('Japan'),
('China');

-- Inserciones para la tabla 'city'
INSERT INTO city (city, country_id) VALUES 
('New York', 1),
('Los Angeles', 1),
('London', 2),
('Manchester', 2),
('Toronto', 3),
('Vancouver', 3),
('Sydney', 4),
('Melbourne', 4),
('Berlin', 5),
('Munich', 5),
('Paris', 6),
('Marseille', 6),
('Madrid', 7),
('Barcelona', 7),
('Rome', 8),
('Milan', 8),
('Tokyo', 9),
('Osaka', 9),
('Shanghai', 10),
('Beijing', 10);

-- Inserciones para la tabla 'address'
INSERT INTO address (address, district, city_id, phone) VALUES 
('123 Main Street', 'Downtown', 1, '14567890'),
('456 Oak Avenue', 'Midtown', 2, '47890123'),
('789 Elm Street', 'Uptown', 3, '70123456'),
('101 Maple Road', 'City Center', 4, '11121314'),
('222 Pine Street', 'Suburbia', 5, '23334444'),
('333 Cedar Avenue', 'Downtown', 6, '34445555'),
('444 Birch Road', 'Coastal', 7, '45556666'),
('555 Spruce Boulevard', 'City Center', 8, '56667777'),
('666 Willow Drive', 'Downtown', 9, '66778888'),
('777 Oakwood Lane', 'Suburbia', 10, '78889999'),
('888 Elm Avenue', 'City Center', 11, '89990000'),
('999 Maple Street', 'Uptown', 12, '90001111'),
('111 Pine Avenue', 'Downtown', 13, '12223333'),
('222 Cedar Road', 'Midtown', 14, '22234444'),
('333 Birch Boulevard', 'City Center', 15, '33345555'),
('444 Spruce Avenue', 'Uptown', 16, '44456666'),
('555 Willow Road', 'Downtown', 17, '55566777'),
('666 Oakwood Drive', 'Midtown', 18, '66638888'),
('999 Maple Street', 'Uptown', 19, '90001111'),
('777 Elm Lane', 'City Center', 20, '78889999');

-- Inserciones para la tabla 'store'
INSERT INTO store (address_id) VALUES (1), (2), (3), (4), (5);

-- Inserciones para la tabla 'staff'
INSERT INTO staff (first_name, last_name, address_id, store_id, email, username, password, picture) 
VALUES 
('John', 'Doe', 1, 1, 'john.doe@mr.com', 'johndoe', 'password123', 'https://example.com/johndoe.jpg'),
('Jane', 'Smith', 2, 2, 'jane.smith@mr.com', 'janesmith', 'password456', 'https://example.com/janesmith.jpg'),
('Emily', 'Watson', 3, 3, 'emily.watson@mr.com', 'emilywatson', 'password789', 'https://example.com/emilywatson.jpg'),
('Michael', 'Williams', 4, 4, 'michael.williams@mr.com', 'michaelwilliams', 'password1011', 'https://example.com/michaelwilliams.jpg'),
('Sarah', 'Johnson', 5, 1, 'sarah.johnson@mr.com', 'sarahjohnson', 'password567', 'https://example.com/sarahjohnson.jpg'),
('David', 'Brown', 1, 2, 'david.brown@mr.com', 'davidbrown', 'password890', 'https://example.com/davidbrown.jpg'),
('Emma', 'Martinez', 2, 3, 'emma.martinez@mr.com', 'emmartinez', 'password1112', 'https://example.com/emmamartinez.jpg'),
('Christopher', 'Anderson', 3, 4, 'christopher.anderson@mr.com', 'chrisanderson', 'password1314', 'https://example.com/chrisanderson.jpg'),
('Daniel', 'Taylor', 4, 1, 'daniel.taylor@mr.com', 'danieltaylor', 'password1516', 'https://example.com/danieltaylor.jpg'),
('Olivia', 'Wilson', 5, 2, 'olivia.wilson@mr.com', 'oliviawilson', 'password1718', 'https://example.com/oliviawilson.jpg');

-- Inserciones actualizadas para la tabla 'inventory'
INSERT INTO inventory (film_id, store_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5),
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5),
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5),
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5),
(11, 1), (11, 2), (11, 3), (11, 4), (11, 5),
(12, 1), (12, 2), (12, 3), (12, 4), (12, 5),
(13, 1), (13, 2), (13, 3), (13, 4), (13, 5),
(14, 1), (14, 2), (14, 3), (14, 4), (14, 5),
(15, 1), (15, 2), (15, 3), (15, 4), (15, 5),
(16, 1), (16, 2), (16, 3), (16, 4), (16, 5),
(17, 1), (17, 2), (17, 3), (17, 4), (17, 5),
(18, 1), (18, 2), (18, 3), (18, 4), (18, 5);

-- Inserciones para la tabla 'customer'
INSERT INTO customer (store_id, first_name, last_name, email, address_id) 
VALUES 
(1, 'Michael', 'Johnson', 'michael.johnson@gmail.com', 1),
(2, 'Emily', 'Brown', 'emily.brown@gmail.com', 2),
(3, 'Sophia', 'Rossi', 'sophia.rossi@gmail.com', 5),
(4, 'Yuki', 'Tanaka', 'yuki.tanaka@gmail.com', 4),
(5, 'Ethan', 'Lopez', 'ethan.lopez@gmail.com', 5),
(1, 'Daniel', 'Lee', 'daniel.lee@gmail.com', 3),
(2, 'Isabella', 'Davis', 'isabella.davis@gmail.com', 1),
(3, 'Liam', 'Martinez', 'liam.martinez@gmail.com', 2),
(4, 'Olivia', 'Garcia', 'olivia.garcia@gmail.com', 3),
(5, 'Ava', 'Hernandez', 'ava.hernandez@gmail.com', 4),
(1, 'Emma', 'Taylor', 'emma.taylor@gmail.com', 1),
(2, 'James', 'Wilson', 'james.wilson@gmail.com', 2),
(3, 'Mia', 'Anderson', 'mia.anderson@gmail.com', 3),
(4, 'Noah', 'Thomas', 'noah.thomas@gmail.com', 4),
(5, 'Sophia', 'White', 'sophia.white@gmail.com', 5),
(1, 'Alexander', 'Martinez', 'alexander.martinez@gmail.com', 1),
(2, 'Charlotte', 'Brown', 'charlotte.brown@gmail.com', 2),
(3, 'William', 'Lopez', 'william.lopez@gmail.com', 3),
(4, 'Amelia', 'Garcia', 'amelia.garcia@gmail.com', 4),
(5, 'Benjamin', 'Hernandez', 'benjamin.hernandez@gmail.com', 5);

-- Inserciones para la tabla 'rental'
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES 
('2024-01-21 08:06:00', 1, 1, '2024-05-03 10:00:00', 1),
('2024-02-20 09:10:00', 2, 2, '2024-05-04 11:00:00', 2),
('2024-03-29 10:15:00', 3, 20, '2024-05-05 12:00:00', 3),
('2024-04-30 11:30:00', 4, 7, '2024-05-06 13:00:00', 4),
('2024-05-09 12:06:00', 5, 6, '2024-05-07 14:00:00', 5),
('2023-06-04 13:15:00', 6, 6, '2024-05-08 15:00:00', 6),
('2023-07-12 14:10:00', 7, 7, '2024-05-09 16:00:00', 7),
('2023-08-14 15:00:00', 8, 7, '2024-05-10 17:00:00', 8),
('2023-09-30 16:15:00', 9, 7, '2024-05-11 18:00:00', 9),
('2023-10-16 17:06:00', 10, 13, '2024-05-12 19:00:00', 10),
('2023-11-18 18:22:00', 11, 11, '2024-05-13 20:00:00', 1),
('2023-12-01 19:26:00', 12, 12, '2024-05-14 21:00:00', 2),
('2024-01-03 20:00:00', 13, 13, '2024-05-15 22:00:00', 3),
('2024-02-06 21:10:00', 14, 14, '2024-05-16 23:00:00', 4),
('2024-03-05 22:22:00', 15, 15, '2024-05-17 08:00:00', 5),
('2024-04-22 23:00:00', 16, 16, '2024-05-18 09:00:00', 6),
('2023-05-28 08:30:00', 17, 17, '2024-05-19 10:00:00', 7),
('2023-06-27 09:06:00', 18, 18, '2024-05-20 11:00:00', 8),
('2023-07-19 10:26:00', 19, 19, '2024-05-21 12:00:00', 9),
('2023-08-07 11:00:00', 20, 20, '2024-05-22 13:00:00', 10),
('2023-09-23 08:22:00', 21, 1, '2024-05-03 10:00:00', 1),
('2023-10-22 09:00:00', 22, 2, '2024-05-04 11:00:00', 2),
('2023-11-21 10:06:00', 23, 3, '2024-05-05 12:00:00', 3),
('2023-12-30 11:26:00', 24, 4, '2024-05-06 13:00:00', 4),
('2024-01-05 12:30:00', 25, 5, '2024-05-07 14:00:00', 5),
('2024-02-06 13:15:00', 26, 6, '2024-05-08 15:00:00', 6),
('2024-03-17 14:22:00', 27, 7, '2024-05-09 16:00:00', 7),
('2024-04-18 15:00:00', 28, 8, '2024-05-10 17:00:00', 8),
('2023-05-31 16:15:00', 29, 9, '2024-05-11 18:00:00', 9),
('2023-06-20 17:06:00', 30, 10, '2024-05-12 19:00:00', 10),
('2023-07-16 18:00:00', 31, 11, '2024-05-13 20:00:00', 1),
('2023-08-02 19:30:00', 32, 12, '2024-05-14 21:00:00', 2),
('2023-09-01 20:26:00', 33, 13, '2024-05-15 22:00:00', 3),
('2023-10-08 21:10:00', 34, 14, '2024-05-16 23:00:00', 4),
('2023-11-04 22:00:00', 35, 15, '2024-05-17 08:00:00', 5),
('2023-12-27 23:26:00', 36, 16, '2024-05-18 09:00:00', 6),
('2023-01-26 08:10:00', 37, 17, '2024-05-19 10:00:00', 7),
('2023-02-28 09:22:00', 38, 18, '2024-05-20 11:00:00', 8),
('2023-03-19 10:06:00', 39, 19, '2024-05-21 12:00:00', 9),
('2023-04-01 11:15:00', 40, 20, '2024-05-22 13:00:00', 10),
('2024-05-23 08:06:00', 21, 1, '2024-05-24 10:00:00', 1),
('2024-05-24 09:10:00', 22, 2, '2024-05-25 11:00:00', 2),
('2024-05-25 10:15:00', 23, 3, '2024-05-26 12:00:00', 3),
('2024-05-26 11:30:00', 24, 4, '2024-05-27 13:00:00', 4),
('2024-05-27 12:06:00', 25, 5, '2024-05-28 14:00:00', 5),
('2024-05-28 13:15:00', 26, 6, '2024-05-29 15:00:00', 6),
('2024-05-29 14:10:00', 27, 7, '2024-05-30 16:00:00', 7),
('2024-05-30 15:00:00', 28, 8, '2024-05-31 17:00:00', 8),
('2024-05-31 16:15:00', 29, 9, '2024-06-01 18:00:00', 9),
('2024-06-01 17:06:00', 30, 10, '2024-06-02 19:00:00', 10),
('2024-06-02 18:22:00', 31, 11, '2024-06-03 20:00:00', 1),
('2024-06-03 19:26:00', 32, 12, '2024-06-04 21:00:00', 2),
('2024-06-04 20:00:00', 33, 13, '2024-06-05 22:00:00', 3),
('2024-06-05 21:10:00', 34, 14, '2024-06-06 23:00:00', 4),
('2024-06-06 22:22:00', 35, 15, '2024-06-07 08:00:00', 5),
('2024-06-07 23:00:00', 36, 16, '2024-06-08 09:00:00', 6),
('2024-06-08 08:30:00', 37, 17, '2024-06-09 10:00:00', 7),
('2024-06-09 09:06:00', 38, 18, '2024-06-10 11:00:00', 8),
('2024-06-10 10:26:00', 39, 19, '2024-06-11 12:00:00', 9),
('2024-06-11 11:00:00', 40, 20, '2024-06-12 13:00:00', 10),
('2024-06-12 08:22:00', 21, 1, '2024-06-13 10:00:00', 1),
('2024-06-13 09:00:00', 22, 2, '2024-06-14 11:00:00', 2),
('2024-06-14 10:06:00', 23, 3, '2024-06-15 12:00:00', 3),
('2024-06-15 11:26:00', 24, 4, '2024-06-16 13:00:00', 4),
('2024-06-16 12:30:00', 25, 5, '2024-06-17 14:00:00', 5),
('2024-06-17 13:15:00', 26, 6, '2024-06-18 15:00:00', 6),
('2024-06-18 14:22:00', 27, 7, '2024-06-19 16:00:00', 7),
('2024-06-19 15:00:00', 28, 8, '2024-06-20 17:00:00', 8),
('2024-06-20 16:15:00', 29, 9, '2024-06-21 18:00:00', 9),
('2024-06-21 17:06:00', 30, 10, '2024-06-22 19:00:00', 10),
('2024-06-22 18:00:00', 31, 11, '2024-06-23 20:00:00', 1),
('2024-06-23 19:30:00', 32, 12, '2024-06-24 21:00:00', 2),
('2024-06-24 20:26:00', 33, 13, '2024-06-25 22:00:00', 3),
('2024-06-25 21:10:00', 34, 14, '2024-06-26 23:00:00', 4),
('2024-06-26 22:00:00', 35, 15, '2024-06-27 08:00:00', 5),
('2024-06-27 23:26:00', 36, 16, '2024-06-28 09:00:00', 6),
('2024-06-28 08:10:00', 37, 17, '2024-06-29 10:00:00', 7),
('2024-06-29 09:22:00', 38, 18, '2024-06-30 11:00:00', 8),
('2024-06-30 10:06:00', 39, 19, '2024-07-01 12:00:00', 9),
('2024-07-01 11:15:00', 40, 20, '2024-07-02 13:00:00', 10),
('2024-07-02 08:06:00', 41, 1, '2024-07-03 10:00:00', 1),
('2024-07-03 09:10:00', 42, 2, '2024-07-04 11:00:00', 2),
('2024-07-04 10:15:00', 43, 3, '2024-07-05 12:00:00', 3),
('2024-07-05 11:30:00', 44, 4, '2024-07-06 13:00:00', 4),
('2024-07-06 12:06:00', 45, 5, '2024-07-07 14:00:00', 5),
('2024-07-07 13:15:00', 46, 6, '2024-07-08 15:00:00', 6),
('2024-07-08 14:10:00', 47, 7, '2024-07-09 16:00:00', 7),
('2024-07-09 15:00:00', 48, 8, '2024-07-10 17:00:00', 8),
('2024-07-10 16:15:00', 49, 9, '2024-07-11 18:00:00', 9),
('2024-07-11 17:06:00', 50, 10, '2024-07-12 19:00:00', 10),
('2024-07-12 18:22:00', 51, 11, '2024-07-13 20:00:00', 1),
('2024-07-13 19:26:00', 52, 12, '2024-07-14 21:00:00', 2),
('2024-07-14 20:00:00', 53, 13, '2024-07-15 22:00:00', 3),
('2024-07-15 21:10:00', 54, 14, '2024-07-16 23:00:00', 4),
('2024-07-16 22:22:00', 55, 15, '2024-07-17 08:00:00', 5),
('2024-07-17 23:00:00', 56, 16, '2024-07-18 09:00:00', 6),
('2024-07-18 08:30:00', 57, 17, '2024-07-19 10:00:00', 7),
('2024-07-19 09:06:00', 58, 18, '2024-07-20 11:00:00', 8),
('2024-07-20 10:26:00', 59, 19, '2024-07-21 12:00:00', 9),
('2024-07-21 11:00:00', 60, 20, '2024-07-22 13:00:00', 10),
('2024-07-22 08:22:00', 61, 1, '2024-07-23 10:00:00', 1),
('2024-07-23 09:00:00', 62, 2, '2024-07-24 11:00:00', 2),
('2024-07-24 10:06:00', 63, 3, '2024-07-25 12:00:00', 3),
('2024-07-25 11:26:00', 64, 4, '2024-07-26 13:00:00', 4),
('2024-07-26 12:30:00', 65, 5, '2024-07-27 14:00:00', 5),
('2024-07-27 13:15:00', 66, 6, '2024-07-28 15:00:00', 6),
('2024-07-28 14:22:00', 67, 7, '2024-07-29 16:00:00', 7),
('2024-07-29 15:00:00', 68, 8, '2024-07-30 17:00:00', 8),
('2024-07-30 16:15:00', 69, 9, '2024-07-31 18:00:00', 9),
('2024-07-31 17:06:00', 70, 10, '2024-08-01 19:00:00', 10),
('2024-08-01 18:00:00', 71, 11, '2024-08-02 20:00:00', 1),
('2024-08-02 19:30:00', 72, 12, '2024-08-03 21:00:00', 2),
('2024-08-03 20:26:00', 73, 13, '2024-08-04 22:00:00', 3),
('2024-08-04 21:10:00', 74, 14, '2024-08-05 23:00:00', 4),
('2024-08-05 22:00:00', 75, 15, '2024-08-06 08:00:00', 5),
('2024-08-06 23:26:00', 76, 16, '2024-08-07 09:00:00', 6),
('2024-08-07 08:10:00', 77, 17, '2024-08-08 10:00:00', 7),
('2024-08-08 09:22:00', 78, 18, '2024-08-09 11:00:00', 8),
('2024-08-09 10:06:00', 79, 19, '2024-08-10 12:00:00', 9),
('2024-08-10 11:15:00', 80, 20, '2024-08-11 13:00:00', 10);


-- Inserciones para la tabla 'payment'
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
SELECT 
    rental.customer_id, 
    rental.staff_id, 
    rental.rental_id, 
    FLOOR(RANDOM() * (10000 - 5000 + 1) + 5000) AS amount, 
    rental.rental_date
FROM 
    rental;

select * from payment;

