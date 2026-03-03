package com.exercise.mapper;

import com.exercise.entity.BookPurchase;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface BookPurchaseMapper {
    int insert(BookPurchase purchase);
    
    BookPurchase selectByBookAndUser(@Param("bookId") Long bookId, @Param("userId") Long userId);
    
    List<BookPurchase> selectByUserId(@Param("userId") Long userId);
    
    List<BookPurchase> selectAll();
    
    int deleteById(@Param("id") Long id);
}
