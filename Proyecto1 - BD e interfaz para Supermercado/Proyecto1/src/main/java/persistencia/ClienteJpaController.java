package persistencia;

import clases.Cliente;
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

/**
 *
 * @author mrion
 */
public class ClienteJpaController implements Serializable {

    private EntityManagerFactory emf = null;
    
    public ClienteJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    public ClienteJpaController() {
        this.emf = Persistence.createEntityManagerFactory("DB_PULPERIA");
    }
    public EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    

    
    public void create(Cliente Cliente){
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(Cliente);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public void edit(Cliente Cliente) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Cliente = em.merge(Cliente);
            em.getTransaction().commit();
        } catch (Exception ex){
            String msg = ex.getLocalizedMessage();
            if(msg == null || msg.length() == 0){
                int id_Cliente = Cliente.getId();
                if(findCliente(id_Cliente) == null){
                    throw new NonexistentEntityException("The Cliente with id_Cliente" + id_Cliente + "no longer exists.");
                }
            }
            throw ex;
        } finally {
            if(em != null){
                em.close();
            }
        }
    }
    
    public void destroy(int id_Cliente) throws NonexistentEntityException{
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Cliente Cliente;
            try {
                Cliente = em.getReference(Cliente.class, id_Cliente);
                Cliente.getId();
            } catch (EntityNotFoundException enfe){
                throw new NonexistentEntityException("The Cliente with id_Cliente" + id_Cliente + "no longer exists.", enfe);
            }
            em.remove(Cliente);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public List<Cliente> findClienteEntities(){
        return findClienteEntities(true, -1, -1);
    }
    
    public List<Cliente> findClienteEntities(int maxResutls, int firstResult){
        return findClienteEntities(false, maxResutls, firstResult);
    }
    
    public List<Cliente> findClienteEntities(boolean all, int maxResults, int firstResult){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Cliente.class));
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
    
    public Cliente findCliente(int id_Cliente){
        EntityManager em = getEntityManager();
        try {
            return em.find(Cliente.class, id_Cliente);
        } finally {
            em.close();
        }
    }
    
    public int getUserCount(){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Cliente> rt = cq.from(Cliente.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}