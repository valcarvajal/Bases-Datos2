package clases;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Venta_Producto implements Serializable{
    @Id
    @GeneratedValue
    private int id_factura;
    private int id_producto;
    private int precio_venta;
    private int cantidad;

    public Venta_Producto() {
    }

    public Venta_Producto(int id_factura, int id_producto, int precio_venta, int cantidad) {
        this.id_factura = id_factura;
        this.id_producto = id_producto;
        this.precio_venta = precio_venta;
        this.cantidad = cantidad;
    }

    
    
    public int getId_factura() {
        return id_factura;
    }

    public void setId_factura(int id_factura) {
        this.id_factura = id_factura;
    }

    public int getId_producto() {
        return id_producto;
    }

    public void setId_producto(int id_producto) {
        this.id_producto = id_producto;
    }

    public int getPrecio_venta() {
        return precio_venta;
    }

    public void setPrecio_venta(int precio_venta) {
        this.precio_venta = precio_venta;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }
}
