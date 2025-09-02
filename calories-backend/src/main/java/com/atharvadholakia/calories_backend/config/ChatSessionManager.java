package com.atharvadholakia.calories_backend.config;

import com.atharvadholakia.calories_backend.data.NutritionRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Component;

@Component
public class ChatSessionManager {
  private final Map<String, List<NutritionRequest.Content>> sessions = new ConcurrentHashMap<>();

  public List<NutritionRequest.Content> getHistory(String userId) {
    return sessions.computeIfAbsent(userId, k -> new ArrayList<>());
  }

  public void addMessage(String userId, NutritionRequest.Content content) {
    getHistory(userId).add(content);
  }

  public void clearHistory(String userId) {
    sessions.remove(userId);
  }
}
