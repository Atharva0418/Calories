package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.service.GeminiService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
}
