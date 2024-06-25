package persistencia;

import clases.Venta_Producto;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import persistencia.exceptions.NonexistentEntityException;

public class Venta_ProductoJpaController implements Serializable {
    
    private EntityManagerFactory emf = null;
    
    public Venta_ProductoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    public Venta_ProductoJpaController() {
        this.emf = Persistence.createEntityManagerFactory("DB_PULPERIA");
    }
    public EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    

    
    public void create(Venta_Producto Venta_Producto){
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(Venta_Producto);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public void edit(Venta_Producto Venta_Producto) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Venta_Producto = em.merge(Venta_Producto);
            em.getTransaction().commit();
        } catch (Exception ex){
            String msg = ex.getLocalizedMessage();
            if(msg == null || msg.length() == 0){
                int id_factura = Venta_Producto.getId_factura();
                if(findVenta_Producto(id_factura) == null){
                    throw new NonexistentEntityException("The Venta_Producto with id_factura" + id_factura + "no longer exists.");
                }
            }
            throw ex;
        } finally {
            if(em != null){
                em.close();
            }
        }
    }
    
    public void destroy(int id_factura) throws NonexistentEntityException{
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            try {
                String StrVP = "DELETE FROM venta_producto WHERE id_factura=" + String.valueOf(id_factura);
                em.createNativeQuery(StrVP).executeUpdate();
            } catch (EntityNotFoundException enfe){
                throw new NonexistentEntityException("The Venta_Producto with id_factura" + id_factura + "no longer exists.", enfe);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public List<Venta_Producto> findVenta_ProductoEntities(){
        return findVenta_ProductoEntities(true, -1, -1);
    }
    
    public List<Venta_Producto> findVenta_ProductoEntities(int maxResutls, int firstResult){
        return findVenta_ProductoEntities(false, maxResutls, firstResult);
    }
    
    public List<Venta_Producto> findVenta_ProductoEntities(boolean all, int maxResults, int firstResult){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Venta_Producto.class));
            Query q = em.createQuery(cq);
            if(!all){
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Venta_Producto findVenta_Producto(int id_factura){
        EntityManager em = getEntityManager();
        try {
            return em.find(Venta_Producto.class, id_factura);
        } finally {
            em.close();
        }
    }
    
    public int getVenta_ProductoCount(){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Venta_Producto> rt = cq.from(Venta_Producto.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
