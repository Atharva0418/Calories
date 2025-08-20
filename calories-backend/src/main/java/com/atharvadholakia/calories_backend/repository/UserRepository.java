package com.atharvadholakia.calories_backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.atharvadholakia.calories_backend.data.User;

public interface UserRepository extends JpaRepository<User, String> {

    Optional<User> findByEmail(String email);
}
