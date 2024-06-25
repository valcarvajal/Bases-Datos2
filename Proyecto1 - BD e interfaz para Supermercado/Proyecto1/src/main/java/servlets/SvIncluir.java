package servlets;
import clases.Venta_Producto;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import logica.ControladoraF;
import logica.ControladoraVP;
import logica.Sesion;

@WebServlet(name = "SvIncluir", urlPatterns = {"/SvIncluir"})
public class SvIncluir extends HttpServlet {
    private ControladoraF controlF = new ControladoraF();
    private ControladoraVP controlVp = new ControladoraVP();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id_factura = Sesion.getFactura().getId_factura();
        int id_producto = Integer.parseInt(request.getParameter("id_prod"));
        int cant = Integer.parseInt(request.getParameter("cant"));
        ArrayList<Venta_Producto> listaProductosV = Sesion.getListaProductosV();
        int total = Sesion.getCostoProducto(id_producto) * cant;
        Venta_Producto nuevo_vp = new Venta_Producto(id_factura, id_producto, total,cant);

        listaProductosV.add(nuevo_vp);
        Sesion.setListaProductosV(listaProductosV);
        
        controlF.editarFactura(Sesion.getFactura(), total);
        controlVp.crearVp(nuevo_vp);

        response.sendRedirect("facturacion.jsp");
    }

    @Override
    public String toString() {
        return "SvIncluir{" + '}';
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
