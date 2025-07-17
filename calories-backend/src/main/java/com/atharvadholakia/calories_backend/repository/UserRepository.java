package com.atharvadholakia.calories_backend.repository;

import com.atharvadholakia.calories_backend.data.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, String> {}
