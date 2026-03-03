package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.entity.BookPurchase;
import com.exercise.service.BookPurchaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/purchase")
public class BookPurchaseController {
    
    @Autowired
    private BookPurchaseService bookPurchaseService;
    
    @PostMapping("/buy")
    public Result<Void> purchase(@RequestBody Map<String, Long> params) {
        try {
            Long bookId = params.get("bookId");
            Long userId = params.get("userId");
            bookPurchaseService.purchase(bookId, userId);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/check")
    public Result<Boolean> checkPurchased(@RequestParam Long bookId, @RequestParam Long userId) {
        boolean purchased = bookPurchaseService.hasPurchased(bookId, userId);
        return Result.success(purchased);
    }
    
    @GetMapping("/my")
    public Result<List<BookPurchase>> myPurchases(@RequestParam Long userId) {
        List<BookPurchase> list = bookPurchaseService.getMyPurchases(userId);
        return Result.success(list);
    }
    
    @GetMapping("/all")
    public Result<List<BookPurchase>> allPurchases() {
        List<BookPurchase> list = bookPurchaseService.getAllPurchases();
        return Result.success(list);
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> refund(@PathVariable Long id) {
        try {
            bookPurchaseService.refund(id);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}
