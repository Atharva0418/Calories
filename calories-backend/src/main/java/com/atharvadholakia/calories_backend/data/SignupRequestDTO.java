package com.atharvadholakia.calories_backend.data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SignupRequestDTO {

  @NotBlank(message = "Name cannot be blank.")
  @Pattern(
      regexp = "^[a-zA-Z]{1,12}$",
      message = "Name can be upto 12 characters and can only contain letters.")
  private String name;

  @NotBlank()
  @Pattern(
      regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$",
      message = "Please use a valid email.") 
  private String email;

  @NotBlank()
  @Pattern(
      regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$#!%*?&])[A-Za-z\\d@#$!%*?&]{8,27}$",
      message =
          "Password must contain at least one uppercase letter, one lowercase letter, one digit, one special character and must be between 8 to 27 characters.")
  private String password;

  public String getName() {
    return this.name;
  }

  public String getEmail() {
    return this.email;
  }

  public String getPassword() {
    return this.password;
  }
}
