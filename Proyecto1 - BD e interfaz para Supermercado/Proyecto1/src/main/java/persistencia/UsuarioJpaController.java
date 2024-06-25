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
import clases.Usuario;
import persistencia.exceptions.NonexistentEntityException;
      
      
public class UsuarioJpaController implements Serializable {

    private EntityManagerFactory emf = null;
    
    public UsuarioJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    public UsuarioJpaController() {
        this.emf = Persistence.createEntityManagerFactory("DB_PULPERIA");
    }
    public EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    

    
    public void create(Usuario usuario){
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(usuario);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public void edit(Usuario usuario) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            usuario = em.merge(usuario);
            em.getTransaction().commit();
        } catch (Exception ex){
            String msg = ex.getLocalizedMessage();
            if(msg == null || msg.length() == 0){
                int id_Empleado = usuario.getid_empleado();
                if(findUsuario(id_Empleado) == null){
                    throw new NonexistentEntityException("The usuario with id_Empleado" + id_Empleado + "no longer exists.");
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
            Usuario usuario;
            try {
                usuario = em.getReference(Usuario.class, id_Empleado);
                usuario.getid_empleado();
            } catch (EntityNotFoundException enfe){
                throw new NonexistentEntityException("The usuario with id_Empleado" + id_Empleado + "no longer exists.", enfe);
            }
            em.remove(usuario);
            em.getTransaction().commit();
        } finally {
            if (em != null){
                em.close();
            }
        }
    }
    
    public List<Usuario> findUsuarioEntities(){
        return findUsuarioEntities(true, -1, -1);
    }
    
    public List<Usuario> findUsuarioEntities(int maxResutls, int firstResult){
        return findUsuarioEntities(false, maxResutls, firstResult);
    }
    
    public List<Usuario> findUsuarioEntities(boolean all, int maxResults, int firstResult){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Usuario.class));
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
    
    public Usuario findUsuario(int id_Empleado){
        EntityManager em = getEntityManager();
        try {
            return em.find(Usuario.class, id_Empleado);
        } finally {
            em.close();
        }
    }
    
    public int getUsuarioCount(){
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Usuario> rt = cq.from(Usuario.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
