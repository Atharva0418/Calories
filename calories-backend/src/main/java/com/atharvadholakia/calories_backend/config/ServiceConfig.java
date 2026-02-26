package com.atharvadholakia.calories_backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ServiceConfig {

  @Value("${MODEL_API_KEY}")
  private String apiKey;

  @Value("${API_URL}")
  private String URL;

  @Value("${GOOGLE_OAUTH_CLIENT_ID}")
  private String google_oauth_clientId;

  @Value("${GOOGLE_OAUTH_CLIENT_SECRET}")
  private String google_oauth_clientSecret;

  public String getApiKey() {
    return apiKey;
  }

  public String getUrl() {
    return URL;
  }

  public String getGoogleOAuthClientId(){
    return google_oauth_clientId;
  }

  public String getGoogleOAuthClientSecret(){
    return google_oauth_clientSecret;
  }
}
