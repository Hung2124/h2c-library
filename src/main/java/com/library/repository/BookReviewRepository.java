package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.BookReview;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class BookReviewRepository {

    public List<BookReview> findByBookId(Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT r FROM BookReview r JOIN FETCH r.user WHERE r.book.id = :bid ORDER BY r.createdAt DESC",
                    BookReview.class)
                    .setParameter("bid", bookId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<BookReview> findByUserAndBook(Long userId, Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<BookReview> q = em.createQuery(
                    "SELECT r FROM BookReview r WHERE r.user.id = :uid AND r.book.id = :bid",
                    BookReview.class);
            q.setParameter("uid", userId);
            q.setParameter("bid", bookId);
            List<BookReview> list = q.getResultList();
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } finally {
            em.close();
        }
    }

    public Double averageRating(Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Double avg = em.createQuery(
                    "SELECT AVG(r.rating) FROM BookReview r WHERE r.book.id = :bid", Double.class)
                    .setParameter("bid", bookId)
                    .getSingleResult();
            return avg == null ? null : avg;
        } finally {
            em.close();
        }
    }

    public long countByBookId(Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(r) FROM BookReview r WHERE r.book.id = :bid", Long.class)
                    .setParameter("bid", bookId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    public BookReview save(BookReview review) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (review.getUser() != null && review.getUser().getId() != null) {
                review.setUser(em.getReference(com.library.model.User.class, review.getUser().getId()));
            }
            if (review.getBook() != null && review.getBook().getId() != null) {
                review.setBook(em.getReference(com.library.model.Book.class, review.getBook().getId()));
            }
            if (review.getId() == null) {
                em.persist(review);
            } else {
                review = em.merge(review);
            }
            em.getTransaction().commit();
            return review;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /** User đã/đang mượn sách: có dòng chi tiết với book_id và yêu cầu duyệt + trạng thái dòng phù hợp */
    public boolean hasUserEligibleToReview(Long userId, Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long n = em.createQuery(
                    "SELECT COUNT(d) FROM BorrowRequestDetail d JOIN d.borrowRequest br " +
                    "WHERE br.user.id = :uid AND d.book.id = :bid " +
                    "AND br.status IN ('APPROVED','RETURNED') " +
                    "AND (d.status IN ('BORROWING','OVERDUE') OR d.returnDate IS NOT NULL)",
                    Long.class)
                    .setParameter("uid", userId)
                    .setParameter("bid", bookId)
                    .getSingleResult();
            return n != null && n > 0;
        } finally {
            em.close();
        }
    }
}
