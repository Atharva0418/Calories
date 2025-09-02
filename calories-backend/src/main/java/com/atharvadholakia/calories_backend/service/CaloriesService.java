package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.config.ChatSessionManager;
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
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

@Service
@Slf4j
public class CaloriesService {
  private final WebClient webClient;

  private final ServiceConfig serviceConfig;

  private final ObjectMapper objectMapper;

  private final ChatSessionManager chatSessionManager;

  public CaloriesService(
      WebClient webClient,
      ServiceConfig serviceConfig,
      ObjectMapper objectMapper,
      ChatSessionManager chatSessionManager) {
    this.webClient = webClient;
    this.serviceConfig = serviceConfig;
    this.objectMapper = objectMapper;
    this.chatSessionManager = chatSessionManager;
  }

  public Nutrition analyzeImageNutrition(MultipartFile imageFile) {

    String base64Image;
    try {
      base64Image = Base64.getEncoder().encodeToString(imageFile.getBytes());
    } catch (IOException e) {
      throw new RuntimeException(e.getMessage());
    }
    log.info("Forming a request for AI Model.");

    NutritionRequest.SystemInstruction systemInstruction =
        new NutritionRequest.SystemInstruction(
            List.of(new NutritionRequest.TextPart(getNutritionPrompt())));

    NutritionRequest.ImagePart imagePart =
        new NutritionRequest.ImagePart(
            new NutritionRequest.InlineData(
                getMIMEType(imageFile.getOriginalFilename()), base64Image));

    NutritionRequest.Content content = new NutritionRequest.Content("user", List.of(imagePart));

    NutritionRequest request = new NutritionRequest(systemInstruction, List.of(content));

    try {
      log.info("Calling AI Model to analyse the image and predict nutrients.");
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
              .orElse("No response. Please try again.");

      log.info("Successfully receieved response from AI Model.");
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

  public String chatWithAI(String message) {
    log.info("Getting user ID.");
    String userId = getCurrentUserId();

    chatSessionManager.addMessage(
        userId,
        new NutritionRequest.Content("user", List.of(new NutritionRequest.TextPart(message))));

    NutritionRequest.SystemInstruction systemInstruction =
        new NutritionRequest.SystemInstruction(
            List.of(new NutritionRequest.TextPart(getChatPrompt())));

    NutritionRequest request =
        new NutritionRequest(systemInstruction, chatSessionManager.getHistory(userId));

    try {
      log.info("Calling AI Model to chat.");
      NutritionResponse chatResponse =
          webClient
              .post()
              .uri(serviceConfig.getUrl() + "?key=" + serviceConfig.getApiKey())
              .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
              .bodyValue(request)
              .retrieve()
              .bodyToMono(NutritionResponse.class)
              .block();

      String jsonResponse =
          Optional.ofNullable(chatResponse)
              .flatMap(body -> body.getCandidates().stream().findFirst())
              .map(candidate -> candidate.getContent())
              .map(contentObj -> contentObj.getParts())
              .filter(parts -> !parts.isEmpty())
              .map(parts -> parts.get(0).getText())
              .orElse("Server Error. Please try again later.");

      chatSessionManager.addMessage(
          userId,
          new NutritionRequest.Content(
              "model", List.of(new NutritionRequest.TextPart(jsonResponse))));

      log.info("Successfully receieved response from AI Model.");
      return jsonResponse;

    } catch (WebClientResponseException e) {
      throw e;

    } catch (Exception e) {
      throw e;
    }
  }

  // util functions:
  public String getNutritionPrompt() {
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

  public String getChatPrompt() {
    return """
Your name is Calories.
You are a friendly and helpful AI assistant. You answer questions related to food, nutrition, calories, diets, recipes, and healthy eating. You can also provide general information and casual conversation.

Guidelines:
1. Keep responses concise. Do not add unnecessary details.
2. Do not end responses with a question.
3. When a user provides a food or dish name, respond with its nutrition information in the following format:

  "food": "<Food name (capitalize first letter)>",
  "protein": <grams>,
  "carbohydrates": <grams>,
  "sugar": <grams>,
  "fat": <grams>,
  "energy": <kcal>.

4. Always start with a short greeting or encouraging phrase, followed by:
   "Here is the nutrition information for <food name>:"

Notes:
- Do not include JSON tags or code formatting.
- Responses should be natural, friendly, and easy to read.
- If the user talks about non-food topics, Respond politely that your knowledge is about food and nutrition. Keep the replies playful.

""";
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

  public String getCurrentUserId() {
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    return auth.getName();
  }
}
