package persistencia;

import clases.Cliente;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CtrlPerC {
    ClienteJpaController empJpaE = new ClienteJpaController();
    
    public void crearCliente(Cliente Cliente){
        empJpaE.create(Cliente);
    }
    
    public List<Cliente> traerClientes(){
        return empJpaE.findClienteEntities();
    }

    public Cliente traerCliente(int id) {
        return empJpaE.findCliente(id);
    }

    public void editarCliente(Cliente Cliente) {
        try {
            empJpaE.edit(Cliente);
        } catch (Exception ex) {
            Logger.getLogger(CtrlPerU.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
