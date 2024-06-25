package servlets;
import clases.Cliente;
import clases.Cliente;
import clases.Factura;
import clases.Producto;
import clases.Usuario;
import clases.Venta_Producto;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import logica.ControladoraC;
import logica.ControladoraF;
import logica.Sesion;


@WebServlet(name = "SvCliente", urlPatterns = {"/SvCliente"})
public class SvCliente extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ControladoraC controlC = new ControladoraC();
        ControladoraF controlF = new ControladoraF();
        
        try {
            int id_cliente = Integer.parseInt(request.getParameter("id_cliente"));
            int id_empleado = Sesion.getEmpleado().getId();
            Cliente cliente = controlC.traerCliente(id_cliente);
            Sesion.setCliente(cliente);
            
            Factura factura = new Factura();
            factura.setId_cliente(id_cliente);
            factura.setId_cajero(id_empleado);
              
            controlF.crearFactura(factura);    
            
            HttpSession miSesion = request.getSession();
            miSesion.setAttribute("total", 0);
            response.sendRedirect("facturacion.jsp");

        } catch (Exception ex) {
            response.sendRedirect("prefacturacion.jsp");
        }
        

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
