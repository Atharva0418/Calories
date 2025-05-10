package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.exceptions.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class CaloriesController {

  @PostMapping("/food/calories")
  public ResponseEntity<Nutrition> getNutrition(@RequestParam MultipartFile file) {

    if (file.isEmpty()) {
      throw new ResourceNotFoundException("Error: Image not found!");
    }

    Nutrition nutrition = new Nutrition();
    nutrition.setFood("Athu");
    nutrition.setEnergy("600");
    nutrition.setProtein("20");
    nutrition.setFat("9");
    nutrition.setCarbohydrated("52");
    nutrition.setSugar("15");

    return new ResponseEntity<>(nutrition, HttpStatus.OK);
  }
}
