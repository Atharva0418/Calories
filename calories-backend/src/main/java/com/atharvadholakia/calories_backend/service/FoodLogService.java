package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import com.atharvadholakia.calories_backend.exceptions.ResourceNotFoundException;
import com.atharvadholakia.calories_backend.repository.FoodLogRepository;
import com.atharvadholakia.calories_backend.repository.UserRepository;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class FoodLogService {

  private final FoodLogRepository foodLogRepository;

  private final UserRepository userRepository;

  public FoodLogService(FoodLogRepository foodLogRepository, UserRepository userRepository) {
    this.foodLogRepository = foodLogRepository;
    this.userRepository = userRepository;
  }

  public FoodLog addFoodLog(String email, FoodLog foodLog) {

    User user =
        userRepository
            .findByEmail(email)
            .orElseThrow(() -> new ResourceNotFoundException("User not found with email " + email));

    foodLog.setUser(user);

    log.info("Logging food.");
    return foodLogRepository.save(foodLog);
  }

  public List<FoodLog> getAllFoodLogsByUserEmail(String email) {
    log.info("Retrieving all food logs of User : {}", email);
    return foodLogRepository.findByUserEmail(email);
  }

  public void deleteFoodLogById(String id) {
    log.info("Fetching foodLog with id: {}", id);
    foodLogRepository
        .findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("FoodLog not found with id: " + id));

    log.info("Deleting foodLog with id: {}", id);
    foodLogRepository.deleteById(id);
  }

  public FoodLog updateFoodLogById(FoodLog foodLog) {
    FoodLog existingFoodLog =
        foodLogRepository
            .findById(foodLog.getId())
            .orElseThrow(
                () ->
                    new ResourceNotFoundException(
                        "FoodLog not found with id : " + foodLog.getId()));

    BeanUtils.copyProperties(foodLog, existingFoodLog, "id", "user");

    foodLogRepository.save(existingFoodLog);
    return existingFoodLog;
  }
}
