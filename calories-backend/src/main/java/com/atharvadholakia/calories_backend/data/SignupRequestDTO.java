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

  @NotBlank(message = "Please enter a username.")
  @Pattern(
      regexp = "^[a-zA-Z0-9]{1,12}$",
      message = "Username can be up to 12 characters and can only contain letters and digits.")
  private String username;

  @NotBlank()
  @Pattern(
      regexp = "^(?=.{1,254}$)([a-zA-Z0-9._%+-]{1,64})@([a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})$",
      message = "Please use a valid email.") 
  private String email;

  @NotBlank()
  @Pattern(
      regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$#_!%*?&])[A-Za-z\\d@#$!_%*?&]{8,27}$",
      message =
          "Password must have 8-27 characters, including uppercase, lowercase, number, and special character.")
  private String password;

  public String getUsername() {
    return this.username;
  }

  public String getEmail() {
    return this.email;
  }

  public String getPassword() {
    return this.password;
  }
}
