package com.exercise.service;

import com.exercise.entity.BookPurchase;
import java.util.List;

public interface BookPurchaseService {
    void purchase(Long bookId, Long userId);
    
    boolean hasPurchased(Long bookId, Long userId);
    
    List<BookPurchase> getMyPurchases(Long userId);
    
    List<BookPurchase> getAllPurchases();
    
    void refund(Long id);
}
