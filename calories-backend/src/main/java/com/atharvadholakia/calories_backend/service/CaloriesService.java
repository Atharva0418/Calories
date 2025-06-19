package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.config.ServiceConfig;
import com.atharvadholakia.calories_backend.data.Nutrition;
import com.atharvadholakia.calories_backend.data.NutritionRequest;
import com.atharvadholakia.calories_backend.data.NutritionResponse;
import com.atharvadholakia.calories_backend.exceptions.CustomTimeOutException;
import com.atharvadholakia.calories_backend.exceptions.NotAFoodImageException;
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

    NutritionRequest.TextPart textPart = new NutritionRequest.TextPart(getPrompt());

    NutritionRequest.ImagePart imagePart =
        new NutritionRequest.ImagePart(
            new NutritionRequest.InlineData(
                getMIMEType(imageFile.getOriginalFilename()), base64Image));

    NutritionRequest.Content content = new NutritionRequest.Content(List.of(textPart, imagePart));

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

      if (jsonResponse.contains("\"Error\"")) throw new NotAFoodImageException();

      Nutrition nutrition;
      try {
        nutrition = objectMapper.readValue(jsonResponse, Nutrition.class);

        return nutrition;
      } catch (JsonProcessingException e) {
        throw new RuntimeException(e.getMessage());
      }

    } catch (WebClientResponseException e) {
      throw e;

    } catch (RuntimeException e) {
      if (e.getCause() instanceof ReadTimeoutException) {
        throw new CustomTimeOutException();
      }
      throw e;
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

  public String getPrompt() {
    return """
You are a certified nutritionist.

- Look at the image carefully.
- Decide: Does the image contain food?
- If it does NOT contain food, STOP and respond ONLY with this JSON:
{
  "Error": "This is not a food image."
}
- Do NOT proceed to the next stage.

Stage 2: Nutrition Analysis
- Identify the food items.
- Estimate its nutrition values PER 100 grams.
- If there are multiple food items, display name of all food items and concatenate them by a comma and the nutrition value should be average of all the food items Per 100 grams.
- Then respond with ONLY a JSON object in this exact format:

{
  "food": "<name of the food. Capitalize the first letter.>",
  "protein": <grams>,
  "carbohydrates": <grams>,
  "sugar": <grams>,
  "fat": <grams>,
  "energy": <kcal>
}

Do not include any other explanation or text. Only output valid JSON.
""";
  }
}
