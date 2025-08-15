package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.UserResponseDTO;
import com.atharvadholakia.calories_backend.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class UserController {

  private final UserService userService;

  public UserController(UserService userService) {
    this.userService = userService;
  }

  @PostMapping("/signup")
  @ResponseStatus(HttpStatus.CREATED)
  public UserResponseDTO registerUser(@Valid @RequestBody SignupRequestDTO signupDTO) {
    return userService.registerUser(signupDTO);
  }

  @PostMapping("/login")
  @ResponseStatus(HttpStatus.OK)
  public ResponseEntity<String> authenticateUser(@Valid @RequestBody LoginRequestDTO loginDTO) {
    boolean isAuthenticated = userService.authenticateLogin(loginDTO);
    if (!isAuthenticated) {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid password.");
    }
    return new ResponseEntity<>("Login Successful!", HttpStatus.OK);
  }
}
