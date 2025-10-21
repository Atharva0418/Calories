package com.atharvadholakia.calories_backend.data.foodlog;

import com.atharvadholakia.calories_backend.data.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import java.time.OffsetDateTime;
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

  private OffsetDateTime timeStamp;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
  @JsonIgnore
  private User user;

  @PrePersist
  public void setTimeStamp() {
    this.timeStamp = OffsetDateTime.now();
  }
}
