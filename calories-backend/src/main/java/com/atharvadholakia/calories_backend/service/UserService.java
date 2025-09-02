package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.exceptions.EmailAlreadyExistsException;
import com.atharvadholakia.calories_backend.repository.UserRepository;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class UserService {

  private final UserRepository userRepository;

  private final PasswordEncoder passwordEncoder;

  public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
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
    Optional<User> User = userRepository.findByEmail(loginDTO.getEmail());
    if (!User.isPresent()) {
      log.warn("Authentication failed: User not found with email {}", loginDTO.getEmail());
      throw new BadCredentialsException("Invalid credentials.");
    }

    if (!passwordEncoder.matches(loginDTO.getPassword(), User.get().getHashedPassword())) {
      log.warn("Authentication failed: Invalid password for email {}", loginDTO.getEmail());
      throw new BadCredentialsException("Invalid credentials.");
    }

    log.info("User authenticated successfully: {}");
    return true;
  }
}
