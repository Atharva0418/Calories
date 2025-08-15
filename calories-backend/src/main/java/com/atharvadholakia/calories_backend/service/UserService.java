package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.LoginRequestDTO;
import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.data.UserResponseDTO;
import com.atharvadholakia.calories_backend.exceptions.EmailAlreadyExistsException;
import com.atharvadholakia.calories_backend.exceptions.EmailNotFoundException;
import com.atharvadholakia.calories_backend.repository.UserRepository;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
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

  public UserResponseDTO registerUser(SignupRequestDTO signupDTO) {

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
    return new UserResponseDTO(user.getUsername(), user.getId(), user.getEmail());
  }

  public boolean authenticateLogin(LoginRequestDTO loginDTO) {
    Optional<User> User = userRepository.findByEmail(loginDTO.getEmail());
    if (!User.isPresent()) {
      log.warn("Authentication failed: User not found with email {}", loginDTO.getEmail());
      throw new EmailNotFoundException("No user found with the provided email.");
    }

    if (!passwordEncoder.matches(loginDTO.getPassword(), User.get().getHashedPassword())) {
      log.warn("Authentication failed: Incorrect password for email {}", loginDTO.getEmail());
      return false;
    }

    return true;
  }
}
