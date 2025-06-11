package com.atharvadholakia.calories_backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ServiceConfig {

  @Value("${MODEL_API_KEY}")
  private String apiKey;

  @Value("${API_URL}")
  private String URL;

  public String getApiKey() {
    return apiKey;
  }

  public String getUrl() {
    return URL;
  }
}
