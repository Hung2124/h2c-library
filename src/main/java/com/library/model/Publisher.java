package com.library.model;

import jakarta.persistence.*;
import org.hibernate.annotations.Nationalized;

import java.io.Serializable;

@Entity
@Table(name = "publishers")
public class Publisher implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** NVARCHAR – tránh lưu tiếng Việt thành VARCHAR / mất dấu trên SQL Server */
    @Nationalized
    @Column(nullable = false, unique = true, length = 200)
    private String name;

    @Nationalized
    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String note;

    public Publisher() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
