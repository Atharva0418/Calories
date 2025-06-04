package com.atharvadholakia.calories_backend.exceptions;

import java.util.HashMap;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;

@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(ResourceNotFoundException.class)
  public ResponseEntity<HashMap<String, String>> handleResourceNotFoundException(
      ResourceNotFoundException ex) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error:", ex.getMessage());

    return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
  }

  @ExceptionHandler(MissingServletRequestPartException.class)
  public ResponseEntity<HashMap<String, String>> handleMissingServletRequestPartExcpetion(
      MissingServletRequestPartException ex) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error", "Please check the correct key parameter.");
    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(InvalidImageException.class)
  public ResponseEntity<HashMap<String, String>> handleInvalidImageException(
      InvalidImageException ex) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error", ex.getMessage());
    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(HttpServerErrorException.class)
  public ResponseEntity<HashMap<String, String>> handleHttpServerErrorException(
      HttpServerErrorException ex) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error", "Serivce Unavailable. Please try again later");
    return new ResponseEntity<>(response, HttpStatus.SERVICE_UNAVAILABLE);
  }
}
