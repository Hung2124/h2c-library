package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.Publisher;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class PublisherRepository {

    public List<Publisher> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Publisher p ORDER BY p.name", Publisher.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Publisher> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Publisher.class, id));
        } finally {
            em.close();
        }
    }

    /** Tìm theo tên (đúng chuỗi, đã trim) — dùng kiểm tra trùng UNIQUE */
    public Optional<Publisher> findByName(String name) {
        if (name == null || name.isBlank()) {
            return Optional.empty();
        }
        String n = name.trim();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Publisher> list = em.createQuery(
                            "SELECT p FROM Publisher p WHERE p.name = :n", Publisher.class)
                    .setParameter("n", n)
                    .setMaxResults(1)
                    .getResultList();
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } finally {
            em.close();
        }
    }

    /**
     * Chuyển mọi sách từ NXB trùng sang NXB chuẩn rồi xóa bản ghi trùng.
     * Dùng khi sửa tên bản lỗi thành tên đã tồn tại (tránh lỗi UNIQUE / 500).
     */
    public void mergePublisherInto(Long duplicateId, Long canonicalId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Publisher canonical = em.find(Publisher.class, canonicalId);
            Publisher duplicate = em.find(Publisher.class, duplicateId);
            if (canonical == null || duplicate == null) {
                em.getTransaction().rollback();
                throw new IllegalArgumentException("Publisher not found for merge");
            }
            em.createQuery("UPDATE Book b SET b.publisher = :c WHERE b.publisher = :d")
                    .setParameter("c", canonical)
                    .setParameter("d", duplicate)
                    .executeUpdate();
            em.remove(duplicate);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public Publisher save(Publisher publisher) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (publisher.getId() == null) {
                em.persist(publisher);
            } else {
                publisher = em.merge(publisher);
            }
            em.getTransaction().commit();
            return publisher;
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
            Publisher p = em.find(Publisher.class, id);
            if (p != null) em.remove(p);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public long countBooksByPublisherId(Long publisherId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(b) FROM Book b WHERE b.publisher.id = :pid", Long.class)
                    .setParameter("pid", publisherId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }
}
