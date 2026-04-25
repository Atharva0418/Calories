package com.atharvadholakia.calories_backend.data.authentication;

public record GoogleAuthResponse(
    String accessToken,
    String refreshToken,
    String username,
    String email,
    boolean isNewUser
){}
