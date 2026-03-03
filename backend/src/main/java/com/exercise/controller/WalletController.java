package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.entity.SysUser;
import com.exercise.entity.WalletTransaction;
import com.exercise.service.WalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/wallet")
public class WalletController {
    
    @Autowired
    private WalletService walletService;
    
    @GetMapping("/info")
    public Result<SysUser> getWallet(@RequestParam Long userId) {
        SysUser user = walletService.getOrCreateWallet(userId);
        return Result.success(user);
    }
    
    @PostMapping("/recharge")
    public Result<Void> recharge(@RequestBody Map<String, Object> params) {
        try {
            Long userId = Long.valueOf(params.get("userId").toString());
            BigDecimal amount = new BigDecimal(params.get("amount").toString());
            walletService.recharge(userId, amount);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/transactions")
    public Result<List<WalletTransaction>> getTransactions(@RequestParam Long userId) {
        List<WalletTransaction> list = walletService.getTransactions(userId);
        return Result.success(list);
    }
    
    @GetMapping("/checkBalance")
    public Result<Boolean> checkBalance(@RequestParam Long userId, @RequestParam BigDecimal amount) {
        boolean enough = walletService.hasEnoughBalance(userId, amount);
        return Result.success(enough);
    }
}
