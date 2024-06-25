<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Acceso a Sistema del Super la Esquina</title>
    </head>
    <body>
        <h1>Facturación</h1>
        <form action="SvCaja" method="GET">
            <p><label>ID Empleado: </label> <input type="text" name="id_empleado"></p>            
            <p><label>Contraseña: </label> <input type="text" name="contrasena"></p>
            <button type="submit" >Ingresar</button>
        </form>
    </body>
</html>
