CREATE TABLE OIJ (
    Delito VARCHAR(100),
    SubDelito VARCHAR(100),
    Fecha DATE,
    Hora TIME,
    Victima VARCHAR(100),
    SubVictima VARCHAR(100),
    Edad VARCHAR(50),
    Genero VARCHAR(50),
    Nacionalidad VARCHAR(100),
    Provincia VARCHAR(100),
    Canton VARCHAR(100),
    Distrito VARCHAR(100)
);


CREATE TABLE INEC (
    Provincia VARCHAR(100),
    Canton VARCHAR(100),
    Distrito VARCHAR(100),
    Poblacion_15_y_mas INTEGER,
    Tasa_neta_de_participacion FLOAT,
    Tasa_de_ocupacion FLOAT,
    Tasa_de_desempleo_abierto FLOAT,
    Porcentaje_de_poblacion_economicamente_inactiva FLOAT,
    Relacion_de_dependencia_economica FLOAT,
    Sector_Primario FLOAT,
    Sector_Secundario FLOAT,
    Sector_Terciario FLOAT
);
