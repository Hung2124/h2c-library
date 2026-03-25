package com.library.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "borrow_request_details")
public class BorrowRequestDetail implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private BorrowRequest borrowRequest;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Column(nullable = false)
    private Integer quantity = 1;

    @Column(name = "due_date")
    private LocalDate dueDate;

    @Column(name = "return_date")
    private LocalDate returnDate;

    @Column(name = "fine_amount", precision = 10, scale = 2)
    private BigDecimal fineAmount = BigDecimal.ZERO;

    @Column(nullable = false, length = 20)
    private String status = "BORROWING";

    @Column(name = "renewal_count", nullable = false, columnDefinition = "INT NOT NULL DEFAULT 0")
    private Integer renewalCount = 0;

    @Column(name = "overdue_email_sent_at")
    private java.time.LocalDateTime overdueEmailSentAt;

    public BorrowRequestDetail() {}

    public BorrowRequestDetail(BorrowRequest borrowRequest, Book book, Integer quantity) {
        this.borrowRequest = borrowRequest;
        this.book = book;
        this.quantity = quantity;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public BorrowRequest getBorrowRequest() { return borrowRequest; }
    public void setBorrowRequest(BorrowRequest borrowRequest) { this.borrowRequest = borrowRequest; }

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }

    public LocalDate getReturnDate() { return returnDate; }
    public void setReturnDate(LocalDate returnDate) { this.returnDate = returnDate; }

    public BigDecimal getFineAmount() { return fineAmount; }
    public void setFineAmount(BigDecimal fineAmount) { this.fineAmount = fineAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getRenewalCount() { return renewalCount; }
    public void setRenewalCount(Integer renewalCount) { this.renewalCount = renewalCount; }

    public java.time.LocalDateTime getOverdueEmailSentAt() { return overdueEmailSentAt; }
    public void setOverdueEmailSentAt(java.time.LocalDateTime overdueEmailSentAt) { this.overdueEmailSentAt = overdueEmailSentAt; }
}
