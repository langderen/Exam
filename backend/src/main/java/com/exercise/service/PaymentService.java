package com.exercise.service;

import com.exercise.dto.CreatePaymentDTO;
import com.exercise.entity.PaymentOrder;
import java.util.List;

public interface PaymentService {
    String createPayment(CreatePaymentDTO dto);
    
    boolean handleNotify(String orderNo, String tradeNo, String tradeStatus);
    
    PaymentOrder queryPayment(String orderNo);
    
    List<PaymentOrder> getUserPayments(Long userId);
}
