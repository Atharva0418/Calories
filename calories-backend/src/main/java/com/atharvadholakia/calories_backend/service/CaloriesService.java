package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.config.ServiceConfig;
import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.data.NutritionRequest;
import com.atharvadholakia.calories_backend.data.NutritionResponse;
import com.atharvadholakia.calories_backend.exceptions.CustomTimeOutException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.netty.handler.timeout.ReadTimeoutException;
import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

@Service
public class CaloriesService {
  private final WebClient webClient;

  private final ServiceConfig serviceConfig;

  private final ObjectMapper objectMapper;

  @Autowired
  public CaloriesService(
      WebClient webClient, ServiceConfig serviceConfig, ObjectMapper objectMapper) {
    this.webClient = webClient;
    this.serviceConfig = serviceConfig;
    this.objectMapper = objectMapper;
  }

  public Nutrition analyzeImageNutrition(MultipartFile imageFile) {

    String base64Image;
    try {
      base64Image = Base64.getEncoder().encodeToString(imageFile.getBytes());
    } catch (IOException e) {
      throw new RuntimeException(e.getMessage());
    }

    String prompt = getPrompt(base64Image);

    NutritionRequest.Part part = new NutritionRequest.Part(prompt);
    NutritionRequest.Content content = new NutritionRequest.Content(List.of(part));
    NutritionRequest request = new NutritionRequest(List.of(content));

    try {

      NutritionResponse nutritionResponse =
          webClient
              .post()
              .uri(serviceConfig.getUrl() + "?key=" + serviceConfig.getApiKey())
              .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
              .bodyValue(request)
              .retrieve()
              .bodyToMono(NutritionResponse.class)
              .block();

      String jsonResponse =
          Optional.ofNullable(nutritionResponse)
              .flatMap(body -> body.getCandidates().stream().findFirst())
              .map(candidate -> candidate.getContent())
              .map(contentObj -> contentObj.getParts())
              .filter(parts -> !parts.isEmpty())
              .map(parts -> parts.get(0).getText())
              .orElse("No response.Please try again.");

      jsonResponse = cleanJson(jsonResponse);
      Nutrition nutrition;
      try {
        nutrition = objectMapper.readValue(jsonResponse, Nutrition.class);
      } catch (JsonProcessingException e) {
        throw new RuntimeException(e.getMessage());
      }

      return nutrition;
    } catch (WebClientResponseException e) {
      throw new RuntimeException();

    } catch (RuntimeException e) {
      if (e.getCause() instanceof ReadTimeoutException) {
        throw new CustomTimeOutException();
      }

      throw new RuntimeException();
    }
  }

  public String cleanJson(String rawJson) {
    int startIndex = rawJson.indexOf('{');
    int endIndex = rawJson.lastIndexOf('}');

    return rawJson.substring(startIndex, endIndex + 1).trim();
  }

  public String getMIMEType(String filename) {
    String ext = filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
    return switch (ext) {
      case "jpg", "jpeg" -> "image/jpeg";
      case "png" -> "image/png";
      default -> "applicaton/octet-stream";
    };
  }

  public boolean isValidImage(MultipartFile imageFile) {
    String contentType = getMIMEType(imageFile.getOriginalFilename());

    if (contentType.equalsIgnoreCase("image/jpeg")
        || contentType.equalsIgnoreCase("image/png")
        || contentType.equalsIgnoreCase("image/jpg")) {
      return true;
    }
    return false;
  }

  public String getPrompt(String stringOfImage) {
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
            .formatted(stringOfImage);

    return prompt;
  }
}
