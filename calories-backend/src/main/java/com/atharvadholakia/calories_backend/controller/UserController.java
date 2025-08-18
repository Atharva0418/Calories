package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.RefreshTokenRequest;
import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.TokenResponse;
import com.atharvadholakia.calories_backend.data.UserResponseDTO;
import com.atharvadholakia.calories_backend.security.JwtUtil;
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
@RequestMapping("/auth")
public class UserController {

  private final UserService userService;

  private final JwtUtil jwtUtil;

  public UserController(UserService userService, JwtUtil jwtUtil) {
    this.jwtUtil = jwtUtil;
    this.userService = userService;
  }

  @PostMapping("/signup")
  @ResponseStatus(HttpStatus.CREATED)
  public UserResponseDTO registerUser(@Valid @RequestBody SignupRequestDTO signupDTO) {
    return userService.registerUser(signupDTO);
  }

  @PostMapping("/login")
  @ResponseStatus(HttpStatus.OK)
  public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequestDTO loginDTO) {
    boolean isAuthenticated = userService.authenticateLogin(loginDTO);
    if (isAuthenticated) {
      String accessToken = jwtUtil.generateAccessToken(loginDTO.getEmail());
      String refreshToken = jwtUtil.generateRefreshToken(loginDTO.getEmail());
      return new ResponseEntity<>(new TokenResponse(accessToken, refreshToken), HttpStatus.OK);
    }
    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid password.");
  }

  @PostMapping("/refresh-token")
  public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequest tokenRequest) {
    String refreshToken = tokenRequest.getRefreshToken();
    if (jwtUtil.validateToken(refreshToken)) {
      String email = jwtUtil.extractEmailFromToken(refreshToken);
      String newAccessToken = jwtUtil.generateAccessToken(email);
      return ResponseEntity.status(HttpStatus.OK)
          .body(new TokenResponse(newAccessToken, refreshToken));
    }

    return new ResponseEntity<>("Invalid token", HttpStatus.UNAUTHORIZED);
  }
}
