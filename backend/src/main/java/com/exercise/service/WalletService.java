package com.exercise.service;

import com.exercise.entity.SysUser;
import com.exercise.entity.WalletTransaction;
import java.math.BigDecimal;
import java.util.List;

public interface WalletService {
    SysUser getOrCreateWallet(Long userId);
    
    SysUser getByUserId(Long userId);
    
    void recharge(Long userId, BigDecimal amount);
    
    void deduct(Long userId, BigDecimal amount, String description, Long relatedId);
    
    List<WalletTransaction> getTransactions(Long userId);
    
    boolean hasEnoughBalance(Long userId, BigDecimal amount);
}
