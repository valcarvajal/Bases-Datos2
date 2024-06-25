package logica;

import clases.Cliente;
import persistencia.CtrlPerC;

public class ControladoraC {
    private CtrlPerC control = new CtrlPerC();
    
    public Cliente traerCliente(int id) {
        return control.traerCliente(id);
    }
}
