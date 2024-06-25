-- CREACIÓN DE ROLES Y USUARIOS DE LA BASE DE DATOS MovieRental --

/******************************** ROLES ********************************/
-- Creación del rol EMP
CREATE ROLE EMP;

-- Permisos
GRANT EXECUTE ON FUNCTION register_rental(INT, INT, INT) TO EMP;
GRANT EXECUTE ON FUNCTION register_return(INT) TO EMP;
GRANT EXECUTE ON FUNCTION search_movie(INT) TO EMP;

-- Revocación de permisos de lectura y escritura en la base de datos
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM EMP;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM EMP;


-- Creación del rol ADMIN
CREATE ROLE ADMIN IN ROLE EMP;

-- Permisos
GRANT EXECUTE ON FUNCTION insert_customer(INT, VARCHAR(20), VARCHAR(20), VARCHAR(50), INT) TO ADMIN;

-- Revocación de permisos de lectura y escritura en la base de datos
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM ADMIN;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM ADMIN;



/******************************** USUARIOS ********************************/
-- Creación del usuario video sin acceso de inicio de sesión
CREATE ROLE video NOLOGIN
	VALID UNTIL '2025-01-01';

-- Cambiar el propietario de todas las tablas
DO
$$
DECLARE
    name_table TEXT;
BEGIN
    FOR name_table IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
    LOOP
        EXECUTE format('ALTER TABLE public.%I OWNER TO video', name_table);
    END LOOP;
END;
$$;

-- Cambiar el propietario de todas las funciones
ALTER FUNCTION public.insert_customer OWNER TO video;
ALTER FUNCTION public.register_rental OWNER TO video;
ALTER FUNCTION public.register_return OWNER TO video;
ALTER FUNCTION public.search_movie OWNER TO video;

-- Creación del usuario empleado1
CREATE USER video1
	VALID UNTIL '2025-01-01';
GRANT video TO video1; -- Rol: video


-- Creación del usuario empleado1
CREATE USER empleado1
	WITH PASSWORD 'PassUserEmpleado1'
	VALID UNTIL '2025-01-01';
GRANT EMP TO empleado1; -- Rol: EMP



-- Creación del usuario administrador1
CREATE USER administrador1
	WITH PASSWORD 'PassUserAdministrador1'
	VALID UNTIL '2025-01-01';
GRANT ADMIN TO administrador1; -- Rol: ADMIN

