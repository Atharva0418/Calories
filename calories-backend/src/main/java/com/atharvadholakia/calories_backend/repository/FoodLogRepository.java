package com.atharvadholakia.calories_backend.repository;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface FoodLogRepository extends JpaRepository<FoodLog, String> {

  @Query("SELECT f FROM FoodLog f WHERE f.user.email = :email ORDER BY f.timeStamp DESC")
  List<FoodLog> findByUserEmail(String email);
}
