package persistencia;

import clases.Empleado;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import persistencia.exceptions.NonexistentEntityException;

public class CtrlPerE {
    EmpleadoJpaController empJpaC = new EmpleadoJpaController();
    
    public void crearEmpleado(Empleado empleado){
        empJpaC.create(empleado);
    }
    
    public List<Empleado> traerEmpleados(){
        return empJpaC.findEmpleadoEntities();
    }

    public void borrarEmpleado(int id_empleado) {
        try {
            empJpaC.destroy(id_empleado);
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(CtrlPerU.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Empleado traerEmpleado(int id) {
        return empJpaC.findEmpleado(id);
    }

    public void editarEmpleado(Empleado empleado) {
        try {
            empJpaC.edit(empleado);
        } catch (Exception ex) {
            Logger.getLogger(CtrlPerU.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
