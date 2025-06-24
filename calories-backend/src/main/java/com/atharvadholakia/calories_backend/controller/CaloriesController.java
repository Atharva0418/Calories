package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.exceptions.InvalidImageException;
import com.atharvadholakia.calories_backend.service.CaloriesService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api")
@Slf4j
public class CaloriesController {

  private final CaloriesService caloriesService;

  public CaloriesController(CaloriesService caloriesService) {
    this.caloriesService = caloriesService;
  }

  @PostMapping("/predict-nutrients")
  public ResponseEntity<Nutrition> analyzeNutrition(
      @RequestParam("imageFile") MultipartFile imageFile) {

    if (!caloriesService.isValidImage(imageFile)) throw new InvalidImageException();
    log.info("Calling service to analyze image.");

    Nutrition nutrition = caloriesService.analyzeImageNutrition(imageFile);
    log.info("Sucessfully predicted nutrients.\n");
    return new ResponseEntity<>(nutrition, HttpStatus.OK);
  }

  @RequestMapping(value = "/health", method = RequestMethod.HEAD)
  public ResponseEntity<Void> healthCheck() {
    log.info("Server is running.");
    return new ResponseEntity<>(HttpStatus.OK);
  }
}
