package logica;
import clases.Empleado;
import persistencia.CtrlPerE;

public class ControladoraE {
    private CtrlPerE control = new CtrlPerE();
    
    public Empleado traerEmpleado(int id) {
        return control.traerEmpleado(id);
    }
}
