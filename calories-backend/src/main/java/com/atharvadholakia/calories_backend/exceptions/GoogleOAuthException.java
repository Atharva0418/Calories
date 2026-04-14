package com.atharvadholakia.calories_backend.exceptions;

public class GoogleOAuthException extends RuntimeException{
    public GoogleOAuthException(String message) {
        super(message);
    }
}
