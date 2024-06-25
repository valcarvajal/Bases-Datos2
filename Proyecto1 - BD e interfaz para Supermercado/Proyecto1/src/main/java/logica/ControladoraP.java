package logica;

import clases.Producto;
import java.util.List;
import persistencia.CtrlPerP;

/**
 *
 * @author mrion
 */
public class ControladoraP {
    private CtrlPerP control = new CtrlPerP();
    
    public List<Producto> traerProductos(){
        return control.traerProductos();
    }
}
