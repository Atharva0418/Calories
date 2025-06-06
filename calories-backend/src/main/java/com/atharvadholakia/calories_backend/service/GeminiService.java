package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.GeminiRequest;
import com.atharvadholakia.calories_backend.data.GeminiResponse;
import com.atharvadholakia.calories_backend.data.Nutrition;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

@Service
public class GeminiService {

  @Value("${gemini.api.key}")
  private String apikey;

  private static final String URL =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

  private final RestTemplate restTemplate = new RestTemplate();

  @Autowired private ObjectMapper objectMapper;

  public String askGemini(String prompt) {
    GeminiRequest.Part part = new GeminiRequest.Part(prompt);
    GeminiRequest.Content content = new GeminiRequest.Content(List.of(part));
    GeminiRequest request = new GeminiRequest(List.of(content));

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<GeminiRequest> entity = new HttpEntity<>(request, headers);

    ResponseEntity<GeminiResponse> response =
        restTemplate.exchange(URL + apikey, HttpMethod.POST, entity, GeminiResponse.class);

    return Optional.ofNullable(response.getBody())
        .flatMap(body -> body.getCandidates().stream().findFirst())
        .map(candidate -> candidate.getContent())
        .map(contentObj -> contentObj.getParts())
        .filter(parts -> !parts.isEmpty())
        .map(parts -> parts.get(0).getText())
        .orElse("No response");
  }

  public Nutrition analyzaImageNutrition(MultipartFile imageFile) {

    String base64Image;
    try {
      base64Image = Base64.getEncoder().encodeToString(imageFile.getBytes());
    } catch (IOException e) {
      throw new RuntimeException(e.getMessage());
    }

    String prompt =
        """
You are a certified nutritionist.

Analyze the food in the following image and estimate its nutrition values **per 100g**.

Before generating JSON:
- First, determine what the food is.
- Then, based on typical examples of that food, estimate nutrition.

You must respond **only** in the following JSON structure:

{
  "food": "<name of the food>",
  "protein": <amount in grams>,
  "carbohydrates": <amount in grams>,
  "sugar": <amount in grams>,
  "fat": <amount in grams>,
  "energy": <amount in kcal>
}

Now analyze this image:
data:image/jpeg;base64,%s
"""
            .formatted(base64Image);

    GeminiRequest.Part part = new GeminiRequest.Part(prompt);
    GeminiRequest.Content content = new GeminiRequest.Content(List.of(part));
    GeminiRequest request = new GeminiRequest(List.of(content));

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<GeminiRequest> entity = new HttpEntity<>(request, headers);

    ResponseEntity<GeminiResponse> response =
        restTemplate.exchange(URL + apikey, HttpMethod.POST, entity, GeminiResponse.class);

    String jsonResponse =
        Optional.ofNullable(response.getBody())
            .flatMap(body -> body.getCandidates().stream().findFirst())
            .map(candidate -> candidate.getContent())
            .map(contentObj -> contentObj.getParts())
            .filter(parts -> !parts.isEmpty())
            .map(parts -> parts.get(0).getText())
            .orElse("No response");

    jsonResponse = cleanJson(jsonResponse);
    Nutrition nutrition;
    try {
      nutrition = objectMapper.readValue(jsonResponse, Nutrition.class);
    } catch (JsonProcessingException e) {
      throw new RuntimeException(e.getMessage());
    }
    System.out.println("Log");
    return nutrition;
  }

  public String cleanJson(String rawJson) {
    int startIndex = rawJson.indexOf('{');
    int endIndex = rawJson.lastIndexOf('}');

    return rawJson.substring(startIndex, endIndex + 1).trim();
  }
}
