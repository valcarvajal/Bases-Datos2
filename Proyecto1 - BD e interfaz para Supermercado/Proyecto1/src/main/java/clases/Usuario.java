package clases;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Usuario implements Serializable{
    
    @Id
    @GeneratedValue
    private int id_empleado;
    private String contrasena;

    public Usuario() {
    }

    public Usuario(int id_empleado, String contrasena) {
        this.id_empleado = id_empleado;
        this.contrasena = contrasena;
    }
    public Usuario(String contrasena) {
        this.contrasena = contrasena;
    }
    public int getid_empleado() {
        return id_empleado;
    }

    public void setid_empleado(int id_empleado) {
        this.id_empleado = id_empleado;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }
    
    
    
    
    
}
