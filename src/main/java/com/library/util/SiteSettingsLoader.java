package com.library.util;

import com.library.repository.SiteSettingRepository;
import jakarta.servlet.ServletContext;
import java.util.Map;

public final class SiteSettingsLoader {

    private SiteSettingsLoader() {}

    public static void reload(ServletContext ctx) {
        Map<String, String> map = new SiteSettingRepository().findAllAsMap();
        ctx.setAttribute("siteSettings", map);
    }
}
