package com.atharvadholakia.calories_backend.service;


import java.util.*;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.client.WebClient;

import com.atharvadholakia.calories_backend.config.ServiceConfig;
import com.atharvadholakia.calories_backend.data.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.exceptions.EmailAlreadyExistsException;
import com.atharvadholakia.calories_backend.repository.UserRepository;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class UserService {

  private final UserRepository userRepository;

  private final PasswordEncoder passwordEncoder;

  private final ServiceConfig serviceConfig;

  private final WebClient webClient;

  public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, ServiceConfig serviceConfig, WebClient webClient) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
    this.serviceConfig = serviceConfig;
    this.webClient = webClient;
  }

  public boolean registerUser(SignupRequestDTO signupDTO) {

    Optional<User> existingUser = userRepository.findByEmail(signupDTO.getEmail());
    if (existingUser.isPresent()) {
      log.warn("Email already registered: {}", signupDTO.getEmail());
      throw new EmailAlreadyExistsException();
    }
    User user =
        new User(
            signupDTO.getUsername(),
            signupDTO.getEmail(),
            passwordEncoder.encode(signupDTO.getPassword()));
    userRepository.save(user);
    log.info("User registered successfully: {}", user.getEmail());
    return true;
  }

  public boolean authenticateLogin(LoginRequestDTO loginDTO) {
    log.info("Authenticating user with email: {}", loginDTO.getEmail());
    Optional<User> user = userRepository.findByEmail(loginDTO.getEmail());
    if (user.isEmpty()) {
      log.warn("Authentication failed: User not found with email {}", loginDTO.getEmail());
      throw new BadCredentialsException("Invalid credentials.");
    }

    if (!passwordEncoder.matches(loginDTO.getPassword(), user.get().getHashedPassword())) {
      log.warn("Authentication failed: Invalid password for email {}", loginDTO.getEmail());
      throw new BadCredentialsException("Invalid credentials.");
    }

    log.info("User authenticated successfully.");
    return true;
  }


  public HashMap<String, String> handleGoogleOAuth(String authCode){
    try {

      String tokenEndpoint = "https://oauth2.googleapis.com/token";

      MultiValueMap<String, String> params = new LinkedMultiValueMap<>();

      params.add("code", authCode);
      params.add("client_id", serviceConfig.getGoogleOAuthClientId());
      params.add("client_secret", serviceConfig.getGoogleOAuthClientSecret());
      params.add("redirect_uri", "https://developers.google.com/oauthplayground");
      params.add("grant_type", "authorization_code");

      Map tokenResponse = webClient.post()
      .uri(tokenEndpoint)
      .contentType(MediaType.APPLICATION_FORM_URLENCODED)
      .bodyValue(params)
      .retrieve()
      .onStatus(HttpStatusCode::isError, response ->
                response.bodyToMono(String.class)
                        .map(body -> new RuntimeException("Google Error: " + body))
        )
      .bodyToMono(Map.class)
      .block();

      String id_token = (String)tokenResponse.get("id_token");

      GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
              .setAudience(Collections.singleton(serviceConfig.getGoogleOAuthClientId()))
              .build();

      GoogleIdToken idTokenObj = verifier.verify(id_token);

      if(idTokenObj != null){
        GoogleIdToken.Payload payload = idTokenObj.getPayload();
        String email = payload.getEmail();
        String username = (String)payload.get("given_name");

        Optional<User> user = userRepository.findByEmail(email);

        if(user.isEmpty()) {
          User newUser = new User(username, email, passwordEncoder.encode(UUID.randomUUID().toString()));
          userRepository.save(newUser);

          HashMap<String, String> registeredUser = new HashMap<>();
          registeredUser.put("email", newUser.getEmail());
          registeredUser.put("username", newUser.getUsername());

          log.info("User registered successfully: {}", newUser.getEmail());

          return registeredUser;
        }else{
          log.info("User logged in successfully: {}", email);
          HashMap<String, String> existingUser = new HashMap<>();
          existingUser.put("email", user.get().getEmail());
          existingUser.put("username", user.get().getUsername());

          return existingUser;
        }

      }


    } catch (Exception e) {
      System.out.println(e);
    }

    return new HashMap<>();
  }

  public String getUsernameByEmail(String email) {
    Optional<User> user = userRepository.findByEmail(email);
    return user.get().getUsername();
  }
}
