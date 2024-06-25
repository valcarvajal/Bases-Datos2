package persistencia;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import clases.Usuario;
import persistencia.exceptions.NonexistentEntityException;

public class CtrlPerU {
    UsuarioJpaController usuJpa = new UsuarioJpaController();
    
    public void crearUsuario(Usuario usuario){
        usuJpa.create(usuario);
    }
    
    public List<Usuario> traerUsuarios(){
        return usuJpa.findUsuarioEntities();
    }

    public void borrarUsuario(int id_empleado) {
        try {
            usuJpa.destroy(id_empleado);
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(CtrlPerU.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Usuario traerUsuario(int id_editar) {
        return usuJpa.findUsuario(id_editar);
    }

    public void editarUsuario(Usuario usuario) {
        try {
            usuJpa.edit(usuario);
        } catch (Exception ex) {
            Logger.getLogger(CtrlPerU.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
}
