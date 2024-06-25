<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Añadir Producto</title>
    </head>
    <body>
        <h1>Especificaciones</h1>
        <form action="SvIncluir" method="POST">
            <p><label>ID Producto: </label> <input type="text" name="id_prod"></p>
            <p><label>Cantidad: </label> <input type="text" name="cant"></p>

            <button type="submit" >Añadir</button>
        </form>
    </body>
</html>
