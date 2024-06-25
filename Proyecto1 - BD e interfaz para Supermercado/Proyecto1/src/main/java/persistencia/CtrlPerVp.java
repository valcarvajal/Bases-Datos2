package persistencia;

import clases.Venta_Producto;
import persistencia.exceptions.NonexistentEntityException;

public class CtrlPerVp {
    private Venta_ProductoJpaController VpJpa = new Venta_ProductoJpaController();
    
    public void crearVp(Venta_Producto nuevo_vp) {
        VpJpa.create(nuevo_vp);
    }

    public void eliminarVps(int id_factura) throws NonexistentEntityException {
        VpJpa.destroy(id_factura);
    }
    
}
