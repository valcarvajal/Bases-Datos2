package logica;

import clases.Factura;
import java.util.List;
import persistencia.CtrlPerF;

public class ControladoraF {
    private CtrlPerF control = new CtrlPerF();
    
    public void crearFactura(Factura factura){
        Sesion.setFactura(factura);
        control.crearFactura(factura);
    }
    
    public void borrarFactura() {
        control.borrarFactura();
    }
    
    public void editarFactura(Factura factura) {
        control.editarFactura(factura);
    }
    
    public void editarFactura(Factura factura, int sumar) {
        int actual = factura.getTotal();
        factura.setTotal(actual + sumar);
        control.editarFactura(factura);
    }
    
    public Factura traerFactura(int id) {
        return control.traerFactura(id);
    }
    
    public List<Factura> traerFacturas(){
        return control.traerFacturas();
    }
}
