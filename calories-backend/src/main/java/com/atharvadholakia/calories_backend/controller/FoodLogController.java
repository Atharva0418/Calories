package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import com.atharvadholakia.calories_backend.service.FoodLogService;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/log")
@Slf4j
public class FoodLogController {

  private final FoodLogService foodLogService;

  public FoodLogController(FoodLogService foodLogService) {
    this.foodLogService = foodLogService;
  }

  @PostMapping("/addFood/{email}")
  public ResponseEntity<FoodLog> addFoodLog(
      @PathVariable String email, @RequestBody FoodLog foodLog) {
    FoodLog savedFoodLog = foodLogService.addFoodLog(email, foodLog);

    log.info("Food logged successfully.");
    return new ResponseEntity<>(savedFoodLog, HttpStatus.CREATED);
  }

  @GetMapping("/allLogs/{email}")
  public ResponseEntity<List<FoodLog>> getAllFoodLogsByUserEmail(@PathVariable String email) {
    List<FoodLog> allFoodLogs = foodLogService.getAllFoodLogsByUserEmail(email);

    log.info("Successfully retrieved all FoodLogs.");
    return new ResponseEntity<>(allFoodLogs, HttpStatus.OK);
  }

  @DeleteMapping("/del/{id}")
  public ResponseEntity<Void> deleteFoodLogById(@PathVariable String id) {
    foodLogService.deleteFoodLogById(id);

    log.info("Successfully deleted the foodLog.");
    return new ResponseEntity<>(HttpStatus.OK);
  }

  @PatchMapping("/edit")
  public ResponseEntity<FoodLog> updateFoodLogById(@RequestBody FoodLog foodLog) {
    FoodLog updatedFoodLog = foodLogService.updateFoodLogById(foodLog);
    return new ResponseEntity<>(updatedFoodLog, HttpStatus.OK);
  }
}
