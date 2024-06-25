-- FUNCIONES PARA ROLES/USUARIOS --

/******************************** FUNCIONES ********************************/
/* -- INSERTAR CLIENTE
Descripción: Esta función inserta un nuevo cliente en la tabla customer.

Parámetros:
store_id_in INT: El ID de la tienda a la que pertenece el cliente.
first_name_in VARCHAR(20): El primer nombre del cliente.
last_name_in VARCHAR(20): El apellido del cliente.
email_in VARCHAR(50): El correo electrónico del cliente.
address_id_in INT: El ID de la dirección del cliente.

Salida: Devuelve el ID del nuevo cliente insertado en la tabla customer.

Bloques Relevantes:
IF EXISTS: Verifica si el correo electrónico proporcionado ya está registrado en la tabla customer.
INSERT INTO: Inserta un nuevo registro en la tabla customer.
RAISE EXCEPTION: Lanza una excepción si el correo electrónico ya está registrado.
*/
CREATE OR REPLACE FUNCTION insert_customer(
    IN store_id_in INT,
	IN first_name_in VARCHAR(20),
    IN last_name_in VARCHAR(20),
    IN email_in VARCHAR(50),
    IN address_id_in INT
    
) 
RETURNS integer AS
$$
DECLARE
    new_id integer;
BEGIN
    IF EXISTS (SELECT 1 FROM customer WHERE email=email_in) THEN
        RAISE EXCEPTION 'Email % is already taken', email_in;
    END IF;

    INSERT INTO customer(store_id, first_name, last_name, email, address_id, activebool)
    VALUES (store_id_in, first_name_in, last_name_in, email_in, address_id_in, TRUE)
    RETURNING customer_id INTO new_id;

    RETURN new_id;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER;



/* -- REGISTRAR ALQUILER
Descripción: Esta función registra un nuevo alquiler en la tabla rental.

Parámetros:
inventory_id_in INT: El ID del inventario de la película alquilada.
customer_id_in INT: El ID del cliente que alquila la película.
staff_id_in INT: El ID del personal que procesa el alquiler.

Salida: Devuelve el ID del nuevo registro de alquiler insertado en la tabla rental.

Bloques Relevantes:
SELECT EXISTS: Verifica si la película está disponible en el inventario y si ya está alquilada.
RAISE EXCEPTION: Lanza una excepción si la película no está disponible en el inventario o si ya está alquilada.
INSERT INTO: Inserta un nuevo registro de alquiler en la tabla rental.
*/
CREATE OR REPLACE FUNCTION register_rental(
    IN inventory_id_in INT,
    IN customer_id_in INT,
    IN staff_id_in INT
) 
RETURNS INT AS
$$
DECLARE
    new_id INT;
    is_rented BOOLEAN;
    inventory_exists BOOLEAN;
BEGIN
    -- Verificar si la película existe en el inventario
    SELECT EXISTS (
        SELECT 1
        FROM inventory
        WHERE inventory_id = inventory_id_in
    ) INTO inventory_exists;
    
    -- Si la película no existe en el inventario, lanzar una excepción
    IF NOT inventory_exists THEN
        RAISE EXCEPTION 'La película asociada al inventory_id % no existe en el inventario', inventory_id_in;
    END IF;
	
    -- Verificar si la película asociada al inventory_id_in está actualmente alquilada
    SELECT EXISTS (
        SELECT 1 
        FROM rental 
        WHERE inventory_id = inventory_id_in 
        AND return_date IS NULL
    ) INTO is_rented;
    
    -- Si la película está alquilada, lanzar una excepción
    IF is_rented THEN
        RAISE EXCEPTION 'La película asociada al inventory_id % ya está alquilada', inventory_id_in;
    END IF;

    -- Insertar el nuevo registro de alquiler
    INSERT INTO rental(rental_date, inventory_id, customer_id, staff_id)
    VALUES(now(), inventory_id_in, customer_id_in, staff_id_in)
    RETURNING rental_id INTO new_id;
    
    RETURN new_id;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER;



/* -- REGISTRAR DEVOLUCION
Descripción: Esta función registra la devolución de una película actualizando la fecha de devolución en la tabla rental.

Parámetros:
rental_id_in INT: El ID del registro de alquiler que se está devolviendo.

Salida: No devuelve ningún valor.

Bloques Relevantes:
SELECT EXISTS: Verifica si el ID de alquiler proporcionado existe en la tabla rental.
UPDATE: Actualiza la fecha de devolución del registro de alquiler.
*/
CREATE OR REPLACE FUNCTION register_return(
    IN rental_id_in INT
) 
RETURNS VOID AS
$$
BEGIN
    -- Verificar si el ID de alquiler existe en la tabla rental
    IF NOT EXISTS (
        SELECT 1
        FROM rental
        WHERE rental_id = rental_id_in
    ) THEN
        RAISE EXCEPTION 'El ID de alquiler % no existe en la tabla rental', rental_id_in;
    END IF;

    -- Actualizar la fecha de devolución del alquiler
    UPDATE rental
    SET return_date = now()
    WHERE rental_id = rental_id_in;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER;


/* -- BUSCAR PELICULA
Descripción: Esta función busca una película por su ID y devuelve sus detalles.

Parámetros:
film_info VARCHAR: El ID de la película que se está buscando.

Salida: Devuelve los detalles de la película encontrada.

Bloques Relevantes:
RETURN QUERY: Ejecuta una consulta para buscar la película por su ID.
WHERE: Filtra la búsqueda por ID según la información proporcionada.
*/
CREATE OR REPLACE FUNCTION search_movie(
    IN film_info INT
)
RETURNS TABLE (
    film_id INT,
    title VARCHAR(60),
    description VARCHAR(255),
    release_year INT,
    language_id INT,
    rental_duration INT,
    rental_rate DECIMAL(5,2),
    length INT,
    replacement_cost DECIMAL(5,2),
    rating VARCHAR(5),
    special_features VARCHAR(255),
    fulltext VARCHAR(255)
) AS
$$
BEGIN
    RETURN QUERY
    SELECT 
        film.film_id,
        film.title,
        film.description,
        film.release_year,
        film.language_id,
        film.rental_duration,
        film.rental_rate,
        film.length,
        film.replacement_cost,
        film.rating,
        film.special_features,
        film.fulltext
    FROM 
        film
    WHERE 
        film.film_id = film_info;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER;


/******************************** PRUEBAS ********************************/
/*
SELECT * FROM CUSTOMER;
SELECT insert_customer (1, 'Julio Alberto', 'Fallas', 'julio.fallas@example.com', 1);

SELECT * FROM RENTAL;
SELECT register_rental (2, 1, 1);

SELECT register_return (2);

SELECT search_movie('1');
*/

