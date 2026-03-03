package com.exercise.mapper;

import com.exercise.entity.WalletTransaction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface WalletTransactionMapper {
    int insert(WalletTransaction transaction);
    
    List<WalletTransaction> selectByWalletId(@Param("walletId") Long walletId);
    
    List<WalletTransaction> selectByWalletIdWithType(@Param("walletId") Long walletId, @Param("type") String type);
}
