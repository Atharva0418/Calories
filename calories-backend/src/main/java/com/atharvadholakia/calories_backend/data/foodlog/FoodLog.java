package com.atharvadholakia.calories_backend.data.foodlog;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import java.time.Instant;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FoodLog {

  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  private String id;

  private String foodName;
  private float weight;
  private float protein;
  private float fat;
  private float carbohydrates;
  private float sugar;
  private float energy;

  private Instant timeStamp;

  @PrePersist
  public void setTimeStamp() {
    this.timeStamp = Instant.now();
  }
}
