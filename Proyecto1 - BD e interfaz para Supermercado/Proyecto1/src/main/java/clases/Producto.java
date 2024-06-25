package clases;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Producto implements Serializable{
    
    @Id
    @GeneratedValue
    private int id;
    private String nombre;
    private int precio_unidad;
    
    public Producto() {
    }

    public Producto(int id, String nombre, int precio_unidad) {
        this.id = id;
        this.nombre = nombre;
        this.precio_unidad = precio_unidad;
    }

    
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getPrecio_unidad() {
        return precio_unidad;
    }

    public void setPrecio_unidad(int precio_unidad) {
        this.precio_unidad = precio_unidad;
    }
    
    
}
