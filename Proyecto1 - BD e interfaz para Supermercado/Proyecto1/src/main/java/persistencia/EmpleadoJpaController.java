package persistencia;

import clases.Empleado;
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
public class EmpleadoJpaController implements Serializable {

    private EntityManagerFactory emf = null;
    
    public EmpleadoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    public EmpleadoJpaController() {
        this.emf = Persistence.createEntityManagerFactory("DB_PULPERIA");
    }
    public EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    

    
    public void create(Empleado Empleado){
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(Empleado);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public void edit(Empleado Empleado) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Empleado = em.merge(Empleado);
            em.getTransaction().commit();
        } catch (Exception ex){
            String msg = ex.getLocalizedMessage();
            if(msg == null || msg.length() == 0){
                int id_Empleado = Empleado.getId();
                if(findEmpleado(id_Empleado) == null){
                    throw new NonexistentEntityException("The Empleado with id_Empleado" + id_Empleado + "no longer exists.");
                }
            }
            throw ex;
        } finally {
            if(em != null){
                em.close();
            }
        }
    }
    
    public void destroy(int id_Empleado) throws NonexistentEntityException{
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Empleado Empleado;
            try {
                Empleado = em.getReference(Empleado.class, id_Empleado);
                Empleado.getId();
            } catch (EntityNotFoundException enfe){
                throw new NonexistentEntityException("The Empleado with id_Empleado" + id_Empleado + "no longer exists.", enfe);
            }
            em.remove(Empleado);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public List<Empleado> findEmpleadoEntities(){
        return findEmpleadoEntities(true, -1, -1);
    }
    
    public List<Empleado> findEmpleadoEntities(int maxResutls, int firstResult){
        return findEmpleadoEntities(false, maxResutls, firstResult);
    }
    
    public List<Empleado> findEmpleadoEntities(boolean all, int maxResults, int firstResult){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Empleado.class));
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
    
    public Empleado findEmpleado(int id_Empleado){
        EntityManager em = getEntityManager();
        try {
            return em.find(Empleado.class, id_Empleado);
        } finally {
            em.close();
        }
    }
    
    public int getUserCount(){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Empleado> rt = cq.from(Empleado.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}