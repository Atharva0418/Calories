package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.data.NutritionRequest;
import com.atharvadholakia.calories_backend.data.NutritionResponse;
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
public class CaloriesService {

  @Value("${api.key}")
  private String apikey;

  @Value("${api.url}")
  private String URL;

  private final RestTemplate restTemplate = new RestTemplate();

  @Autowired private ObjectMapper objectMapper;

  public Nutrition analyzeImageNutrition(MultipartFile imageFile) {
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

    NutritionRequest.Part part = new NutritionRequest.Part(prompt);
    NutritionRequest.Content content = new NutritionRequest.Content(List.of(part));
    NutritionRequest request = new NutritionRequest(List.of(content));

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<NutritionRequest> entity = new HttpEntity<>(request, headers);

    ResponseEntity<NutritionResponse> response =
        restTemplate.exchange(
            URL + "?key=" + apikey, HttpMethod.POST, entity, NutritionResponse.class);

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
