package com.library.repository;

import com.library.config.JPAUtil;
import com.library.model.SiteSetting;
import jakarta.persistence.EntityManager;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class SiteSettingRepository {

    public Map<String, String> findAllAsMap() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<SiteSetting> list = em.createQuery("SELECT s FROM SiteSetting s", SiteSetting.class)
                    .getResultList();
            Map<String, String> map = new HashMap<>();
            for (SiteSetting s : list) {
                map.put(s.getSettingKey(), s.getSettingValue());
            }
            return map;
        } finally {
            em.close();
        }
    }

    public Optional<String> getValue(String key) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            SiteSetting s = em.find(SiteSetting.class, key);
            return s == null ? Optional.empty() : Optional.ofNullable(s.getSettingValue());
        } finally {
            em.close();
        }
    }

    public void save(String key, String value) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            SiteSetting s = em.find(SiteSetting.class, key);
            if (s == null) {
                s = new SiteSetting(key, value);
                em.persist(s);
            } else {
                s.setSettingValue(value);
                em.merge(s);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void saveAll(Map<String, String> entries) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            for (Map.Entry<String, String> e : entries.entrySet()) {
                SiteSetting s = em.find(SiteSetting.class, e.getKey());
                if (s == null) {
                    em.persist(new SiteSetting(e.getKey(), e.getValue()));
                } else {
                    s.setSettingValue(e.getValue());
                    em.merge(s);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }
}
