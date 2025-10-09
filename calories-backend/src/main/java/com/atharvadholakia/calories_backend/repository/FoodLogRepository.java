package com.atharvadholakia.calories_backend.repository;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FoodLogRepository extends JpaRepository<FoodLog, String> {}
