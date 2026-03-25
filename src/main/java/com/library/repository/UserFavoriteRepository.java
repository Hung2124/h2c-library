package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.Book;
import com.library.model.UserFavorite;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class UserFavoriteRepository {

    public boolean exists(Long userId, Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long c = em.createQuery(
                    "SELECT COUNT(f) FROM UserFavorite f WHERE f.user.id = :uid AND f.book.id = :bid",
                    Long.class)
                    .setParameter("uid", userId)
                    .setParameter("bid", bookId)
                    .getSingleResult();
            return c > 0;
        } finally {
            em.close();
        }
    }

    public void add(Long userId, Long bookId) {
        if (exists(userId, bookId)) return;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            var u = em.getReference(com.library.model.User.class, userId);
            var b = em.getReference(Book.class, bookId);
            UserFavorite f = new UserFavorite();
            f.setUser(u);
            f.setBook(b);
            em.persist(f);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void remove(Long userId, Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            List<UserFavorite> list = em.createQuery(
                    "SELECT f FROM UserFavorite f WHERE f.user.id = :uid AND f.book.id = :bid",
                    UserFavorite.class)
                    .setParameter("uid", userId)
                    .setParameter("bid", bookId)
                    .getResultList();
            for (UserFavorite f : list) {
                em.remove(em.contains(f) ? f : em.merge(f));
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Book> findBooksByUserId(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<UserFavorite> favs = em.createQuery(
                    "SELECT f FROM UserFavorite f " +
                    "JOIN FETCH f.book b " +
                    "LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                    "WHERE f.user.id = :uid ORDER BY f.createdAt DESC",
                    UserFavorite.class)
                    .setParameter("uid", userId)
                    .getResultList();
            return favs.stream().map(UserFavorite::getBook).toList();
        } finally {
            em.close();
        }
    }

    public Optional<UserFavorite> findOne(Long userId, Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<UserFavorite> list = em.createQuery(
                    "SELECT f FROM UserFavorite f WHERE f.user.id = :uid AND f.book.id = :bid",
                    UserFavorite.class)
                    .setParameter("uid", userId)
                    .setParameter("bid", bookId)
                    .setMaxResults(1)
                    .getResultList();
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } finally {
            em.close();
        }
    }
}
