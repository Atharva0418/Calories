package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.GeminiRequest;
import com.atharvadholakia.calories_backend.data.GeminiResponse;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class GeminiService {

  @Value("${gemini.api.key}")
  private String apikey;

  private static final String URL =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

  private final RestTemplate restTemplate = new RestTemplate();

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
}
