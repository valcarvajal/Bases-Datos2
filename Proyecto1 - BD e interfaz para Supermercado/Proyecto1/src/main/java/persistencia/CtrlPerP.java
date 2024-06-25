package persistencia;

import clases.Producto;
import java.util.List;

public class CtrlPerP {
    ProductoJpaController proJpa = new ProductoJpaController();

    public List<Producto> traerProductos(){
        return proJpa.findProductoEntities();
    }
}
