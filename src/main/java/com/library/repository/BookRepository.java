package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.Book;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class BookRepository {

    public Optional<Book> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(
                    em.createQuery("SELECT DISTINCT b FROM Book b " +
                            "LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                            "WHERE b.id = :id", Book.class)
                            .setParameter("id", id)
                            .getResultList().stream().findFirst().orElse(null));
        } finally {
            em.close();
        }
    }

    public long countWithFilters(String keyword, Long categoryId, Long authorId,
                                  Integer publishYear, String language, Boolean available,
                                  String bookStatus, Long publisherId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT COUNT(b) FROM Book b WHERE 1=1");
            appendFilters(jpql, keyword, categoryId, authorId, publishYear, language, available, bookStatus, publisherId);
            TypedQuery<Long> q = em.createQuery(jpql.toString(), Long.class);
            bindParams(q, keyword, categoryId, authorId, publishYear, language, available, bookStatus, publisherId);
            return q.getSingleResult();
        } finally {
            em.close();
        }
    }

    public List<Book> findWithFilters(String keyword, Long categoryId, Long authorId,
                                       Integer publishYear, String language, Boolean available,
                                       String bookStatus, Long publisherId,
                                       String sort, int offset, int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT DISTINCT b FROM Book b " +
                    "LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher WHERE 1=1");
            appendFilters(jpql, keyword, categoryId, authorId, publishYear, language, available, bookStatus, publisherId);
            appendSort(jpql, sort);

            TypedQuery<Book> q = em.createQuery(jpql.toString(), Book.class);
            bindParams(q, keyword, categoryId, authorId, publishYear, language, available, bookStatus, publisherId);
            q.setFirstResult(offset);
            q.setMaxResults(limit);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Book> findNewBooks(int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT b FROM Book b LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                    "WHERE b.status = 'AVAILABLE' ORDER BY b.createdAt DESC", Book.class)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Book> findMostBorrowed(int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT b FROM Book b LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                    "WHERE b.status = 'AVAILABLE' " +
                    "ORDER BY (b.quantity - b.availableQuantity) DESC", Book.class)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Book> findByCategory(Long categoryId, int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT b FROM Book b LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                    "WHERE b.category.id = :catId AND b.status = 'AVAILABLE' " +
                    "ORDER BY b.createdAt DESC", Book.class)
                    .setParameter("catId", categoryId)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Book> findSimilar(Long bookId, Long categoryId, Long authorId, int limit) {
        if (categoryId == null && authorId == null) {
            return List.of();
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT b FROM Book b LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                    "WHERE b.id != :bookId AND b.status = 'AVAILABLE' ");
            if (categoryId != null && authorId != null) {
                jpql.append("AND (b.category.id = :catId OR b.author.id = :authorId) ");
            } else if (categoryId != null) {
                jpql.append("AND b.category.id = :catId ");
            } else {
                jpql.append("AND b.author.id = :authorId ");
            }
            jpql.append("ORDER BY b.createdAt DESC");
            var q = em.createQuery(jpql.toString(), Book.class).setParameter("bookId", bookId);
            if (categoryId != null) q.setParameter("catId", categoryId);
            if (authorId != null) q.setParameter("authorId", authorId);
            return q.setMaxResults(limit).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Book> findAll(int offset, int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT b FROM Book b LEFT JOIN FETCH b.author LEFT JOIN FETCH b.category LEFT JOIN FETCH b.publisher " +
                    "ORDER BY b.createdAt DESC", Book.class)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long countAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(b) FROM Book b", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public Book save(Book book) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (book.getId() == null) {
                em.persist(book);
            } else {
                book = em.merge(book);
            }
            em.getTransaction().commit();
            return book;
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
            Book b = em.find(Book.class, id);
            if (b != null) em.remove(b);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public long countBorrowDetailsByBookId(Long bookId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(d) FROM BorrowRequestDetail d WHERE d.book.id = :bid", Long.class)
                    .setParameter("bid", bookId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countByCategoryId(Long categoryId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(b) FROM Book b WHERE b.category.id = :cid", Long.class)
                    .setParameter("cid", categoryId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countByAuthorId(Long authorId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(b) FROM Book b WHERE b.author.id = :aid", Long.class)
                    .setParameter("aid", authorId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    // ---- helper methods ----

    private void appendFilters(StringBuilder jpql, String keyword, Long categoryId, Long authorId,
                                 Integer publishYear, String language, Boolean available,
                                 String bookStatus, Long publisherId) {
        if (keyword != null && !keyword.isBlank()) {
            jpql.append(" AND LOWER(b.title) LIKE :keyword");
        }
        if (categoryId != null) {
            jpql.append(" AND b.category.id = :categoryId");
        }
        if (authorId != null) {
            jpql.append(" AND b.author.id = :authorId");
        }
        if (publishYear != null) {
            jpql.append(" AND b.publishYear = :publishYear");
        }
        if (language != null && !language.isBlank()) {
            jpql.append(" AND b.language = :language");
        }
        if (Boolean.TRUE.equals(available)) {
            jpql.append(" AND b.availableQuantity > 0 AND b.status = 'AVAILABLE'");
        }
        if (bookStatus != null && !bookStatus.isBlank()) {
            jpql.append(" AND b.status = :bookStatus");
        }
        if (publisherId != null) {
            jpql.append(" AND b.publisher.id = :publisherId");
        }
    }

    private void appendSort(StringBuilder jpql, String sort) {
        if ("title_asc".equals(sort)) {
            jpql.append(" ORDER BY b.title ASC");
        } else if ("most_borrowed".equals(sort)) {
            jpql.append(" ORDER BY (b.quantity - b.availableQuantity) DESC");
        } else {
            jpql.append(" ORDER BY b.createdAt DESC");
        }
    }

    private <T> void bindParams(TypedQuery<T> q, String keyword, Long categoryId, Long authorId,
                                  Integer publishYear, String language, Boolean available,
                                  String bookStatus, Long publisherId) {
        if (keyword != null && !keyword.isBlank()) {
            q.setParameter("keyword", "%" + keyword.toLowerCase() + "%");
        }
        if (categoryId != null) q.setParameter("categoryId", categoryId);
        if (authorId != null) q.setParameter("authorId", authorId);
        if (publishYear != null) q.setParameter("publishYear", publishYear);
        if (language != null && !language.isBlank()) q.setParameter("language", language);
        if (bookStatus != null && !bookStatus.isBlank()) q.setParameter("bookStatus", bookStatus);
        if (publisherId != null) q.setParameter("publisherId", publisherId);
    }
}
