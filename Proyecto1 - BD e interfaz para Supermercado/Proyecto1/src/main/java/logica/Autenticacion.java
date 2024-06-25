package logica;
import clases.Usuario;

public class Autenticacion {

    public static boolean validarAcceso(Usuario caja, String cont){
        return cont.equals(caja.getContrasena());

    }
   


}
