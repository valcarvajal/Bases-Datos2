package clases;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import logica.Sesion;

@Entity
public class Factura implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "factura_seq")
    private int id_factura;
    private LocalDate fecha;
    private String hora;
    private int id_cliente;
    private int id_cajero;
    private int total;

    public Factura() {
        this.fecha = LocalDate.now();
        
        LocalDateTime currentDateTime = LocalDateTime.now();
        
        int hora = currentDateTime.getHour();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        
        this.hora = formatter.format(currentDateTime);
        
    }

    public Factura(int id_factura, LocalDate fecha, String hora, int id_cliente, int id_cajero, int total) {
        this.id_factura = id_factura;
        this.fecha = fecha;
        this.hora = hora;
        this.id_cliente = id_cliente;
        this.id_cajero = id_cajero;
        this.total = total;
        
    }
    
    public Factura(int id_factura, LocalDate fecha, int hora, int id_cliente, int id_cajero, int total) {
        this.id_factura = id_factura;
        this.fecha = fecha;
        this.hora = String.valueOf(hora);
        this.id_cliente = id_cliente;
        this.id_cajero = id_cajero;
        this.total = total;
        
    }

    public int getId_factura() {
        return id_factura;
    }

    public void setId_factura(int id_factura) {
        this.id_factura = id_factura;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public String getHora() {
        return hora;
    }

    public void setHora(String hora) {
        this.hora = hora;
    }


    public int getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(int id_cliente) {
        this.id_cliente = id_cliente;
    }

    public int getId_cajero() {
        return id_cajero;
    }

    public void setId_cajero(int id_cajero) {
        this.id_cajero = id_cajero;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    
    
}
