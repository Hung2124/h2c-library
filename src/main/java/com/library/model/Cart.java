package com.library.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart implements Serializable {

    private final Map<Long, CartItem> items = new LinkedHashMap<>();

    public void addItem(Long bookId, String title, String image, int maxQuantity) {
        if (items.containsKey(bookId)) {
            CartItem existing = items.get(bookId);
            int newQty = existing.getQuantity() + 1;
            existing.setQuantity(Math.min(newQty, maxQuantity));
        } else {
            items.put(bookId, new CartItem(bookId, title, image, 1, maxQuantity));
        }
    }

    public void removeItem(Long bookId) {
        items.remove(bookId);
    }

    public void updateQuantity(Long bookId, int quantity) {
        CartItem item = items.get(bookId);
        if (item != null) {
            if (quantity <= 0) {
                items.remove(bookId);
            } else {
                item.setQuantity(Math.min(quantity, item.getMaxQuantity()));
            }
        }
    }

    public void clear() {
        items.clear();
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public int getTotalItems() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public int getItemCount() {
        return items.size();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public boolean contains(Long bookId) {
        return items.containsKey(bookId);
    }
}
