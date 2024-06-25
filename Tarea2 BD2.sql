-- Secuencias para los id de las tablas
CREATE SEQUENCE hospital_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE medico_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE esp_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;


-- Crear tablas
CREATE TABLE hospital (
    id int DEFAULT hospital_seq.NEXTVAL PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL,
    provincia VARCHAR2(10) NOT NULL
);

CREATE TABLE medico (
    id int DEFAULT medico_seq.NEXTVAL PRIMARY KEY,
    cedula VARCHAR2(11) NOT NULL,
    nombre VARCHAR2(10) NOT NULL,
    primer_apellido VARCHAR2(10) NOT NULL,
    direccion_provincia VARCHAR2(10) NOT NULL
);

CREATE TABLE especialidad (
    id int DEFAULT esp_seq.NEXTVAL PRIMARY KEY,
    nombre VARCHAR2(15) NOT NULL
);


-- Tablas de relaciones
CREATE TABLE medico_especialidad(
    medico_id INT,
    especialidad_id INT,
    PRIMARY KEY (medico_id, especialidad_id),
    FOREIGN KEY (medico_id) REFERENCES medico (id),
    FOREIGN KEY (especialidad_id) REFERENCES especialidad (id)
);

CREATE TABLE medico_hospital (
    medico_id INT,
    hospital_id INT,
    PRIMARY KEY (medico_id, hospital_id),
    FOREIGN KEY (medico_id) REFERENCES medico (id),
    FOREIGN KEY (hospital_id) REFERENCES hospital (id)
);


-- Insertar datos en tablas
INSERT INTO hospital (nombre, provincia) VALUES ('Hospital Max Peralta', 'Cartago');
INSERT INTO hospital (nombre, provincia) VALUES ('Hospital San Rafael', 'Alajuela');
INSERT INTO hospital (nombre, provincia) VALUES ('Hospital San Vicente de Paul', 'Heredia');

INSERT INTO medico (cedula, nombre, primer_apellido, direccion_provincia) VALUES ('4-0071-0076', 'Gloria', 'Morales', 'Alajuela');
INSERT INTO medico (cedula, nombre, primer_apellido, direccion_provincia) VALUES ('1-0651-0656', 'Andrea', 'Porras', 'Heredia');
INSERT INTO medico (cedula, nombre, primer_apellido, direccion_provincia) VALUES ('4-9876-6535', 'Aurelio', 'Sanabria', 'Alajuela');
INSERT INTO medico (cedula, nombre, primer_apellido, direccion_provincia) VALUES ('3-7879-8765', 'Jaime', 'Vargas', 'Cartago');

INSERT INTO especialidad (nombre) VALUES ('Cardiologo');
INSERT INTO especialidad (nombre) VALUES ('Alergologo');
INSERT INTO especialidad (nombre) VALUES ('Pediatra');
INSERT INTO especialidad (nombre) VALUES ('Nutricionista');


-- Insertar datos en tablas de relaciones
INSERT ALL
    INTO medico_especialidad VALUES (1, 1)
    INTO medico_especialidad VALUES (1, 2)
    INTO medico_especialidad VALUES (2, 3)
    INTO medico_especialidad VALUES (2, 4)
    INTO medico_especialidad VALUES (3, 4)
    INTO medico_especialidad VALUES (4, 4)
SELECT DUMMY FROM DUAL;

INSERT ALL
    INTO medico_hospital VALUES (1, 2)
    INTO medico_hospital VALUES (1, 3)
    INTO medico_hospital VALUES (4, 3)
SELECT DUMMY FROM DUAL;


-- Función para imprimir una lista de las especialidades del médico especificado
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION lista_especialidades (varCedula VARCHAR2) 
    RETURN VARCHAR2 IS
        v_especialidades VARCHAR2(1000);
BEGIN
    FOR reg IN (SELECT e.nombre
                FROM medico m
                INNER JOIN medico_especialidad me ON m.id = me.medico_id
                INNER JOIN especialidad e ON e.id = me.especialidad_id
                WHERE m.cedula = varCedula
                ORDER BY e.nombre ASC) LOOP
        v_especialidades := v_especialidades || reg.nombre || ', ';
    END LOOP;
    
    IF LENGTH(v_especialidades) > 0 THEN
        v_especialidades := SUBSTR(v_especialidades, 1, LENGTH(v_especialidades) - 2);
    END IF;
    
    RETURN v_especialidades;
END;
/


-- Crear tabla temporal
CREATE TABLE Temporal (
    medico_cedula VARCHAR2(11),
    medico_nombre VARCHAR2(30),
    medico_apellido VARCHAR2(30),
    medico_provincia VARCHAR2(10),
    especialidades VARCHAR2(100),
    hospital_nombre VARCHAR2(30)
);


-- Procedimiento Almacenado para Normalizar tablas
CREATE OR REPLACE PROCEDURE importar_datos_temporales AS
    v_medico_cedula VARCHAR2(11);
    v_medico_nombre VARCHAR2(30);
    v_medico_apellido VARCHAR2(30);
    v_medico_provincia VARCHAR2(10);
    v_especialidades VARCHAR2(100);
    v_hospital_nombre VARCHAR2(30);
    v_medico_id INT;
    v_especialidad_id INT;
    v_hospital_id INT;
    
BEGIN
    FOR temporal_rec IN (SELECT * FROM Temporal) LOOP
        v_medico_cedula := temporal_rec.medico_cedula;
        v_medico_nombre := temporal_rec.medico_nombre;
        v_medico_apellido := temporal_rec.medico_apellido;
        v_medico_provincia := temporal_rec.medico_provincia;
        v_especialidades := temporal_rec.especialidades;
        v_hospital_nombre := temporal_rec.hospital_nombre;
        
        BEGIN
            -- Verificación si el médico ya existe
            SELECT id INTO v_medico_id
            FROM medico
            WHERE cedula = v_medico_cedula;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_medico_id := NULL;
        END;
        
        IF v_medico_id IS NULL THEN
            INSERT INTO medico (cedula, nombre, primer_apellido, direccion_provincia)
            VALUES (v_medico_cedula, v_medico_nombre, v_medico_apellido, v_medico_provincia)
            RETURNING id INTO v_medico_id;
        END IF;
        
        -- Separación de especialidades en cadena
        FOR especialidad_rec IN (SELECT TRIM(REGEXP_SUBSTR(v_especialidades, '[^,]+', 1, LEVEL)) AS especialidad
                                  FROM dual
                                  CONNECT BY INSTR(v_especialidades, ',', 1, LEVEL - 1) > 0) LOOP
            BEGIN
                -- Verificación si la especialidad ya existe
                SELECT id INTO v_especialidad_id
                FROM especialidad
                WHERE nombre = especialidad_rec.especialidad;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_especialidad_id := NULL;
            END;
            
            IF v_especialidad_id IS NULL THEN
                INSERT INTO especialidad (nombre)
                VALUES (especialidad_rec.especialidad)
                RETURNING id INTO v_especialidad_id;
            END IF;
            
            -- Asociando médico con especialidad
            INSERT INTO medico_especialidad (medico_id, especialidad_id)
            VALUES (v_medico_id, v_especialidad_id);
        END LOOP;
        
        BEGIN
            SELECT id INTO v_hospital_id
            FROM hospital
            WHERE nombre = v_hospital_nombre;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_hospital_id := NULL;
        END;
        
        -- Error si el hospital no existe
        IF v_hospital_id IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Error: El hospital "' || v_hospital_nombre || '" no existe.');
        ELSE
            INSERT INTO medico_hospital (medico_id, hospital_id)
            VALUES (v_medico_id, v_hospital_id);
        END IF;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Datos importados exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/


-- Pruebas de la función y el procedimiento almacenado
/*
-- Prueba de función lista_especialidades

DECLARE
    v_lista_especialidades VARCHAR2(1000);
BEGIN
    v_lista_especialidades := lista_especialidades('4-0071-0076');
    DBMS_OUTPUT.PUT_LINE(v_lista_especialidades);
END;

-- Prueba del procedimiento almacenado importar_datos_temporales
SELECT * FROM medico;

SELECT * FROM especialidad;

SELECT * FROM medico_especialidad;

SELECT * FROM medico_hospital;


INSERT INTO Temporal (medico_cedula, medico_nombre, medico_apellido, medico_provincia, especialidades, hospital_nombre)
VALUES ('3-0098-8768', 'Marta', 'Morales', 'Cartago', 'Alergólogo, Pediatra, Nutricionista, Odontólogo', 'Hospital Max Peralta');

INSERT INTO Temporal (medico_cedula, medico_nombre, medico_apellido, medico_provincia, especialidades, hospital_nombre)
VALUES ('2-0876-4527', 'Flor', 'Flores', 'Heredia', 'Nutricionista, Cardióloga, Médico general', 'Hospital San Vicente de Paul');

INSERT INTO Temporal (medico_cedula, medico_nombre, medico_apellido, medico_provincia, especialidades, hospital_nombre)
VALUES ('1-9976-0442', 'Kevin', 'Moraga', 'Alajuela', 'Cardiólogo, Pediatra, Hepatólogo', 'Hospital San Rafael');


BEGIN
    importar_datos_temporales;
END;
/
*/

