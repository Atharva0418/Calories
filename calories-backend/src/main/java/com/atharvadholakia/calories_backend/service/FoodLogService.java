package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import com.atharvadholakia.calories_backend.repository.FoodLogRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class FoodLogService {

  private final FoodLogRepository foodLogRepository;

  public FoodLogService(FoodLogRepository foodLogRepository) {
    this.foodLogRepository = foodLogRepository;
  }

  public FoodLog addFoodLog(FoodLog foodLog) {
    log.info("Logging food.");
    return foodLogRepository.save(foodLog);
  }
}
