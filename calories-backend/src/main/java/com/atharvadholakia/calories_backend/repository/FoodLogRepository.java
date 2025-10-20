package com.atharvadholakia.calories_backend.repository;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FoodLogRepository extends JpaRepository<FoodLog, String> {

  List<FoodLog> findByUserEmail(String email);
}
