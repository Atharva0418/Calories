package com.atharvadholakia.calories_backend.service;

import com.atharvadholakia.calories_backend.data.SignupRequestDTO;
import com.atharvadholakia.calories_backend.data.User;
import com.atharvadholakia.calories_backend.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {

  private final UserRepository userRepository;

  public UserService(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  public User registerUser(SignupRequestDTO signupDTO) {
    User registeredUser = new User(signupDTO.getEmail(), signupDTO.getPassword());
    userRepository.save(registeredUser);
    return registeredUser;
  }
}
