-- TABLAS
CREATE TABLE hospital (
    id INT PRIMARY KEY,
    nombre VARCHAR2(30),
    provincia VARCHAR2(10)
);

CREATE TABLE medico (
    id INT PRIMARY KEY,
    cedula VARCHAR2(11),
    nombre VARCHAR2(10),
    primer_apellido VARCHAR2(10),
    direccion_provincia VARCHAR2(10)
);

CREATE TABLE especialidad (
    id INT PRIMARY KEY,
    nombre VARCHAR2(15)
);

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



-- INSERTS
-- Hospital
INSERT ALL
    INTO hospital VALUES (1, 'Hospital Max Peralta', 'Cartago')
    INTO hospital VALUES (2, 'Hospital San Rafael', 'Alajuela')
    INTO hospital VALUES (3, 'Hospital San Vicente de Paul', 'Heredia')
SELECT DUMMY FROM DUAL;


-- Medico
INSERT ALL
    INTO medico VALUES (1, '4-0071-0076', 'Gloria', 'Morales', 'Alajuela')
    INTO medico VALUES (2, '1-0651-0656', 'Andrea', 'Porras', 'Heredia')
    INTO medico VALUES (3, '4-9876-6535', 'Aurelio', 'Sanabria', 'Alajuela')
    INTO medico VALUES (4, '3-7879-8765', 'Jaime', 'Vargas', 'Cartago')
SELECT DUMMY FROM DUAL;


-- Especialidad
INSERT ALL
    INTO especialidad VALUES (1, 'Cardiologo')
    INTO especialidad VALUES (2, 'Alergologo')
    INTO especialidad VALUES (3, 'Pediatra')
    INTO especialidad VALUES (4, 'Nutricionista')
SELECT DUMMY FROM DUAL;


-- Medico_especialidad
INSERT ALL
    INTO medico_especialidad VALUES (1, 1)
    INTO medico_especialidad VALUES (1, 2)
    INTO medico_especialidad VALUES (2, 3)
    INTO medico_especialidad VALUES (2, 4)
    INTO medico_especialidad VALUES (3, 4)
    INTO medico_especialidad VALUES (4, 4)
SELECT DUMMY FROM DUAL;


-- Medico_hospital
INSERT ALL
    INTO medico_hospital VALUES (1, 2)
    INTO medico_hospital VALUES (1, 3)
    INTO medico_hospital VALUES (4, 3)
SELECT DUMMY FROM DUAL;



-- EJERCICIOS
-- 1.1
SELECT
    h.nombre AS nombre_hospital,
    m.cedula,
    m.nombre AS nombre_medico,
    m.primer_apellido,
    m.direccion_provincia
FROM hospital h
INNER JOIN medico_hospital mh
    ON h.id = mh.hospital_id
INNER JOIN medico m
    ON mh.medico_id = m.id
WHERE mh.medico_id IN (
    SELECT me.medico_id
    FROM medico_especialidad me
    INNER JOIN especialidad e
        ON me.especialidad_id = e.id
    WHERE e.nombre = 'Cardiologo'
);

-- 1.2
SELECT 
    m.cedula,
    m.nombre AS nombre_medico,
    m.primer_apellido,
    m.direccion_provincia,
    h.nombre AS hospitales_asociados,
    e.nombre AS especialidad_adquirida
FROM medico m
LEFT JOIN (
        SELECT 
            mh.medico_id,
            h.nombre
        FROM 
            medico_hospital mh
        JOIN 
            hospital h ON mh.hospital_id = h.id
    ) h ON m.id = h.medico_id
LEFT JOIN (
        SELECT 
            me.medico_id,
            e.nombre
        FROM 
            medico_especialidad me
        JOIN 
            especialidad e ON me.especialidad_id = e.id
    ) e ON m.id = e.medico_id
GROUP BY 
    m.cedula, m.nombre, m.primer_apellido, m.direccion_provincia, h.nombre, e.nombre;

-- 1.3 
SELECT
    h.nombre AS nombre_hospital,
    e.nombre AS especialidad_medica
FROM hospital h
LEFT JOIN medico_hospital mh
    ON h.id = mh.hospital_id
LEFT JOIN medico_especialidad me
    ON mh.medico_id = me.medico_id
LEFT JOIN especialidad e
    ON me.especialidad_id = e.id;
