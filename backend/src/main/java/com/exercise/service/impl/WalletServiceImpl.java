package com.exercise.service.impl;

import com.exercise.entity.SysUser;
import com.exercise.entity.WalletTransaction;
import com.exercise.mapper.SysUserMapper;
import com.exercise.mapper.WalletTransactionMapper;
import com.exercise.service.WalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class WalletServiceImpl implements WalletService {
    
    @Autowired
    private SysUserMapper sysUserMapper;
    
    @Autowired
    private WalletTransactionMapper transactionMapper;
    
    @Override
    public SysUser getOrCreateWallet(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user != null && user.getBalance() == null) {
            user.setBalance(BigDecimal.ZERO);
        }
        return user;
    }
    
    @Override
    public SysUser getByUserId(Long userId) {
        return sysUserMapper.selectById(userId);
    }
    
    @Override
    @Transactional
    public void recharge(Long userId, BigDecimal amount) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("充值金额必须大于0");
        }
        
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        BigDecimal currentBalance = user.getBalance() != null ? user.getBalance() : BigDecimal.ZERO;
        
        sysUserMapper.updateBalance(userId, amount);
        
        WalletTransaction transaction = new WalletTransaction();
        transaction.setWalletId(userId);
        transaction.setType("recharge");
        transaction.setAmount(amount);
        transaction.setBalanceAfter(currentBalance.add(amount));
        transaction.setDescription("充值");
        transaction.setCreateTime(LocalDateTime.now());
        transactionMapper.insert(transaction);
    }
    
    @Override
    @Transactional
    public void deduct(Long userId, BigDecimal amount, String description, Long relatedId) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("扣款金额必须大于0");
        }
        
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        BigDecimal currentBalance = user.getBalance() != null ? user.getBalance() : BigDecimal.ZERO;
        if (currentBalance.compareTo(amount) < 0) {
            throw new RuntimeException("余额不足");
        }
        
        sysUserMapper.updateBalance(userId, amount.negate());
        
        WalletTransaction transaction = new WalletTransaction();
        transaction.setWalletId(userId);
        transaction.setType("purchase");
        transaction.setAmount(amount.negate());
        transaction.setBalanceAfter(currentBalance.subtract(amount));
        transaction.setDescription(description);
        transaction.setRelatedId(relatedId);
        transaction.setCreateTime(LocalDateTime.now());
        transactionMapper.insert(transaction);
    }
    
    @Override
    public List<WalletTransaction> getTransactions(Long userId) {
        return transactionMapper.selectByWalletId(userId);
    }
    
    @Override
    public boolean hasEnoughBalance(Long userId, BigDecimal amount) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null || user.getBalance() == null) {
            return amount.compareTo(BigDecimal.ZERO) == 0;
        }
        return user.getBalance().compareTo(amount) >= 0;
    }
}
