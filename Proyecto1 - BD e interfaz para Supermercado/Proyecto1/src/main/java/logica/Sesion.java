package logica;

import clases.Cliente;
import clases.Empleado;
import clases.Factura;
import clases.Producto;
import clases.Venta_Producto;
import java.util.ArrayList;
import java.util.List;

public class Sesion {
    private static final ControladoraP CONTROL = new ControladoraP();
    private static Empleado empleado = null;
    private static Cliente cliente = null;
    private static Factura factura = null;
    
    private static ArrayList<Venta_Producto> listaProductosV = new ArrayList<>();
    private static final List<Producto> LISTAPRODUCTOS = (List<Producto>) CONTROL.traerProductos();
    
    public static Empleado getEmpleado() {
        return empleado;
    }

    public static void setEmpleado(Empleado empleado) {
        Sesion.empleado = empleado;
    }

    public static Cliente getCliente() {
        return cliente;
    }

    public static void setCliente(Cliente cliente) {
        Sesion.cliente = cliente;
    }

    public static Factura getFactura() {
        return factura;
    }

    public static void setFactura(Factura factura) {
        Sesion.factura = factura;
    }

    public static ArrayList<Venta_Producto> getListaProductosV() {
        return listaProductosV;
    }

    public static void setListaProductosV(ArrayList<Venta_Producto> listaProductosV) {
        Sesion.listaProductosV = listaProductosV;
    }

    public static List<Producto> getListaProductos() {
        return LISTAPRODUCTOS;
    }

    public static int getCostoProducto(int id){
        for(Producto p : LISTAPRODUCTOS){
            if(p.getId() == id){
                return p.getPrecio_unidad();
            }
        }
        return 0;
    }
    
}
