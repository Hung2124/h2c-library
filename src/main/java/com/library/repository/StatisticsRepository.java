package com.library.repository;

import com.library.config.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;

public class StatisticsRepository {

    public long countTotalBooks() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(b) FROM Book b", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countTotalUsers() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'MEMBER'", Long.class)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countBorrowedBooks() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COALESCE(SUM(d.quantity), 0) FROM BorrowRequestDetail d " +
                    "WHERE d.status = 'BORROWING'", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countOverdueBooks() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(d) FROM BorrowRequestDetail d " +
                    "WHERE d.status = 'OVERDUE' OR " +
                    "(d.status = 'BORROWING' AND d.dueDate < CURRENT_DATE)", Long.class)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findMostBorrowedBooks(int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT b.title, SUM(d.quantity) as total " +
                    "FROM BorrowRequestDetail d JOIN d.book b " +
                    "GROUP BY b.id, b.title ORDER BY total DESC")
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> countRequestsByMonth(int year) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT MONTH(br.requestDate), COUNT(br) " +
                    "FROM BorrowRequest br " +
                    "WHERE YEAR(br.requestDate) = :year " +
                    "GROUP BY MONTH(br.requestDate) ORDER BY MONTH(br.requestDate)")
                    .setParameter("year", year)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Object[] getMaxMinAvgBorrowQty() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return (Object[]) em.createQuery(
                    "SELECT MAX(d.quantity), MIN(d.quantity), AVG(d.quantity) " +
                    "FROM BorrowRequestDetail d").getSingleResult();
        } finally {
            em.close();
        }
    }
}
