package com.library.seeder;

import com.library.config.JPAUtil;
import com.library.model.*;
import com.library.utils.PasswordUtil;
import jakarta.persistence.EntityManager;

public class DataSeeder {

    private static volatile boolean seeded = false;

    public static void seedIfEmpty() {
        if (seeded) return;
        synchronized (DataSeeder.class) {
            if (seeded) return;
            EntityManager em = null;
            try {
                em = JPAUtil.getEntityManager();
                long userCount = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
                if (userCount > 0) {
                    seeded = true;
                    return;
                }

                em.getTransaction().begin();

                // ── Users ──────────────────────────────────────────────
                String hash = PasswordUtil.hash("123456");

                User admin = new User("Administrator", "admin@library.com", hash, "ADMIN");
                admin.setStatus("ACTIVE");
                em.persist(admin);

                User member = new User("Nguyen Van A", "member@library.com", hash, "MEMBER");
                member.setStatus("ACTIVE");
                em.persist(member);

                // ── Categories ────────────────────────────────────────
                Category catProg = new Category("Lập trình", "Sách về lập trình và công nghệ");
                em.persist(catProg);

                Category catLit = new Category("Văn học", "Tiểu thuyết, truyện ngắn, thơ");
                em.persist(catLit);

                Category catEco = new Category("Kinh tế", "Quản trị, tài chính, marketing");
                em.persist(catEco);

                Category catSci = new Category("Khoa học", "Vật lý, hóa học, sinh học");
                em.persist(catSci);

                Category catHist = new Category("Lịch sử", "Lịch sử Việt Nam và thế giới");
                em.persist(catHist);

                // ── Authors ───────────────────────────────────────────
                Author a1 = new Author("James Gosling", "Cha đẻ của ngôn ngữ Java");
                em.persist(a1);

                Author a2 = new Author("Robert C. Martin", "Tác giả Clean Code, chuyên gia phần mềm");
                em.persist(a2);

                Author a3 = new Author("Nam Cao", "Nhà văn Việt Nam nổi tiếng");
                em.persist(a3);

                Author a4 = new Author("Tô Hoài", "Nhà văn Việt Nam, tác giả Dế Mèn Phiêu Lưu Ký");
                em.persist(a4);

                Author a5 = new Author("Joshua Bloch", "Kỹ sư Google, tác giả Effective Java");
                em.persist(a5);

                Author a6 = new Author("Ngô Tất Tố", "Nhà văn nổi tiếng của Việt Nam thời kỳ trước 1945");
                em.persist(a6);

                Author a7 = new Author("Stephen Hawking", "Nhà vật lý lý thuyết vĩ đại của thế kỷ 21");
                em.persist(a7);

                Author a8 = new Author("Philip Kotler", "Cha đẻ của Marketing hiện đại");
                em.persist(a8);

                Author a9 = new Author("Nguyễn Nhật Ánh", "Nhà văn chuyên viết truyện tuổi thơ đầy cảm xúc");
                em.persist(a9);

                Author a10 = new Author("Charles Darwin", "Nhà sinh vật học với thuyết tiến hóa");
                em.persist(a10);

                em.flush();

                // ── Publishers ────────────────────────────────────────
                Publisher p1 = new Publisher("Addison-Wesley", "Nhà xuất bản sách CNTT uy tín");
                em.persist(p1);

                Publisher p2 = new Publisher("Prentice Hall", "Sách giáo khoa và khoa học máy tính");
                em.persist(p2);

                Publisher p3 = new Publisher("NXB Giáo Dục", "Nhà xuất bản truyền thống Việt Nam");
                em.persist(p3);

                Publisher p4 = new Publisher("NXB Kim Đồng", "Chuyên sách truyện dành cho thiếu nhi");
                em.persist(p4);

                Publisher p5 = new Publisher("McGraw-Hill", "Nhà xuất bản giáo dục toàn cầu");
                em.persist(p5);

                Publisher p6 = new Publisher("NXB Trẻ", "Nhà xuất bản lớn tại Việt Nam cho thanh niên");
                em.persist(p6);

                Publisher p7 = new Publisher("Bantam Books", "Sách khoa học viễn tưởng và đại chúng");
                em.persist(p7);

                em.flush();

                // ── Books ─────────────────────────────────────────────
                em.persist(makeBook("Effective Java", a5, catProg, p1, 2018, "English",
                        5, 5, "assets/images/books/effective_java.png",
                        "Best practices for Java programming language"));

                em.persist(makeBook("Clean Code", a2, catProg, p2, 2008, "English",
                        3, 3, "assets/images/books/clean_code.png",
                        "A Handbook of Agile Software Craftsmanship"));

                em.persist(makeBook("Chí Phèo", a3, catLit, p3, 2010, "Tiếng Việt",
                        8, 8, "assets/images/books/chi_pheo.png",
                        "Tác phẩm kinh điển của Nam Cao về số phận con người"));

                em.persist(makeBook("Dế Mèn Phiêu Lưu Ký", a4, catLit, p4, 2015, "Tiếng Việt",
                        10, 10, "assets/images/books/de_men_phieu_luu_ky.png",
                        "Câu chuyện phiêu lưu của chú dế mèn"));

                em.persist(makeBook("Java: The Complete Reference", a1, catProg, p5, 2021, "English",
                        4, 4, "assets/images/books/java_complete_reference.png",
                        "Comprehensive Java programming reference"));

                em.persist(makeBook("Tắt Đèn", a6, catLit, p3, 2009, "Tiếng Việt",
                        7, 7, "assets/images/books/literature_cover.png",
                        "Tác phẩm hiện thực phê phán của Ngô Tất Tố"));

                em.persist(makeBook("Lược Sử Thời Gian", a7, catSci, p7, 2017, "Tiếng Việt",
                        5, 5, "assets/images/books/science_cover.png",
                        "Cuốn sách vật lý đại chúng vĩ đại của Stephen Hawking"));

                em.persist(makeBook("Marketing Management", a8, catEco, p2, 2015, "English",
                        6, 6, "assets/images/books/economics_cover.png",
                        "Sách gối đầu giường của dân marketing"));

                em.persist(makeBook("Tôi Thấy Hoa Vàng Trên Cỏ Xanh", a9, catLit, p6, 2010, "Tiếng Việt",
                        12, 12, "assets/images/books/literature_cover.png",
                        "Truyện về tình cảm hồn nhiên của tuổi thơ"));

                em.persist(makeBook("Nguồn Gốc Các Loài", a10, catSci, p7, 2012, "Tiếng Việt",
                        4, 4, "assets/images/books/science_cover.png",
                        "Thuyết tiến hóa làm thay đổi văn minh nhân loại"));

                em.persist(makeBook("Head First Java", a1, catProg, p6, 2005, "English",
                        10, 10, "assets/images/books/programming_cover.png",
                        "Học Java qua sơ đồ tư duy, trực quan và dễ hiểu"));

                em.persist(makeBook("Mắt Biếc", a9, catLit, p6, 1990, "Tiếng Việt",
                        15, 15, "assets/images/books/literature_cover.png",
                        "Chuyện tình buồn vượt thời gian của Nguyễn Nhật Ánh"));

                em.persist(makeBook("Clean Architecture", a2, catProg, p2, 2017, "English",
                        8, 8, "assets/images/books/programming_cover.png",
                        "Kiến trúc phần mềm sạch, bền vững"));

                em.persist(makeBook("Nguyên Lý Khởi Nghiệp Đoạn Trường", a8, catEco, p5, 2020, "Tiếng Việt",
                        6, 6, "assets/images/books/economics_cover.png",
                        "Sách hay về khởi nghiệp và kinh doanh"));

                em.persist(makeBook("Lịch Sử Việt Nam - Cổ Đại", a6, catHist, p3, 2005, "Tiếng Việt",
                        5, 5, "assets/images/books/history_cover.png",
                        "Tìm hiểu lịch sử nước nhà từ thuở hồng hoang"));

                em.persist(makeBook("Đại Số Tuyến Tính", a7, catSci, p3, 2010, "Tiếng Việt",
                        10, 10, "assets/images/books/science_cover.png",
                        "Giáo trình đại học Đại số tuyến tính"));

                em.persist(makeBook("Tài Chính Doanh Nghiệp", a8, catEco, p2, 2018, "English",
                        4, 4, "assets/images/books/economics_cover.png",
                        "Corporate finance in details"));

                em.persist(makeBook("Lập trình Web với Java", a5, catProg, p1, 2023, "Tiếng Việt",
                        9, 9, "assets/images/books/programming_cover.png",
                        "Cẩm nang trở thành Java Web Developer"));

                em.persist(makeBook("Kính Vạn Hoa", a9, catLit, p4, 1995, "Tiếng Việt",
                        20, 20, "assets/images/books/literature_cover.png",
                        "Bộ truyện teen huyền thoại của Nguyễn Nhật Ánh"));

                em.persist(makeBook("Thế Giới Lượng Tử", a7, catSci, p7, 2021, "Tiếng Việt",
                        7, 7, "assets/images/books/science_cover.png",
                        "Cái nhìn sâu hơn về vật lý lượng tử"));

                em.persist(makeBook("Kinh Tế Vĩ Mô", a8, catEco, p5, 2013, "English",
                        3, 3, "assets/images/books/economics_cover.png",
                        "Sách giáo khoa kinh tế vĩ mô chi tiết"));

                em.persist(makeBook("Sapiens Lược Sử Loài Người", a10, catHist, p6, 2014, "Tiếng Việt",
                        11, 11, "assets/images/books/history_cover.png",
                        "Tóm lược lịch sử phát triển loài người"));

                em.persist(makeBook("Đất Rừng Phương Nam", a4, catLit, p4, 2002, "Tiếng Việt",
                        5, 5, "assets/images/books/literature_cover.png",
                        "Văn học vùng tự nhiên hoang sơ của Tô Hoài"));

                em.persist(makeBook("Cơ Sở Dữ Liệu SQL Server", a1, catProg, p3, 2019, "Tiếng Việt",
                        6, 6, "assets/images/books/programming_cover.png",
                        "Thực hành SQL Server 2019 từ cơ bản đến nâng cao"));

                em.persist(makeBook("Chiến Tranh Và Hòa Bình", a3, catHist, p7, 2005, "Tiếng Việt",
                        2, 2, "assets/images/books/history_cover.png",
                        "Bản dịch tiếng Việt tác phẩm kinh điển thế giới"));

                em.getTransaction().commit();
                seeded = true;

            } catch (Exception e) {
                if (em != null && em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                e.printStackTrace();
            } finally {
                if (em != null && em.isOpen()) em.close();
            }
        }
    }

    private static Book makeBook(String title, Author author, Category category,
                                 Publisher publisher, int year, String language,
                                 int qty, int avail, String image, String desc) {
        Book b = new Book();
        b.setTitle(title);
        b.setAuthor(author);
        b.setCategory(category);
        b.setPublisher(publisher);
        b.setPublishYear(year);
        b.setLanguage(language);
        b.setQuantity(qty);
        b.setAvailableQuantity(avail);
        b.setImage(image);
        b.setDescription(desc);
        b.setStatus("AVAILABLE");
        return b;
    }
}
