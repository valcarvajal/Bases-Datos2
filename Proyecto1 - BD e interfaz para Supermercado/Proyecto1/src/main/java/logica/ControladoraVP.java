package logica;

import clases.Venta_Producto;
import persistencia.CtrlPerVp;
import persistencia.exceptions.NonexistentEntityException;

public class ControladoraVP {
    private CtrlPerVp control = new CtrlPerVp();
    
    public void crearVp(Venta_Producto nuevo_vp) {
        control.crearVp(nuevo_vp);
    }
    
    public void eliminarVps() throws NonexistentEntityException{
        int id_factura = Sesion.getFactura().getId_factura();
        control.eliminarVps(id_factura);
    }
    
}
