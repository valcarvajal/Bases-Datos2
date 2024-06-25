package logica;
import clases.Usuario;
import java.util.List;
import persistencia.CtrlPerU;

public class ControladoraU {
    private CtrlPerU control = new CtrlPerU();
    
    public void crearUsuario(Usuario usuario){
        control.crearUsuario(usuario);
    }
    
    public void borrarUsuario(int id_empleado) {
        control.borrarUsuario(id_empleado);
    }

    public void editarUsuario(Usuario usuario) {
        control.editarUsuario(usuario);
    }
    
    public Usuario traerUsuario(int id) {
        return control.traerUsuario(id);
    }
    
    public List<Usuario> traerUsuarios(){
        return control.traerUsuarios();
    }

}
