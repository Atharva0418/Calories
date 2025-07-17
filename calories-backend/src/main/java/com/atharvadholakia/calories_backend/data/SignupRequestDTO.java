package com.atharvadholakia.calories_backend.data;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SignupRequestDTO {

  @NotBlank @Email private String email;

  @NotBlank
  @Size(min = 8, max = 27, message = "Password must be between 8 to 27 characters.")
  private String password;

  public String getEmail() {
    return this.email;
  }

  public String getPassword() {
    return this.password;
  }
}
