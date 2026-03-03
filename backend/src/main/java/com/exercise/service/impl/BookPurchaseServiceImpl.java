package com.exercise.service.impl;

import com.exercise.entity.BookPurchase;
import com.exercise.entity.ExerciseBook;
import com.exercise.mapper.BookPurchaseMapper;
import com.exercise.mapper.ExerciseBookMapper;
import com.exercise.service.BookPurchaseService;
import com.exercise.service.WalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class BookPurchaseServiceImpl implements BookPurchaseService {
    
    @Autowired
    private BookPurchaseMapper bookPurchaseMapper;
    
    @Autowired
    private ExerciseBookMapper exerciseBookMapper;
    
    @Autowired
    private WalletService walletService;
    
    @Override
    @Transactional
    public void purchase(Long bookId, Long userId) {
        ExerciseBook book = exerciseBookMapper.selectById(bookId);
        if (book == null) {
            throw new RuntimeException("习题册不存在");
        }
        
        if (book.getCreatorId() != null && book.getCreatorId().equals(userId)) {
            throw new RuntimeException("您是作者，无需购买");
        }
        
        BookPurchase exist = bookPurchaseMapper.selectByBookAndUser(bookId, userId);
        if (exist != null) {
            throw new RuntimeException("您已购买过此习题册");
        }
        
        BigDecimal price = book.getPrice();
        if (price == null) {
            price = BigDecimal.ZERO;
        }
        
        if (price.compareTo(BigDecimal.ZERO) > 0) {
            if (!walletService.hasEnoughBalance(userId, price)) {
                throw new RuntimeException("余额不足，请先充值");
            }
            walletService.deduct(userId, price, "购买习题册：" + book.getBookName(), bookId);
        }
        
        BookPurchase purchase = new BookPurchase();
        purchase.setBookId(bookId);
        purchase.setUserId(userId);
        purchase.setPrice(price);
        purchase.setPurchaseTime(LocalDateTime.now());
        bookPurchaseMapper.insert(purchase);
    }
    
    @Override
    public boolean hasPurchased(Long bookId, Long userId) {
        BookPurchase purchase = bookPurchaseMapper.selectByBookAndUser(bookId, userId);
        return purchase != null;
    }
    
    @Override
    public List<BookPurchase> getMyPurchases(Long userId) {
        return bookPurchaseMapper.selectByUserId(userId);
    }
    
    @Override
    public List<BookPurchase> getAllPurchases() {
        return bookPurchaseMapper.selectAll();
    }
    
    @Override
    public void refund(Long id) {
        bookPurchaseMapper.deleteById(id);
    }
}
