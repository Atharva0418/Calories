package com.atharvadholakia.calories_backend.exceptions;

import java.util.HashMap;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;

@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(ResourceNotFoundException.class)
  public ResponseEntity<HashMap<String, String>> handleResourceNotFoundException(
      ResourceNotFoundException ex) {
    return buildErrorResponse(ex.getMessage(), HttpStatus.NOT_FOUND);
  }

  @ExceptionHandler(MissingServletRequestPartException.class)
  public ResponseEntity<HashMap<String, String>> handleMissingServletRequestPartExcpetion(
      MissingServletRequestPartException ex) {
    return buildErrorResponse("Please check the correct key parameter.", HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(InvalidImageException.class)
  public ResponseEntity<HashMap<String, String>> handleInvalidImageException(
      InvalidImageException ex) {
    return buildErrorResponse(
        "Only image(png, jpg/jpeg) files are allowed.", HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(HttpServerErrorException.class)
  public ResponseEntity<HashMap<String, String>> handleHttpServerErrorException(
      HttpServerErrorException ex) {
    return buildErrorResponse(
        "Service Unavailable.Please try again later.", HttpStatus.SERVICE_UNAVAILABLE);
  }

  @ExceptionHandler(MaxUploadSizeExceededException.class)
  public ResponseEntity<HashMap<String, String>> handleMaxUploadSizeExceedException(
      MaxUploadSizeExceededException ex) {
    return buildErrorResponse(
        "Image size exceeds the maximum limit of 5 MB", HttpStatus.PAYLOAD_TOO_LARGE);
  }

  @ExceptionHandler(CustomTimeOutException.class)
  public ResponseEntity<HashMap<String, String>> handleCustomTimeOutException(
      CustomTimeOutException ex) {
    return buildErrorResponse(
        "Request taking too long. Please try again later.", HttpStatus.GATEWAY_TIMEOUT);
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<HashMap<String, String>> handleGenericException(Exception ex) {
    return buildErrorResponse(
        "Internal Server Error. Please try again later.", HttpStatus.INTERNAL_SERVER_ERROR);
  }

  private ResponseEntity<HashMap<String, String>> buildErrorResponse(
      String message, HttpStatus status) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error", message);

    return new ResponseEntity<>(response, status);
  }
}
