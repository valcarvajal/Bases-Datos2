-- CREACIÓN Y ACTUALIZACIÓN DEL MODELO MULTIDIMENSIONAL --

----- DIMENSIONES -----
-- Creación de la dimensión 'Film'
CREATE TABLE film_dim (
    id INT PRIMARY KEY,
    name VARCHAR(60),
    category VARCHAR(25),
    actor VARCHAR(40)
);

-- Creación de la dimensión 'address'
CREATE TABLE address_dim (
    id INT PRIMARY KEY,
    country VARCHAR(20),
    city VARCHAR(20)
);

-- Creación de la dimensión 'Date'
CREATE TABLE date_dim (
    id INT PRIMARY KEY,
    year INT,
    month INT,
    day INT
);

-- Creación de la dimensión 'Store'
CREATE TABLE store_dim (
    id INT PRIMARY KEY
);


----- TABLA DE HECHOS -----
-- Creación de la tabla de hechos 'rental_fact'
CREATE TABLE rental_ft (
    film_id INT,
    address_id INT,
    date_id INT,
    store_id INT,
    total_amount DECIMAL(8,2),
    rental_amount INT,
    FOREIGN KEY (film_id) REFERENCES film_dim (id),
    FOREIGN KEY (address_id) REFERENCES address_dim (id),
    FOREIGN KEY (date_id) REFERENCES date_dim (id),
    FOREIGN KEY (store_id) REFERENCES store_dim (id)
);


----- FUNCIONES -----
-- ACTUALIZAR DIMENSIÓN DE PELÍCULAS --
/*
Descripción: Esta función actualiza la tabla de dimensión de películas ('film_dim') en función de los datos de la tabla 'film'. Recorre todas las películas, recopila sus categorías y actores, y luego inserta esta información en la tabla de dimensión.

Entrada: No requiere entrada explícita.

Salida: No devuelve ningún valor explícito.

Bloques Relevantes:
- DELETE FROM: Elimina los datos existentes en la tabla 'film_dim' para evitar duplicados.
- FOR loop: Recorre todas las películas en la tabla 'film'.
- SELECT INTO: Recupera nombres de actores y categorías asociadas a cada película.
- INSERT INTO: Inserta los datos recopilados en la tabla 'film_dim'.
- RAISE NOTICE: Emite un mensaje de éxito una vez que se completa la actualización.
*/
CREATE OR REPLACE FUNCTION update_film_dim() RETURNS VOID AS $$
DECLARE
    film_record RECORD;
    actor_name VARCHAR(50);
BEGIN
    DELETE FROM film_dim;

    FOR film_record IN
        SELECT f.*, array_agg(c.name) AS categories
        FROM film f
        LEFT JOIN film_category fc ON f.film_id = fc.film_id
        LEFT JOIN category c ON fc.category_id = c.category_id
        GROUP BY f.film_id
    LOOP
        -- Recupera nombres de los actores y los concatena
        actor_name := '';

        FOR actor_name IN
            SELECT CONCAT(first_name, ' ', last_name)
            FROM actor a
            JOIN film_actor fa ON a.actor_id = fa.actor_id
            WHERE fa.film_id = film_record.film_id
        LOOP
            actor_name := actor_name || ', ' || actor_name;
        END LOOP;

        actor_name := TRIM(TRAILING ', ' FROM actor_name); -- Elimina la coma y el espacio extra al final

        -- Inserta los datos en film_dim
        INSERT INTO film_dim (id, name, category, actor)
        VALUES (film_record.film_id, film_record.title, film_record.categories, actor_name);
    END LOOP;

    RAISE NOTICE 'Dimension table updated successfully.';
END;
$$ LANGUAGE plpgsql;


-- ACTUALIZAR DIMENSIÓN DE DIRECCIONES --
/*
Descripción: Esta función actualiza la tabla de dimensión de direcciones ('address_dim') utilizando los datos de las tablas 'City' y 'Country'. Trunca la tabla existente antes de insertar los nuevos datos.

Entrada: No requiere entrada explícita.

Salida: No devuelve ningún valor explícito.

Bloques Relevantes:
- TRUNCATE TABLE: Limpia la tabla 'address_dim' antes de insertar nuevos datos.
- INSERT INTO: Inserta datos seleccionados de las tablas 'City' y 'Country' en 'address_dim'.
- RAISE NOTICE: Emite un mensaje de éxito una vez que se completa la actualización.
*/
CREATE OR REPLACE PROCEDURE update_address_dim() AS
$$
BEGIN
    TRUNCATE TABLE address_dim CASCADE;
    INSERT INTO address_dim (id, country, city)
    SELECT city_id, country, city
    FROM City INNER JOIN Country
    ON Country.country_id = City.country_id;
    
    RAISE NOTICE 'Dimension table updated successfully.';
END;
$$ LANGUAGE plpgsql;


-- ACTUALIZAR DIMENSIÓN DE FECHAS --
/*
Descripción: Esta función actualiza la tabla de dimensión de fechas ('date_dim') utilizando los datos de la tabla 'rental'. Trunca la tabla existente antes de insertar los nuevos datos.

Entrada: No requiere entrada explícita.

Salida: No devuelve ningún valor explícito.

Bloques Relevantes:
- TRUNCATE TABLE: Limpia la tabla 'date_dim' antes de insertar nuevos datos.
- INSERT INTO: Inserta datos seleccionados de la tabla 'rental' en 'date_dim', extrayendo el año, mes y día de la fecha de alquiler.
- RAISE NOTICE: Emite un mensaje de éxito una vez que se completa la actualización.
*/
CREATE OR REPLACE FUNCTION update_date_dim() RETURNS VOID AS $$
DECLARE
    fecha_rental DATE;
BEGIN
    TRUNCATE TABLE date_dim CASCADE;
    INSERT INTO date_dim (id, year, month, day)
    SELECT
    r.rental_id,
    EXTRACT(YEAR FROM r.rental_date),
    EXTRACT(MONTH FROM r.rental_date),
    EXTRACT(DAY FROM r.rental_date)
    FROM rental r;
    
    RAISE NOTICE 'Dimension table updated successfully.';
END;
$$ LANGUAGE plpgsql;


-- ACTUALIZAR DIMENSIÓN DE TIENDAS --
/*
Descripción: Esta función actualiza la tabla de dimensión de tiendas ('store_dim') utilizando los datos de la tabla 'store'. Trunca la tabla existente antes de insertar los nuevos datos.

Entrada: No requiere entrada explícita.

Salida: No devuelve ningún valor explícito.

Bloques Relevantes:
- TRUNCATE TABLE: Limpia la tabla 'store_dim' antes de insertar nuevos datos.
- INSERT INTO: Inserta datos seleccionados de la tabla 'store' en 'store_dim'.
- RAISE NOTICE: Emite un mensaje de éxito una vez que se completa la actualización.
*/
CREATE OR REPLACE PROCEDURE update_store_dim() AS $$
BEGIN
	TRUNCATE TABLE store_dim CASCADE;
	INSERT INTO store_dim (id) SELECT store_id FROM store;

	RAISE NOTICE 'Dimension table updated successfully.';
END;
$$ LANGUAGE plpgsql;



-- ACTUALIZAR TABLA DE HECHOS DE ALQUILERES --
/*
Descripción: Esta función actualiza la tabla de hechos de alquileres ('rental_ft') utilizando datos de varias tablas como 'payment', 'rental', 'inventory', 'film', 'customer', 'address', 'staff', y 'store'. Calcula el número total de alquileres y el monto total de ingresos por alquiler, agrupados por película, dirección, fecha y tienda.

Entrada: No requiere entrada explícita.

Salida: No devuelve ningún valor explícito.

Bloques Relevantes:
- INSERT INTO: Inserta datos calculados en 'rental_ft' utilizando múltiples JOIN y funciones de agregación.
- RAISE NOTICE: Emite un mensaje de éxito una vez que se completa la actualización.
*/
CREATE OR REPLACE PROCEDURE update_rental_ft() AS $$
BEGIN
    INSERT INTO rental_ft (film_id, address_id, date_id, store_id, rental_amount, total_amount)
    SELECT df.id, da.id, dr.id, ds.id, COUNT(p), SUM(p.amount)
    FROM payment p
    ---------------------------------------------------------
    JOIN rental r ON r.rental_id = p.rental_id
    JOIN date_dim dr ON dr.id = r.rental_id
    ---------------------------------------------------------
    JOIN inventory i ON i.inventory_id = r.inventory_id
    JOIN film f ON f.film_id = i.film_id
    JOIN film_dim df ON df.id = f.film_id
    ---------------------------------------------------------
    JOIN customer cus ON cus.customer_id = r.customer_id
    JOIN address a ON a.address_id = cus.address_id
    JOIN address_dim da ON da.id = a.address_id
    ---------------------------------------------------------
    JOIN staff stf ON stf.staff_id = p.staff_id
    JOIN store s ON s.store_id = stf.store_id
    JOIN store_dim ds ON ds.id = s.store_id
    ---------------------------------------------------------
    GROUP BY df.id, da.id, dr.id, ds.id, p.amount;

    RAISE NOTICE 'Fact table updated successfully.';
END;
$$ LANGUAGE plpgsql;

