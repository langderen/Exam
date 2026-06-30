package com.exercise.service.impl;

import cn.hutool.core.util.IdUtil;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.domain.AlipayTradePagePayModel;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradePagePayResponse;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.exercise.config.AlipayConfig;
import com.exercise.dto.CreatePaymentDTO;
import com.exercise.entity.PaymentOrder;
import com.exercise.mapper.PaymentOrderMapper;
import com.exercise.service.PaymentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
public class PaymentServiceImpl implements PaymentService {
    
    @Autowired
    private AlipayConfig alipayConfig;
    
    @Autowired
    private PaymentOrderMapper paymentOrderMapper;
    
    @Override
    public String createPayment(CreatePaymentDTO dto) {
        try {
            // 生成订单号
            String orderNo = "PAY" + IdUtil.getSnowflakeNextIdStr();
            
            // 创建支付订单
            PaymentOrder order = new PaymentOrder();
            order.setUserId(dto.getUserId());
            order.setOrderNo(orderNo);
            order.setSubject(dto.getSubject());
            order.setTotalAmount(dto.getTotalAmount());
            order.setStatus(0); // 0-待支付
            order.setCreateTime(LocalDateTime.now());
            paymentOrderMapper.insert(order);
            
            // 初始化支付宝客户端
            AlipayClient alipayClient = new DefaultAlipayClient(
                alipayConfig.getGateway(),
                alipayConfig.getAppId(),
                alipayConfig.getPrivateKey(),
                "json",
                alipayConfig.getCharset(),
                alipayConfig.getAlipayPublicKey(),
                alipayConfig.getSignType()
            );
            
            // 创建支付请求
            AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
            request.setReturnUrl(alipayConfig.getReturnUrl());
            request.setNotifyUrl(alipayConfig.getNotifyUrl());
            
            // 构建业务参数
            AlipayTradePagePayModel model = new AlipayTradePagePayModel();
            model.setOutTradeNo(orderNo);
            model.setProductCode("FAST_INSTANT_TRADE_PAY");
            model.setTotalAmount(dto.getTotalAmount().toString());
            model.setSubject(dto.getSubject());
            request.setBizModel(model);
            
            // 调用支付宝接口
            AlipayTradePagePayResponse response = alipayClient.pageExecute(request);
            
            if (response.isSuccess()) {
                log.info("创建支付订单成功，订单号：{}", orderNo);
                return response.getBody(); // 返回HTML表单
            } else {
                log.error("创建支付订单失败：{}", response.getMsg());
                throw new RuntimeException("创建支付订单失败：" + response.getMsg());
            }
        } catch (Exception e) {
            log.error("创建支付订单异常", e);
            throw new RuntimeException("创建支付订单失败：" + e.getMessage());
        }
    }
    
    @Override
    @Transactional
    public boolean handleNotify(String orderNo, String tradeNo, String tradeStatus) {
        try {
            log.info("处理支付通知，订单号：{}，交易号：{}，状态：{}", orderNo, tradeNo, tradeStatus);
            
            PaymentOrder order = paymentOrderMapper.selectByOrderNo(orderNo);
            if (order == null) {
                log.error("订单不存在：{}", orderNo);
                return false;
            }
            
            // 幂等性检查
            if (order.getStatus() == 1) {
                log.info("订单已处理，订单号：{}", orderNo);
                return true;
            }
            
            // 更新订单状态
            if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                order.setStatus(1); // 1-已支付
                order.setTradeNo(tradeNo);
                order.setPayTime(LocalDateTime.now());
                order.setPayMethod("alipay");
                paymentOrderMapper.updateStatus(orderNo, 1, tradeNo);
                log.info("支付成功，订单号：{}", orderNo);
                return true;
            } else {
                log.warn("支付状态异常，订单号：{}，状态：{}", orderNo, tradeStatus);
                return false;
            }
        } catch (Exception e) {
            log.error("处理支付通知异常", e);
            return false;
        }
    }
    
    @Override
    public PaymentOrder queryPayment(String orderNo) {
        try {
            // 初始化支付宝客户端
            AlipayClient alipayClient = new DefaultAlipayClient(
                alipayConfig.getGateway(),
                alipayConfig.getAppId(),
                alipayConfig.getPrivateKey(),
                "json",
                alipayConfig.getCharset(),
                alipayConfig.getAlipayPublicKey(),
                alipayConfig.getSignType()
            );
            
            // 创建查询请求
            AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();
            request.setBizContent("{\"out_trade_no\":\"" + orderNo + "\"}");
            
            AlipayTradeQueryResponse response = alipayClient.execute(request);
            
            if (response.isSuccess()) {
                String tradeStatus = response.getTradeStatus();
                String tradeNo = response.getTradeNo();
                
                // 更新本地订单状态
                if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                    paymentOrderMapper.updateStatus(orderNo, 1, tradeNo);
                }
                
                return paymentOrderMapper.selectByOrderNo(orderNo);
            } else {
                log.error("查询支付订单失败：{}", response.getMsg());
                throw new RuntimeException("查询支付订单失败：" + response.getMsg());
            }
        } catch (Exception e) {
            log.error("查询支付订单异常", e);
            throw new RuntimeException("查询支付订单失败：" + e.getMessage());
        }
    }
    
    @Override
    public List<PaymentOrder> getUserPayments(Long userId) {
        return paymentOrderMapper.selectByUserId(userId);
    }
}
