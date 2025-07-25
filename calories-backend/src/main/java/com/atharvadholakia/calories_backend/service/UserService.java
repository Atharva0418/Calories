package com.atharvadholakia.calories_backend.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.data.UserResponseDTO;
import com.atharvadholakia.calories_backend.repository.UserRepository;

@Service
public class UserService {

  private final UserRepository userRepository;

  private final PasswordEncoder passwordEncoder;

  public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
  }

  public UserResponseDTO registerUser(SignupRequestDTO signupDTO) {

    User user = new User(signupDTO.getEmail(), passwordEncoder.encode(signupDTO.getPassword()));
    userRepository.save(user);
    return new UserResponseDTO(user.getId(), user.getEmail());
  }
}
