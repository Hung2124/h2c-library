package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.Author;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class AuthorRepository {

    public List<Author> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM Author a ORDER BY a.name", Author.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Author> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Author.class, id));
        } finally {
            em.close();
        }
    }

    public Author save(Author author) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (author.getId() == null) {
                em.persist(author);
            } else {
                author = em.merge(author);
            }
            em.getTransaction().commit();
            return author;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Author a = em.find(Author.class, id);
            if (a != null) em.remove(a);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public long count() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(a) FROM Author a", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }
}
