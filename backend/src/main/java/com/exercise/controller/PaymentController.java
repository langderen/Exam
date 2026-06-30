package com.exercise.controller;

import com.alipay.api.internal.util.AlipaySignature;
import com.exercise.common.Result;
import com.exercise.dto.CreatePaymentDTO;
import com.exercise.entity.PaymentOrder;
import com.exercise.service.PaymentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/payment")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    @Autowired
    private com.exercise.config.AlipayConfig alipayConfig;
    
    /**
     * 创建支付订单
     */
    @PostMapping("/create")
    public Result<String> createPayment(@Valid @RequestBody CreatePaymentDTO dto) {
        try {
            String formHtml = paymentService.createPayment(dto);
            return Result.success(formHtml);
        } catch (Exception e) {
            log.error("创建支付订单失败", e);
            return Result.error("创建支付订单失败：" + e.getMessage());
        }
    }
    
    /**
     * 支付宝异步通知接口
     * 注意：此接口不需要登录验证，需要在SaTokenConfig中排除
     */
    @PostMapping("/notify")
    public String handleNotify(HttpServletRequest request) {
        try {
            log.info("收到支付宝异步通知");
            
            // 获取支付宝POST过来的参数
            Map<String, String> params = new HashMap<>();
            Map<String, String[]> requestParams = request.getParameterMap();
            for (Map.Entry<String, String[]> entry : requestParams.entrySet()) {
                String[] values = entry.getValue();
                StringBuilder valueStr = new StringBuilder();
                for (int i = 0; i < values.length; i++) {
                    if (i > 0) {
                        valueStr.append(",");
                    }
                    valueStr.append(values[i]);
                }
                params.put(entry.getKey(), valueStr.toString());
            }
            
            // 验签
            boolean signVerified = AlipaySignature.rsaCheckV1(
                params,
                alipayConfig.getAlipayPublicKey(),
                alipayConfig.getCharset(),
                alipayConfig.getSignType()
            );
            
            if (!signVerified) {
                log.error("支付宝签名验证失败");
                return "failure";
            }
            
            // 获取关键参数
            String outTradeNo = params.get("out_trade_no"); // 商户订单号
            String tradeNo = params.get("trade_no"); // 支付宝交易号
            String tradeStatus = params.get("trade_status"); // 交易状态
            String appId = params.get("app_id"); // 应用ID
            
            // 验证appId是否匹配
            if (!appId.equals(alipayConfig.getAppId())) {
                log.error("appId不匹配，期望：{}，实际：{}", alipayConfig.getAppId(), appId);
                return "failure";
            }
            
            log.info("支付通知参数：outTradeNo={}, tradeNo={}, tradeStatus={}", 
                outTradeNo, tradeNo, tradeStatus);
            
            // 处理支付结果
            boolean success = paymentService.handleNotify(outTradeNo, tradeNo, tradeStatus);
            
            if (success) {
                log.info("支付通知处理成功");
                return "success";
            } else {
                log.error("支付通知处理失败");
                return "failure";
            }
        } catch (Exception e) {
            log.error("处理支付宝通知异常", e);
            return "failure";
        }
    }
    
    /**
     * 查询支付订单
     */
    @GetMapping("/query/{orderNo}")
    public Result<PaymentOrder> queryPayment(@PathVariable String orderNo) {
        try {
            PaymentOrder order = paymentService.queryPayment(orderNo);
            return Result.success(order);
        } catch (Exception e) {
            log.error("查询支付订单失败", e);
            return Result.error("查询支付订单失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取用户支付记录
     */
    @GetMapping("/user/{userId}")
    public Result<List<PaymentOrder>> getUserPayments(@PathVariable Long userId) {
        try {
            List<PaymentOrder> orders = paymentService.getUserPayments(userId);
            return Result.success(orders);
        } catch (Exception e) {
            log.error("获取用户支付记录失败", e);
            return Result.error("获取用户支付记录失败：" + e.getMessage());
        }
    }
}
