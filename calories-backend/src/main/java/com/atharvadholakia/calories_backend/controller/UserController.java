package com.atharvadholakia.calories_backend.controller;

import com.atharvadholakia.calories_backend.data.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.RefreshTokenRequest;
import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.TokenResponse;
import com.atharvadholakia.calories_backend.security.JwtUtil;
import com.atharvadholakia.calories_backend.service.UserService;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@Slf4j
public class UserController {

  private final UserService userService;

  private final JwtUtil jwtUtil;

  public UserController(UserService userService, JwtUtil jwtUtil) {
    this.jwtUtil = jwtUtil;
    this.userService = userService;
  }

  @PostMapping("/signup")
  public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequestDTO signupDTO) {
    log.info("Calling service to register user.");
    boolean isRegistered = userService.registerUser(signupDTO);
    if (isRegistered) {
      String accessToken = jwtUtil.generateAccessToken(signupDTO.getEmail());
      String refreshToken = jwtUtil.generateRefreshToken(signupDTO.getEmail());
      return new ResponseEntity<>(
          new TokenResponse(accessToken, refreshToken, signupDTO.getUsername()),
          HttpStatus.CREATED);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }

  @PostMapping("/login")
  @ResponseStatus(HttpStatus.OK)
  public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequestDTO loginDTO) {
    log.info("Calling service to authenticate user.");
    boolean isAuthenticated = userService.authenticateLogin(loginDTO);
    if (isAuthenticated) {
      String accessToken = jwtUtil.generateAccessToken(loginDTO.getEmail());
      String refreshToken = jwtUtil.generateRefreshToken(loginDTO.getEmail());
      String username = userService.getUsernameByEmail(loginDTO.getEmail());
      return new ResponseEntity<>(
          new TokenResponse(accessToken, refreshToken, username), HttpStatus.OK);
    }
    return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
  }

  @PostMapping("/refresh-token")
  public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequest tokenRequest) {
    String refreshToken = tokenRequest.getRefreshToken();
    log.info("Received refresh token: {}");
    if (jwtUtil.validateToken(refreshToken)) {
      String email = jwtUtil.extractEmailFromToken(refreshToken);
      String newAccessToken = jwtUtil.generateAccessToken(email);
      String newRefreshToken = jwtUtil.generateRefreshToken(email);
      log.info("Generated new access token and refresh token for email: {}", email);
      return ResponseEntity.status(HttpStatus.OK)
          .body(new TokenResponse(newAccessToken, newRefreshToken, null));
    }
    log.warn("Invalid refresh token.");
    return new ResponseEntity<>("Invalid token", HttpStatus.UNAUTHORIZED);
  }
}
