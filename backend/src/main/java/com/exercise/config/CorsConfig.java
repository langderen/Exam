package com.exercise.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();

        // ===== 开发环境配置（生产环境替换为具体域名）=====
        config.addAllowedOriginPattern("http://localhost:3000"); // 前端本地地址
        // config.addAllowedOriginPattern("https://your-frontend.com"); // 生产环境域名

        // 允许携带Cookie/Token（刷题系统登录态必需）
        config.setAllowCredentials(true);

        // 允许的请求头
        config.addAllowedHeader("*");

        // 允许的请求方法（按需开放）
        config.addAllowedMethod("GET");
        config.addAllowedMethod("POST");
        config.addAllowedMethod("PUT");
        config.addAllowedMethod("DELETE");
        config.addAllowedMethod("OPTIONS");

        // 暴露前端需要的响应头
        config.addExposedHeader("Authorization");
        config.addExposedHeader("Content-Disposition"); // 文件下载时需要

        // 预检请求缓存时间
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        // 所有接口生效
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}