package servlets;

import clases.Venta_Producto;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import logica.ControladoraF;
import logica.ControladoraVP;
import logica.Sesion;
import persistencia.exceptions.NonexistentEntityException;

@WebServlet(name = "SvFactura", urlPatterns = {"/SvFactura"})
public class SvFactura extends HttpServlet {
    ControladoraF controlF = new ControladoraF();
    ControladoraVP controlVp = new ControladoraVP();

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    // Borrar factura
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            controlVp.eliminarVps();
            controlF.borrarFactura();
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(SvFactura.class.getName()).log(Level.SEVERE, null, ex);
        }
        Sesion.setListaProductosV(new ArrayList<Venta_Producto>());
        Sesion.setFactura(null);
        response.sendRedirect("index.jsp");

    }

        
    

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
