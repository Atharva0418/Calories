package com.atharvadholakia.calories_backend.exceptions;

public class EmailNotFoundException extends RuntimeException {
  public EmailNotFoundException(String message) {
    super(message);
  }
}
