package com.atharvadholakia.calories_backend.data;

import com.atharvadholakia.calories_backend.data.foodlog.FoodLog;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  private String id;

  private String username;

  @Column(unique = true, nullable = false)
  private String email;

  private String hashedPassword;

  @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
  private List<FoodLog> foodLogs;

  public User(String username, String email, String hashedPassword) {
    this.email = email;
    this.hashedPassword = hashedPassword;
    this.username = username;
  }

  @Override
  public String toString() {
    return "User{" + "id=" + id + ", username='" + username + '\'' + '}';
  }
}
