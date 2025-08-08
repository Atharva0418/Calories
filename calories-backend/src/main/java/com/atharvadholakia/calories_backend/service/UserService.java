package com.atharvadholakia.calories_backend.service;

import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.data.UserResponseDTO;
import com.atharvadholakia.calories_backend.exceptions.EmailAlreadyExistsException;
import com.atharvadholakia.calories_backend.repository.UserRepository;

import lombok.extern.slf4j.Slf4j;

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

    User user = new User(signupDTO.getUsername(), signupDTO.getEmail(), passwordEncoder.encode(signupDTO.getPassword()));
    userRepository.save(user);
    log.info("User registered successfully: {}", user.getEmail());
    return new UserResponseDTO(user.getUsername(), user.getId(), user.getEmail());
  }
}
