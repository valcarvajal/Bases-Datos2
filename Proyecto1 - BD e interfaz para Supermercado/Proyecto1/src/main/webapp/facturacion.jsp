<%@page import="java.util.List"%>
<%@page import="logica.Sesion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="clases.Producto"%>
<%@page import="clases.Cliente"%>
<%@page import="clases.Venta_Producto"%>
<%@page import="clases.Empleado"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Facturar Compras</title>
    </head>
    <body>
        <h1>Empleado: <%= Sesion.getEmpleado().getNombre()%></h1>
        <h1>Cliente: <%= Sesion.getCliente().getNombre()%></h1>        
        <h1>Lista</h1>
        <% 
            ArrayList<Venta_Producto> listaProductosV = Sesion.getListaProductosV();
            List<Producto> listaProductos = Sesion.getListaProductos();
            if(listaProductosV != null){
                int index = 1;
                for(Venta_Producto prodV : listaProductosV) {
            %> 
                    <p>Index: <%= index%></p>
                    <p>Producto: <%= listaProductos.get(prodV.getId_producto()-1).getNombre()%></p>
                    <p><label>Cantidad: <%= prodV.getCantidad()%></label></p>
                    <p><label>Costo: <%= prodV.getPrecio_venta()%></label></p>

                    <%
                        index = index + 1;
                        if(index != listaProductos.size()){
                    %>
                        <p>---------------------------</p>
                        <% } %>
                <% } %>   
            <% } %>
            <h1>Total: <%= Sesion.getFactura().getTotal()%></h1>


        <form action="SvLista" method="POST">

            <button type="submit" >Añadir</button>
        </form>
        <form action="SvPago" method="GET">
            <button type="submit" >Pagar</button>
        </form>
        <form action="SvFactura" method="POST">
            <button type="submit" >Cancelar</button>
        </form>
    </body>
</html>
