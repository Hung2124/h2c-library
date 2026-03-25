package com.library.model;

import java.io.Serializable;

public class CartItem implements Serializable {

    private Long bookId;
    private String bookTitle;
    private String bookImage;
    private int quantity;
    private int maxQuantity;

    public CartItem() {}

    public CartItem(Long bookId, String bookTitle, String bookImage, int quantity, int maxQuantity) {
        this.bookId = bookId;
        this.bookTitle = bookTitle;
        this.bookImage = bookImage;
        this.quantity = quantity;
        this.maxQuantity = maxQuantity;
    }

    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookImage() { return bookImage; }
    public void setBookImage(String bookImage) { this.bookImage = bookImage; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getMaxQuantity() { return maxQuantity; }
    public void setMaxQuantity(int maxQuantity) { this.maxQuantity = maxQuantity; }
}
