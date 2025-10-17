package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import com.atharvadholakia.calories_backend.service.FoodLogService;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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

  @PostMapping("/addFood")
  public ResponseEntity<FoodLog> addFoodLog(@RequestBody FoodLog foodLog) {
    FoodLog savedFoodLog = foodLogService.addFoodLog(foodLog);

    log.info("Food logged successfully.");
    return new ResponseEntity<>(savedFoodLog, HttpStatus.CREATED);
  }

  @GetMapping("/allLogs")
  public ResponseEntity<List<FoodLog>> getAllFoodLogs() {
    List<FoodLog> allFoodLogs = foodLogService.getAllFoodLogs();

    return new ResponseEntity<>(allFoodLogs, HttpStatus.OK);
  }
}
