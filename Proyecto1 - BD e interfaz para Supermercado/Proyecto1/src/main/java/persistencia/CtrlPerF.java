package persistencia;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import clases.Factura;
import logica.Sesion;
import persistencia.exceptions.NonexistentEntityException;

public class CtrlPerF {
    FacturaJpaController facJpa = new FacturaJpaController();
    
    public void crearFactura(Factura factura){
        facJpa.create(factura);
    }
    
    public List<Factura> traerFacturas(){
        return facJpa.findFacturaEntities();
    }

    public void borrarFactura() {
        try {
            facJpa.destroy(Sesion.getFactura().getId_factura());
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(CtrlPerF.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Factura traerFactura(int id_editar) {
        return facJpa.findFactura(id_editar);
    }

    public void editarFactura(Factura factura) {
        try {
            facJpa.edit(factura);
        } catch (Exception ex) {
            Logger.getLogger(CtrlPerF.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
}
