package com.atharvadholakia.calories_backend.service;


import java.util.Optional;
import java.util.UUID;

import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.client.WebClient;

import com.atharvadholakia.calories_backend.config.ServiceConfig;
import com.atharvadholakia.calories_backend.data.authentication.AuthResponse;
import com.atharvadholakia.calories_backend.data.authentication.GoogleTokenResponse;
import com.atharvadholakia.calories_backend.data.authentication.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.authentication.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.authentication.User;
import com.atharvadholakia.calories_backend.exceptions.EmailAlreadyExistsException;
import com.atharvadholakia.calories_backend.exceptions.GoogleOAuthException;
import com.atharvadholakia.calories_backend.repository.UserRepository;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class UserService {

  private final UserRepository userRepository;

  private final PasswordEncoder passwordEncoder;

  private final ServiceConfig serviceConfig;

  private final WebClient webClient;

  private final GoogleIdTokenVerifier googleIdTokenVerifier;

  public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, ServiceConfig serviceConfig, WebClient webClient, GoogleIdTokenVerifier googleIdTokenVerifier) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
    this.serviceConfig = serviceConfig;
    this.webClient = webClient;
    this.googleIdTokenVerifier = googleIdTokenVerifier;
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


  public AuthResponse handleGoogleOAuth(String authCode){
    try {

      if(authCode == null || authCode.isBlank()){
        throw new GoogleOAuthException("Missing authorization code.");
      }

      String tokenEndpoint = serviceConfig.getGoogleOauthTokenEndpoint();

      MultiValueMap<String, String> params = new LinkedMultiValueMap<>();

      params.add("code", authCode);
      params.add("client_id", serviceConfig.getGoogleOAuthClientId());
      params.add("client_secret", serviceConfig.getGoogleOAuthClientSecret());
      params.add("redirect_uri", "");
      params.add("grant_type", "authorization_code");

      GoogleTokenResponse tokenResponse = webClient.post()
      .uri(tokenEndpoint)
      .contentType(MediaType.APPLICATION_FORM_URLENCODED)
      .bodyValue(params)
      .retrieve()
      .onStatus(HttpStatusCode::isError, response ->
                response.bodyToMono(String.class)
                        .map(GoogleOAuthException::new)
        )
      .bodyToMono(GoogleTokenResponse.class)
      .block();

      if(tokenResponse == null || tokenResponse.idToken() == null || tokenResponse.idToken().isBlank()){
        throw new GoogleOAuthException("Google did not return a valid token.");
      }

      String id_token = tokenResponse.idToken();

      GoogleIdToken idTokenObj = googleIdTokenVerifier.verify(id_token);

      if(idTokenObj == null){
        throw new GoogleOAuthException("Invalid Google ID Token.");
      }
      
      GoogleIdToken.Payload payload = idTokenObj.getPayload();
      String email = payload.getEmail();
      Boolean emailVerified = payload.getEmailVerified();
      if (emailVerified == null || !emailVerified) {
          throw new GoogleOAuthException("Email not verified by Google.");
      }
      
      String username = Optional.ofNullable((String) payload.get("given_name"))
      .orElse(email.split("@")[0].substring(0,9));

      Optional<User> existingUser = userRepository.findByEmail(email);

      if(existingUser.isPresent()) {
        User user = existingUser.get();
        log.info("User logged in successfully: {}", email);
        return new AuthResponse(user.getEmail(), user.getUsername(), false);

      }

        User newUser = new User(username, email, passwordEncoder.encode(UUID.randomUUID().toString()));
        userRepository.save(newUser);

        AuthResponse registeredUser = new AuthResponse(newUser.getEmail(), newUser.getUsername(), true);

        log.info("User registered successfully: {}", newUser.getEmail());

        return registeredUser;


    } catch (GoogleOAuthException ex){
      throw ex;
    }
    catch (Exception ex) {
      log.error("Unexpected Google OAuth error", ex);
      throw new GoogleOAuthException("Google OAuth authentication failed.");

    }
  }

  public String getUsernameByEmail(String email) {
    Optional<User> user = userRepository.findByEmail(email);
    return user.get().getUsername();
  }
}
