package persistencia;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.Persistence;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import clases.Factura;
import persistencia.exceptions.NonexistentEntityException;
      
      
public class FacturaJpaController implements Serializable {

    private EntityManagerFactory emf = null;
    
    public FacturaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    public FacturaJpaController() {
        this.emf = Persistence.createEntityManagerFactory("DB_PULPERIA");
    }
    public EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    

    
    public void create(Factura factura){
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(factura);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public void edit(Factura factura) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            factura = em.merge(factura);
            em.getTransaction().commit();
        } catch (Exception ex){
            String msg = ex.getLocalizedMessage();
            if(msg == null || msg.length() == 0){
                int Id_factura = factura.getId_factura();
                if(findFactura(Id_factura) == null){
                    throw new NonexistentEntityException("The factura with id " + Id_factura + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if(em != null){
                em.close();
            }
        }
    }
    
    public void destroy(int id_Factura) throws NonexistentEntityException{
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            try {
                String StrF = "DELETE FROM Factura WHERE id_factura=" + String.valueOf(id_Factura);
                em.createNativeQuery(StrF).executeUpdate();
            } catch (EntityNotFoundException enfe){
                throw new NonexistentEntityException("The factura with id " + id_Factura + " no longer exists.", enfe);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public List<Factura> findFacturaEntities(){
        return findFacturaEntities(true, -1, -1);
    }
    
    public List<Factura> findFacturaEntities(int maxResutls, int firstResult){
        return findFacturaEntities(false, maxResutls, firstResult);
    }
    
    public List<Factura> findFacturaEntities(boolean all, int maxResults, int firstResult){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Factura.class));
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
    
    public Factura findFactura(int Id_factura){
        EntityManager em = getEntityManager();
        try {
            return em.find(Factura.class, Id_factura);
        } finally {
            em.close();
        }
    }
    
    public int getFacturaCount(){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Factura> rt = cq.from(Factura.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
