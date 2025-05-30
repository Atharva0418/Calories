package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.exceptions.InvalidImageException;
import com.atharvadholakia.calories_backend.exceptions.ResourceNotFoundException;
import java.awt.image.BufferedImage;
import java.io.IOException;
import javax.imageio.ImageIO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@CrossOrigin(origins = "*")
@Slf4j
public class CaloriesController {

  @PostMapping("/food/calories")
  public ResponseEntity<Nutrition> getNutrition(@RequestParam() MultipartFile image) {

    if (image.isEmpty()) {
      throw new ResourceNotFoundException("Image not found!");
    } else {
      try {
        BufferedImage img = ImageIO.read(image.getInputStream());
        if (img == null) {
          throw new ResourceNotFoundException("Only image files(jpg, png, jpeg) are allowed");
        }

      } catch (IOException e) {
        throw new InvalidImageException("Failed to read the image file.");
      }
    }

    Nutrition nutrition = new Nutrition();
    // nutrition.setFood("Athu");
    // nutrition.setEnergy(" 600");
    // nutrition.setProtein("20");
    // nutrition.setFat("9");
    // nutrition.setCarbohydrates("52");
    // nutrition.setSugar("15");

    log.debug("Successfully calculated Nutrition info");
    System.out.println("Log");

    return new ResponseEntity<>(nutrition, HttpStatus.OK);
  }
}
