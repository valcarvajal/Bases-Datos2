package servlets;

import clases.Empleado;
import clases.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.Autenticacion;
import logica.ControladoraE;
import logica.ControladoraU;
import logica.Sesion;

@WebServlet(name = "SvCaja", urlPatterns = {"/SvCaja"})
public class SvCaja extends HttpServlet {
    ControladoraU controlU = new ControladoraU();
    ControladoraE controlE = new ControladoraE();
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cont = request.getParameter("contrasena");
        try {
            int id_empleado = Integer.parseInt(request.getParameter("id_empleado"));
            Usuario usuario = controlU.traerUsuario(id_empleado);
            
            if(usuario != null || !Autenticacion.validarAcceso(usuario, cont)){
                response.sendRedirect("falloCredencial.jsp");
            } else {
                HttpSession miSesion = request.getSession();
                Empleado empleado = controlE.traerEmpleado(id_empleado);
                Sesion.setEmpleado(empleado);
                response.sendRedirect("prefacturacion.jsp");
            }
        } catch (Exception ex) {
            response.sendRedirect("falloCredencial.jsp");
        }
        

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
