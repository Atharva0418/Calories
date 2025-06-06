package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.service.GeminiService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/gemini")
public class GeminiController {

  private final GeminiService geminiService;

  public GeminiController(GeminiService geminiService) {
    this.geminiService = geminiService;
  }

  @GetMapping("/ask")
  public ResponseEntity<String> ask(@RequestParam String prompt) {
    String answer = geminiService.askGemini(prompt);
    return new ResponseEntity<>(answer, HttpStatus.OK);
  }

  @PostMapping("/analyze-nutrition")
  public ResponseEntity<Nutrition> analyzeNutritinImage(
      @RequestParam("imageFile") MultipartFile imageFile) {

    Nutrition nutrition = geminiService.analyzaImageNutrition(imageFile);
    return new ResponseEntity<>(nutrition, HttpStatus.OK);
  }
}
