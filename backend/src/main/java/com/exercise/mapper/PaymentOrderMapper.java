package com.exercise.mapper;

import com.exercise.entity.PaymentOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface PaymentOrderMapper {
    int insert(PaymentOrder order);
    
    PaymentOrder selectByOrderNo(@Param("orderNo") String orderNo);
    
    PaymentOrder selectByTradeNo(@Param("tradeNo") String tradeNo);
    
    List<PaymentOrder> selectByUserId(@Param("userId") Long userId);
    
    int updateStatus(@Param("orderNo") String orderNo, @Param("status") Integer status, @Param("tradeNo") String tradeNo);
}
