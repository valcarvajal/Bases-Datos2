<%-- 
    Document   : prefacturacion
    Created on : 6 abr 2024, 12:24:21
    Author     : mrion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Iniciar Factura</title>
    </head>
    <body>
        <h1>Dato del Cliente</h1>
        <form action="SvCliente" method="GET">
            <p><label>ID del Cliente: </label> <input type="text" name="id_cliente"</p>
            <button type="submit" >Buscar</button>
        </form>
    </body>
</html>
