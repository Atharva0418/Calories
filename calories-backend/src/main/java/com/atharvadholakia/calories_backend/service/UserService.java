package com.atharvadholakia.calories_backend.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.data.UserResponseDTO;
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

    User user = new User(signupDTO.getName(), signupDTO.getEmail(), passwordEncoder.encode(signupDTO.getPassword()));
    userRepository.save(user);
    log.info("User registered successfully: {}", user.getEmail());
    return new UserResponseDTO(user.getName(), user.getId(), user.getEmail());
  }
}
