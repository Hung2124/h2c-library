package com.library.utils;

public class PaginationUtil {

    public static final int DEFAULT_PAGE_SIZE = 8;

    private PaginationUtil() {}

    public static int getOffset(int page, int pageSize) {
        return (page - 1) * pageSize;
    }

    public static int getTotalPages(long totalItems, int pageSize) {
        return (int) Math.ceil((double) totalItems / pageSize);
    }

    public static int safePage(String pageParam) {
        if (pageParam == null || pageParam.isBlank()) return 1;
        try {
            int p = Integer.parseInt(pageParam);
            return p < 1 ? 1 : p;
        } catch (NumberFormatException e) {
            return 1;
        }
    }
}
