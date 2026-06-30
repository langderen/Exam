package com.exercise.config;

import cn.dev33.satoken.interceptor.SaInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class SaTokenConfig implements WebMvcConfigurer {
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SaInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/user/login",
                        "/user/register",
                        "/user/sendVerifyCode",
                        "/user/resetPassword",
                        "/book/list",
                        "/book/detail/**",
                        "/book/listWithPurchase",
                        "/book/listWithPurchasePaged",
                        "/book/all",
                        "/type/list",
                        "/upload/**",
                        "/payment/notify"  // 支付宝异步通知接口，不需要登录验证
                );
    }
}
