package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.BorrowRequest;
import com.library.model.BorrowRequestDetail;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

public class BorrowRepository {

    public BorrowRequest save(BorrowRequest request) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (request.getId() == null) {
                em.persist(request);
                for (BorrowRequestDetail detail : request.getDetails()) {
                    detail.setBorrowRequest(request);
                    em.persist(detail);
                    // Decrease available quantity
                    detail.getBook().setAvailableQuantity(
                            detail.getBook().getAvailableQuantity() - detail.getQuantity());
                    em.merge(detail.getBook());
                }
            } else {
                request = em.merge(request);
            }
            em.getTransaction().commit();
            return request;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public Optional<BorrowRequest> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            var list = em.createQuery(
                    "SELECT br FROM BorrowRequest br " +
                    "LEFT JOIN FETCH br.user " +
                    "LEFT JOIN FETCH br.approvedBy " +
                    "LEFT JOIN FETCH br.details d LEFT JOIN FETCH d.book " +
                    "WHERE br.id = :id", BorrowRequest.class)
                    .setParameter("id", id)
                    .getResultList();
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } finally {
            em.close();
        }
    }

    public List<BorrowRequest> findByUserId(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<BorrowRequest> raw = em.createQuery(
                    "SELECT br FROM BorrowRequest br " +
                    "LEFT JOIN FETCH br.user " +
                    "LEFT JOIN FETCH br.details d " +
                    "LEFT JOIN FETCH d.book " +
                    "WHERE br.user.id = :userId",
                    BorrowRequest.class)
                    .setParameter("userId", userId)
                    .getResultList();
            Map<Long, BorrowRequest> byId = new LinkedHashMap<>();
            for (BorrowRequest br : raw) {
                byId.putIfAbsent(br.getId(), br);
            }
            Comparator<BorrowRequest> byRequestDate = Comparator.comparing(
                    BorrowRequest::getRequestDate,
                    Comparator.nullsLast(Comparator.naturalOrder())
            );
            return byId.values().stream()
                    .sorted(byRequestDate.reversed())
                    .collect(Collectors.toList());
        } finally {
            em.close();
        }
    }

    public List<BorrowRequest> findAll(String statusFilter, int offset, int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT br FROM BorrowRequest br " +
                    "LEFT JOIN FETCH br.user " +
                    "LEFT JOIN FETCH br.details d " +
                    "LEFT JOIN FETCH d.book " +
                    (statusFilter != null && !statusFilter.isBlank() ? "WHERE br.status = :status " : "");
            TypedQuery<BorrowRequest> q = em.createQuery(jpql, BorrowRequest.class);
            if (statusFilter != null && !statusFilter.isBlank()) {
                q.setParameter("status", statusFilter);
            }
            List<BorrowRequest> raw = q.getResultList();
            Map<Long, BorrowRequest> byId = new LinkedHashMap<>();
            for (BorrowRequest br : raw) {
                byId.putIfAbsent(br.getId(), br);
            }
            Comparator<BorrowRequest> byDate = Comparator.comparing(
                    BorrowRequest::getRequestDate,
                    Comparator.nullsLast(Comparator.naturalOrder())
            );
            List<BorrowRequest> sorted = byId.values().stream()
                    .sorted(byDate.reversed())
                    .collect(Collectors.toList());
            int from = Math.min(offset, sorted.size());
            int to = Math.min(offset + limit, sorted.size());
            return sorted.subList(from, to);
        } finally {
            em.close();
        }
    }

    public long countAll(String statusFilter) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(br) FROM BorrowRequest br" +
                    (statusFilter != null && !statusFilter.isBlank() ? " WHERE br.status = :status" : "");
            TypedQuery<Long> q = em.createQuery(jpql, Long.class);
            if (statusFilter != null && !statusFilter.isBlank()) {
                q.setParameter("status", statusFilter);
            }
            return q.getSingleResult();
        } finally {
            em.close();
        }
    }

    public BorrowRequest update(BorrowRequest request) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            BorrowRequest merged = em.merge(request);
            em.getTransaction().commit();
            return merged;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public BorrowRequestDetail updateDetail(BorrowRequestDetail detail) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            if (detail.getBook() != null) {
                em.merge(detail.getBook()); // persist book's availableQuantity change
            }
            BorrowRequestDetail merged = em.merge(detail);
            em.getTransaction().commit();
            return merged;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public Optional<BorrowRequestDetail> findDetailById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(BorrowRequestDetail.class, id));
        } finally {
            em.close();
        }
    }

    /** Chi tiết mượn thuộc về user (để gia hạn) */
    public Optional<BorrowRequestDetail> findDetailByIdForUser(Long detailId, Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<BorrowRequestDetail> list = em.createQuery(
                    "SELECT d FROM BorrowRequestDetail d " +
                    "JOIN FETCH d.borrowRequest br JOIN FETCH br.user " +
                    "JOIN FETCH d.book WHERE d.id = :id AND br.user.id = :uid",
                    BorrowRequestDetail.class)
                    .setParameter("id", detailId)
                    .setParameter("uid", userId)
                    .getResultList();
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } finally {
            em.close();
        }
    }

    /** Đang mượn, quá hạn, chưa trả, chưa gửi mail nhắc */
    public List<BorrowRequestDetail> findPastDueNeedingNotification(LocalDate today) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT d FROM BorrowRequestDetail d " +
                    "JOIN FETCH d.borrowRequest br JOIN FETCH br.user JOIN FETCH d.book " +
                    "WHERE br.status = 'APPROVED' AND d.dueDate IS NOT NULL AND d.dueDate < :today " +
                    "AND d.status IN ('BORROWING','OVERDUE') AND d.returnDate IS NULL " +
                    "AND d.overdueEmailSentAt IS NULL",
                    BorrowRequestDetail.class)
                    .setParameter("today", today)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
