/*
DROP SEQUENCE cliente_seq;
DROP SEQUENCE provedor_seq;
DROP SEQUENCE producto_seq;
DROP SEQUENCE empleado_seq;
DROP SEQUENCE factura_seq;

DROP TABLE venta_producto;
DROP TABLE compra_proveedor;
DROP TABLE Factura;
DROP TABLE Usuario;
DROP TABLE Producto;
DROP TABLE Proveedor;
DROP TABLE Empleado;
DROP TABLE Cliente;
DROP TABLE Producto_Log;
*/

//---------------------------- SECUENCIAS ----------------------------
/*Inician en 1 e incrementan 1*/
CREATE SEQUENCE cliente_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE empleado_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE factura_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE SEQUENCE provedor_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
    
CREATE SEQUENCE producto_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;


//---------------------------- TABLAS DE ENTIDADES ----------------------------
-- Cliente
CREATE TABLE Cliente (
    id INT DEFAULT cliente_seq.NEXTVAL,
    nombre VARCHAR2(30) NOT NULL,
    direccion VARCHAR2(40) NOT NULL,
    telefono NUMBER(8) NOT NULL,
    CONSTRAINT cliente_pk PRIMARY KEY (id)
);

-- Empleado
CREATE TABLE Empleado (
    id INT DEFAULT empleado_seq.NEXTVAL,
    nombre VARCHAR2(30) NOT NULL,
    telefono NUMBER(8) NOT NULL,
    salario_mensual NUMBER(6) NOT NULL,
    puesto VARCHAR2(8),
    CONSTRAINT empleado_pk PRIMARY KEY (id)
);

-- Proveedor
CREATE TABLE Proveedor (
    id INT DEFAULT provedor_seq.NEXTVAL,
    nombre VARCHAR2(30) NOT NULL,
    telefono NUMBER(8) NOT NULL,
    CONSTRAINT proveedor_pk PRIMARY KEY (id)
);

-- Producto
CREATE TABLE Producto (
    id INT DEFAULT producto_seq.NEXTVAL,
    nombre VARCHAR2(30) NOT NULL,
    precio_unidad NUMBER(6) NOT NULL,
    id_proveedor INT,
    CONSTRAINT producto_pk PRIMARY KEY (id),
    CONSTRAINT producto_fk_proveedor FOREIGN KEY (id_proveedor) REFERENCES Proveedor (id)
);

-- Usuario
CREATE TABLE Usuario (
    id_empleado INT,
    contrasena VARCHAR2(15) NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY (id_empleado),
    CONSTRAINT usuario_fk_empleado FOREIGN KEY (id_empleado) REFERENCES Empleado (id)
);


//---------------------------- TABLAS TRANSACCIONALES ----------------------------
-- Factura - Principal
CREATE TABLE Factura(
    id_factura INT DEFAULT factura_seq.NEXTVAL,
    fecha DATE NOT NULL,
    hora VARCHAR2(5),
    id_cliente INT,
    id_cajero INT,
    total NUMBER(6) NOT NULL,
    CONSTRAINT facturapk PRIMARY KEY (id_factura),
    CONSTRAINT facturafk_cli FOREIGN KEY (id_cliente) REFERENCES cliente (id),
    CONSTRAINT facturafk_emp FOREIGN KEY (id_cajero) REFERENCES empleado (id)
);

-- venta_producto - Tabla de relación entre factura y producto
CREATE TABLE venta_producto (
    id_factura INT,
    id_producto INT,
    precio_venta NUMBER(10,2),
    cantidad NUMBER,
    CONSTRAINT venta_producto_pk PRIMARY KEY (id_factura, id_producto),
    CONSTRAINT venta_producto_fk_factura FOREIGN KEY (id_factura) REFERENCES factura (id_factura),
    CONSTRAINT venta_producto_fk_producto FOREIGN KEY (id_producto) REFERENCES producto (id)
);

-- compra_proveedor - Tabla de relación entre producto y proveedor
CREATE TABLE compra_proveedor (
    id_producto INT,
    id_proveedor INT,
    cantidad_producto NUMBER,
    precio_venta NUMBER(10,2),
    fecha DATE NOT NULL,
    hora VARCHAR2(5),
    CONSTRAINT compra_proveedor_pk PRIMARY KEY (id_producto, id_proveedor),
    CONSTRAINT compra_proveedor_fk_producto FOREIGN KEY (id_producto) REFERENCES producto (id),
    CONSTRAINT compra_proveedor_fk_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor (id)
);


//---------------------------- TABLA DE BITÁCORA ----------------------------
/*Se utiliza en el trigger producto_precio_tgr*/
-- Producto_Log
CREATE TABLE Producto_Log (
    id_producto INT,
    fecha_hora TIMESTAMP,
    precio_anterior NUMBER(6),
    precio_nuevo NUMBER(6)
);


//---------------------------- OPERACIONES CRUD ----------------------------
// CREATE
-- Cliente
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Alice Johnson', 'Calle 1, San José', 12345678);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Bob Smith', 'Avenida Central, Heredia', 95464781);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Charlie Brown', 'Barrio San Francisco, Alajuela', 34259614);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Diana Miller', 'Calle 3, Cartago', 25485219);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Ella Davis', 'Barrio La Granja, Puntarenas', 21574963);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Frank Wilson', 'Avenida 2, Limón', 13485852);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Gina Lee', 'Barrio Los Ángeles, Guanacaste', 54876128);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Henry Garcia', 'Calle 5, San Carlos', 88457601);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Isabel Lopez', 'Avenida 4, Liberia', 93152420);
INSERT INTO Cliente (nombre, direccion, telefono) VALUES ('Jackie Martinez', 'Barrio El Carmen, Pérez Zeledón', 33514785);

-- Empleado
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Juan Perez', 22223333, 250000, 'Cajero');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Maria Rodriguez', 33334444, 280000, 'Cajero');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Carlos Sanchez', 44445555, 300000, 'Limpieza');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Luisa Jimenez', 55556666, 270000, 'Cajero');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Ana Gomez', 66667777, 290000, 'Cajero');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Pedro Martinez', 77778888, 320000, 'Gerente');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Sofia Herrera', 88889999, 350000, 'Gerente');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Javier Fernandez', 99990000, 280000, 'Cajero');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Laura Diaz', 11112222, 260000, 'Cajero');
INSERT INTO Empleado (nombre, telefono, salario_mensual, puesto) VALUES ('Roberto Castro', 22223333, 310000, 'Gerente');

-- Proveedor
INSERT INTO Proveedor (nombre, telefono) VALUES ('Distribuidora San José', 22345678);
INSERT INTO Proveedor (nombre, telefono) VALUES ('Productos Alfa', 33456789);
INSERT INTO Proveedor (nombre, telefono) VALUES ('Suministros Beta', 44567890);
INSERT INTO Proveedor (nombre, telefono) VALUES ('Comercializadora Gamma', 55678901);
INSERT INTO Proveedor (nombre, telefono) VALUES ('Insumos Delta', 66789012);

-- Producto
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Arroz', 1000, 1);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Frijoles', 800, 2);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Leche', 850, 3);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Huevos', 600, 4);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Pan', 500, 5);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Pasta', 700, 5);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Aceite', 1200, 2);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Azúcar', 900, 3);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Sal', 400, 1);
INSERT INTO Producto (nombre, precio_unidad, id_proveedor) VALUES ('Café', 1500, 1);

-- Factura
-- Alice Johnson (ID 1)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-03-01', 'YYYY-MM-DD'), '09:15', 1, 1, 1500);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-01-05', 'YYYY-MM-DD'), '18:30', 1, 10, 2400);

-- Bob Smith (ID 2)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2023-06-01', 'YYYY-MM-DD'), '09:30', 2, 1, 2000);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2023-04-06', 'YYYY-MM-DD'), '10:15', 2, 1, 1700);

-- Charlie Brown (ID 3)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2023-09-01', 'YYYY-MM-DD'), '10:00', 3, 2, 1800);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-02-06', 'YYYY-MM-DD'), '10:45', 3, 2, 1950);

-- Diana Miller (ID 4)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2023-06-01', 'YYYY-MM-DD'), '11:45', 4, 3, 2200);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2023-06-01', 'YYYY-MM-DD'), '11:30', 4, 3, 2100);

-- Ella Davis (ID 5)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-02', 'YYYY-MM-DD'), '12:30', 5, 4, 2500);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-03-01', 'YYYY-MM-DD'), '12:00', 5, 4, 2300);

-- Frank Wilson (ID 6)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-03', 'YYYY-MM-DD'), '14:20', 6, 5, 1900);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-01-08', 'YYYY-MM-DD'), '14:45', 6, 5, 2500);

-- Gina Lee (ID 7)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-01-05', 'YYYY-MM-DD'), '15:10', 7, 6, 2100);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-08', 'YYYY-MM-DD'), '15:20', 7, 6, 1800);

-- Henry Garcia (ID 8)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-04', 'YYYY-MM-DD'), '16:45', 8, 7, 2300);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-09', 'YYYY-MM-DD'), '16:00', 8, 7, 2200);

-- Isabel Lopez (ID 9)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-04', 'YYYY-MM-DD'), '17:20', 9, 8, 1800);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-04-09', 'YYYY-MM-DD'), '16:30', 9, 8, 1950);

-- Jackie Martinez (ID 10)
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-02-05', 'YYYY-MM-DD'), '18:00', 10, 9, 2000);
INSERT INTO Factura (fecha, hora, id_cliente, id_cajero, total) VALUES (TO_DATE('2024-02-10', 'YYYY-MM-DD'), '18:15', 10, 9, 2100);


-- Usuario
INSERT INTO Usuario (id_empleado, contrasena) VALUES (1, 'juan.MS1'); -- Juan Perez
INSERT INTO Usuario (id_empleado, contrasena) VALUES (2, 'maria.MS2'); -- Maria Rodriguez
INSERT INTO Usuario (id_empleado, contrasena) VALUES (4, 'luisa.MS4'); -- Luisa Jimenez
INSERT INTO Usuario (id_empleado, contrasena) VALUES (5, 'ana.MS5'); -- Ana Gomez
INSERT INTO Usuario (id_empleado, contrasena) VALUES (6, 'pedro.MS6'); -- Pedro Martinez
INSERT INTO Usuario (id_empleado, contrasena) VALUES (7, 'sofia.MS7'); -- Sofia Herrera
INSERT INTO Usuario (id_empleado, contrasena) VALUES (8, 'javier.MS8'); -- Javier Fernandez
INSERT INTO Usuario (id_empleado, contrasena) VALUES (9, 'laura.MS9'); -- Laura Diaz
INSERT INTO Usuario (id_empleado, contrasena) VALUES (10, 'roberto.MS10'); -- Roberto Castro


-- Venta_Producto
-- Venta 1
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (1, 1, 750, 2); -- Arroz
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (1, 2, 600, 3); -- Frijoles
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (1, 3, 637.50, 1); -- Leche

-- Venta 2
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (2, 4, 450, 1); -- Huevos
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (2, 5, 375, 2); -- Pan
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (2, 6, 675, 1); -- Pasta

-- Venta 3
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (3, 7, 900, 1); -- Aceite
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (3, 8, 750, 1); -- Azúcar
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (3, 9, 300, 2); -- Sal

-- Venta 4
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (4, 10, 1125, 2); -- Café
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (4, 1, 750, 1); -- Arroz
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (4, 2, 600, 3); -- Frijoles

-- Venta 5
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (5, 3, 637.50, 1); -- Leche
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (5, 4, 450, 1); -- Huevos
INSERT INTO venta_producto (id_factura, id_producto, precio_venta, cantidad) VALUES (5, 5, 375, 2); -- Pan


-- Compra_Proveedor
-- Distribuidora San José (ID 1)
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (1, 1, 100, 750.00, TO_DATE('2023-01-01', 'YYYY-MM-DD'), '08:30');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (6, 1, 70, 525.00, TO_DATE('2024-04-12', 'YYYY-MM-DD'), '10:45');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (5, 1, 60, 450.00, TO_DATE('2023-11-15', 'YYYY-MM-DD'), '12:20');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (10, 1, 180, 1350.00, TO_DATE('2024-02-20', 'YYYY-MM-DD'), '14:00');

-- Productos Alfa (ID 2)
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (2, 2, 80, 600.00, TO_DATE('2024-01-10', 'YYYY-MM-DD'), '09:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (7, 2, 120, 900.00, TO_DATE('2024-03-12', 'YYYY-MM-DD'), '11:30');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (1, 2, 120, 900.00, TO_DATE('2023-06-15', 'YYYY-MM-DD'), '13:15');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (6, 2, 90, 675.00, TO_DATE('2023-07-20', 'YYYY-MM-DD'), '15:00');

-- Suministros Beta (ID 3)
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (3, 3, 90, 675.00, TO_DATE('2024-01-10', 'YYYY-MM-DD'), '09:30');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (8, 3, 85, 637.50, TO_DATE('2023-06-12', 'YYYY-MM-DD'), '12:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (2, 3, 100, 750.00, TO_DATE('2023-09-15', 'YYYY-MM-DD'), '14:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (7, 3, 130, 975.00, TO_DATE('2023-10-20', 'YYYY-MM-DD'), '16:30');

-- Comercializadora Gamma (ID 4)
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (4, 4, 60, 450.00, TO_DATE('2024-03-10', 'YYYY-MM-DD'), '10:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (9, 4, 40, 300.00, TO_DATE('2024-02-12', 'YYYY-MM-DD'), '13:30');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (3, 4, 110, 825.00, TO_DATE('2024-01-15', 'YYYY-MM-DD'), '15:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (8, 4, 95, 712.50, TO_DATE('2024-03-20', 'YYYY-MM-DD'), '17:00');

-- Insumos Delta (ID 5)
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (5, 5, 50, 375.00, TO_DATE('2023-06-10', 'YYYY-MM-DD'), '10:30');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (10, 5, 150, 1125.00, TO_DATE('2023-06-12', 'YYYY-MM-DD'), '14:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (4, 5, 70, 525.00, TO_DATE('2023-04-15', 'YYYY-MM-DD'), '16:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (9, 5, 50, 375.00, TO_DATE('2023-04-20', 'YYYY-MM-DD'), '18:00');
INSERT INTO compra_proveedor (id_producto, id_proveedor, cantidad_producto, precio_venta, fecha, hora) VALUES (2, 5, 50, 375.00, TO_DATE('2024-05-20', 'YYYY-MM-DD'), '18:00');


// READ
/* READ más elaborados se implementan con total_ventas_cliente y obtener_detalle_factura
dentro del package "paquete_consultas" */
-- Cliente
SELECT * FROM Cliente;
-- Factura
SELECT * FROM Factura;


// UPDATE Y DELETE
/* Se implementan el update y delete sobre la entidad fuerte Cliente y la tabla
transaccional Factura dentro del package "paquete_modificacion" */


//---------------------------- TRIGGERS ----------------------------
-- producto_precio_tgr - Trigger para llevar una bitácora del cambio de precio en los productos
CREATE OR REPLACE TRIGGER producto_precio_tgr
AFTER UPDATE OF precio_unidad ON Producto
FOR EACH ROW
DECLARE
    v_precio_anterior NUMBER(6);
BEGIN
    v_precio_anterior := :OLD.precio_unidad;

    INSERT INTO Producto_Log (id_producto, fecha_hora, precio_anterior, precio_nuevo)
    VALUES (:OLD.id, SYSTIMESTAMP, v_precio_anterior, :NEW.precio_unidad);
END;
/

-- usuario_puesto_tgr - Trigger para que no permita crear usuarios a empleados con puesto "Limpieza"
CREATE OR REPLACE TRIGGER usuario_puesto_tgr
BEFORE INSERT ON Usuario
FOR EACH ROW
DECLARE
    v_puesto_empleado VARCHAR2(8);
BEGIN
    SELECT puesto INTO v_puesto_empleado
    FROM Empleado
    WHERE id = :NEW.id_empleado;

    IF v_puesto_empleado = 'Limpieza' THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede crear un usuario para un empleado de Limpieza.');
    END IF;
END;
/




//---------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------
-- Procedimiento para obtener el ID de una factura a partir de su fecha y hora.
CREATE OR REPLACE PROCEDURE ObtenerIdFactura(
    fecha_factura IN DATE,
    hora_factura IN VARCHAR2
)
AS
    p_id_factura INT;
BEGIN
    SELECT id_factura INTO p_id_factura
    FROM Factura
    WHERE fecha = fecha_factura AND hora = hora_factura;

    DBMS_OUTPUT.PUT_LINE('El ID de la factura es: ' || p_id_factura);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró ninguna factura para la fecha y hora especificadas.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Se encontraron múltiples facturas para la fecha y hora especificadas.');
END ObtenerIdFactura;
/


//---------------------------- PACKAGES ----------------------------
-- Paquete para operaciones de modificación
CREATE OR REPLACE PACKAGE paquete_modificacion AS
    -- Procedimiento para actualizar la información de un cliente.
    PROCEDURE actualizar_cliente(
        p_id_cliente IN INT,
        p_nombre IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_telefono IN NUMBER
    );
    
    -- Función para eliminar un cliente.
    FUNCTION eliminar_cliente(p_id_cliente IN INT) RETURN VARCHAR2;

    -- Procedimiento para actualizar una factura.
    PROCEDURE actualizar_factura(
        p_id_factura IN INT,
        p_fecha IN DATE,
        p_id_cliente IN INT,
        p_id_empleado IN INT,
        p_total IN NUMBER
    );
    
    -- Función para eliminar una factura.
    FUNCTION eliminar_factura(p_id_factura IN INT) RETURN VARCHAR2;

END paquete_modificacion;
/

CREATE OR REPLACE PACKAGE BODY paquete_modificacion AS
    PROCEDURE actualizar_cliente(
        p_id_cliente IN INT,
        p_nombre IN VARCHAR2,
        p_direccion IN VARCHAR2,
        p_telefono IN NUMBER
    ) IS
    BEGIN
        UPDATE Cliente
        SET nombre = p_nombre,
            direccion = p_direccion,
            telefono = p_telefono
        WHERE id = p_id_cliente;
        COMMIT;
    END actualizar_cliente;


    FUNCTION eliminar_cliente(p_id_cliente IN INT) RETURN VARCHAR2 IS
        v_mensaje VARCHAR2(100);
        v_count NUMBER;
    BEGIN
        -- Verificar si existen facturas asociadas al cliente
        SELECT COUNT(*)
        INTO v_count
        FROM Factura
        WHERE id_cliente = p_id_cliente;
    
        IF v_count > 0 THEN
            -- Eliminar los registros relacionados de venta_producto
            DELETE FROM venta_producto vp
            WHERE vp.id_factura IN (SELECT id_factura FROM Factura WHERE id_cliente = p_id_cliente);
            
            -- Eliminar las facturas asociadas al cliente
            DELETE FROM Factura WHERE id_cliente = p_id_cliente;
        END IF;
    
        -- Eliminar el cliente
        DELETE FROM Cliente WHERE id = p_id_cliente;
        
        COMMIT;
        v_mensaje := 'El cliente y sus facturas asociadas han sido eliminados exitosamente.';
        RETURN v_mensaje;
    END eliminar_cliente;

    
    PROCEDURE actualizar_factura(
        p_id_factura IN INT,
        p_fecha IN DATE,
        p_id_cliente IN INT,
        p_id_empleado IN INT,
        p_total IN NUMBER
    ) IS
    BEGIN
        UPDATE Factura
        SET fecha = p_fecha,
            id_cliente = p_id_cliente,
            id_cajero = p_id_empleado,
            total = p_total
        WHERE id_factura = p_id_factura;
        COMMIT;
    END actualizar_factura;


    FUNCTION eliminar_factura(p_id_factura IN INT) RETURN VARCHAR2 IS
        v_mensaje VARCHAR2(100);
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM Factura
        WHERE id_factura = p_id_factura;
        
        IF v_count > 0 THEN
            -- Eliminar los registros relacionados de venta_producto
            DELETE FROM venta_producto WHERE id_factura = p_id_factura;
            
            -- Eliminar la factura
            DELETE FROM Factura WHERE id_factura = p_id_factura;
            
            COMMIT;
            v_mensaje := 'La factura ha sido eliminada exitosamente.';
        ELSE
            v_mensaje := 'No se encontró ninguna factura con el ID especificado.';
        END IF;
        RETURN v_mensaje;
    END eliminar_factura;

END paquete_modificacion;



-- paquete para operaciones de consulta
CREATE OR REPLACE PACKAGE paquete_consultas AS
    -- procedimiento para ver las ventas de un cliente dentro de un lapsop de tiempo
    PROCEDURE total_ventas_cliente(p_id_cliente IN NUMBER, p_fecha_inicio IN DATE, p_fecha_fin IN DATE);
    
    -- función para obetener los detalles de una factura con su id
    FUNCTION obtener_detalle_factura(p_id_factura IN NUMBER) RETURN VARCHAR2;

END paquete_consultas;
/

CREATE OR REPLACE PACKAGE BODY paquete_consultas AS
    PROCEDURE total_ventas_cliente(p_id_cliente IN NUMBER, p_fecha_inicio IN DATE, p_fecha_fin IN DATE) IS
        v_total NUMBER := 0;
    BEGIN
        -- Consulta para calcular el total de ventas de un cliente en un período de tiempo específico
        SELECT SUM(f.total)
        INTO v_total
        FROM factura f
        WHERE f.id_cliente = p_id_cliente
        AND f.fecha BETWEEN p_fecha_inicio AND p_fecha_fin;

        -- Imprimir el resultado
        DBMS_OUTPUT.PUT_LINE('Total de ventas del cliente ' || p_id_cliente || ': ' || v_total);
    END total_ventas_cliente;

    FUNCTION obtener_detalle_factura(p_id_factura IN NUMBER) RETURN VARCHAR2 IS
        v_detalle VARCHAR2(4000);
        v_cliente_nombre VARCHAR2(30);
        v_cajero_nombre VARCHAR2(30);
    BEGIN
        -- Consulta para obtener los detalles de la factura, cliente y cajero
        SELECT 'Detalle de la factura: ID: ' || f.id_factura || ', Cliente: ' || c.nombre || ', Cajer@: ' || cj.nombre || ', Fecha: ' || TO_CHAR(f.fecha, 'YYYY-MM-DD') || ', Hora: ' || f.hora || ', Total: ' || TO_CHAR(f.total)
        INTO v_detalle
        FROM factura f
        INNER JOIN cliente c ON f.id_cliente = c.id
        INNER JOIN empleado cj ON f.id_cajero = cj.id
        WHERE f.id_factura = p_id_factura;

        -- Devolver los detalles de la factura
        RETURN v_detalle;
    END obtener_detalle_factura;
END paquete_consultas;
/


//---------------------------- RESUMEN DE TRANSACCIONES ----------------------------
-- montos vendidos por mes (ventas y utilidad) incluyendo los que no se hayan realizado ventas.
SELECT TO_CHAR(cp.fecha, 'YYYY-MM') AS fecha_mes,
       COALESCE(SUM(f.total), 0) AS total_ventas,
       COALESCE(SUM(cp.cantidad_producto * cp.precio_venta), 0) AS total_compras,
       COALESCE(SUM(f.total), 0) - COALESCE(SUM(cp.cantidad_producto * cp.precio_venta), 0) AS utilidad
FROM compra_proveedor cp
LEFT JOIN factura f ON TO_CHAR(cp.fecha, 'YYYY-MM') = TO_CHAR(f.fecha, 'YYYY-MM')
GROUP BY TO_CHAR(cp.fecha, 'YYYY-MM')
ORDER BY fecha_mes;

-- montos vendidos por mes (ventas y utilidad) en los que sí se hayan realizado ventas.
SELECT TO_CHAR(cp.fecha, 'YYYY-MM') AS fecha_mes,
       COALESCE(SUM(f.total), 0) AS total_ventas,
       COALESCE(SUM(cp.cantidad_producto * cp.precio_venta), 0) AS total_compras,
       COALESCE(SUM(f.total), 0) - COALESCE(SUM(cp.cantidad_producto * cp.precio_venta), 0) AS utilidad
FROM compra_proveedor cp
JOIN factura f ON TO_CHAR(cp.fecha, 'YYYY-MM') = TO_CHAR(f.fecha, 'YYYY-MM')
GROUP BY TO_CHAR(cp.fecha, 'YYYY-MM')
ORDER BY fecha_mes;

//---------------------------- PRUEBAS ----------------------------
/*
// Trigger
-- Trigger 1 - producto_precio_tgr
SELECT * FROM Producto;
SELECT * FROM Producto_Log;
UPDATE Producto SET precio_unidad = 1300 WHERE id = 1;
SELECT * FROM Producto_Log;
SELECT * FROM Producto;

-- Trigger 2 - usuario_puesto_tgr
INSERT INTO Usuario (id_empleado, contrasena) VALUES (3, 'carlos789'); -- Carlos González


// Procedimiento Almacenado
SELECT * FROM FACTURA;
-- Ejemplo con facturea que no existe
SET SERVEROUTPUT ON;
BEGIN
    ObtenerIdFactura(TO_DATE('2024-04-06', 'YYYY-MM-DD'), '18:30');
END;
/

-- Ejemplo con facturea que sí existe
SET SERVEROUTPUT ON;
BEGIN
    ObtenerIdFactura(TO_DATE('2023-04-06', 'YYYY-MM-DD'), '10:15');
END;
/


// Package
-- Paquete 1
-- actualizar cliente
SELECT * FROM Cliente WHERE id = 1;
BEGIN
    paquete_modificacion.actualizar_cliente(1, 'Alice Sanchez', 'Calle 2, San José', 99999999);
    -- 1	Alice Johnson	Calle 1, San José	12345678
END;

-- actualizar factura
SELECT * FROM FACTURA;
BEGIN
    paquete_modificacion.actualizar_factura(
        p_id_factura => 1,
        p_fecha => TO_DATE('2024-04-07', 'YYYY-MM-DD'),
        p_id_cliente => 3,
        p_id_empleado => 2,
        p_total => 3200
    );
END;

-- eliminar factura
SELECT * FROM Factura WHERE id_factura = 6;
BEGIN
    DBMS_OUTPUT.PUT_LINE(paquete_modificacion.eliminar_factura(6));
END;

-- eliminar cliente
SELECT * FROM Cliente;
BEGIN
    DBMS_OUTPUT.PUT_LINE(paquete_modificacion.eliminar_cliente(2));
END;


-- Paquete 2
-- total_ventas_cliente
BEGIN
    paquete_consultas.total_ventas_cliente(1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
END;

-- obtener_detalle_factura
BEGIN
    DBMS_OUTPUT.PUT_LINE(paquete_consultas.obtener_detalle_factura(20));
END;

*/

