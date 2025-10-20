package com.atharvadholakia.calories_backend.exceptions;

import java.util.HashMap;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;
import org.springframework.web.reactive.function.client.WebClientResponseException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

  @ExceptionHandler(ResourceNotFoundException.class)
  public ResponseEntity<HashMap<String, String>> handleResourceNotFoundException(
      ResourceNotFoundException ex) {
    String errorMessage = ex.getMessage();

    log.warn(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.NOT_FOUND);
  }

  @ExceptionHandler(MissingServletRequestPartException.class)
  public ResponseEntity<HashMap<String, String>> handleMissingServletRequestPartExcpetion(
      MissingServletRequestPartException ex) {
    String errorMessage = "Please check the correct key parameter.";
    log.warn(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(InvalidImageException.class)
  public ResponseEntity<HashMap<String, String>> handleInvalidImageException(
      InvalidImageException ex) {
    String errorMessage = "Only image(png, jpg/jpeg) files are allowed.";
    log.warn(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(WebClientResponseException.class)
  public ResponseEntity<HashMap<String, String>> handleHttpServerErrorException(
      WebClientResponseException ex) {

    String errorMessage = "Service is busy. Please try again later.";

    log.error(errorMessage);

    return buildErrorResponse(errorMessage, ex.getStatusCode());
  }

  @ExceptionHandler(MaxUploadSizeExceededException.class)
  public ResponseEntity<HashMap<String, String>> handleMaxUploadSizeExceedException(
      MaxUploadSizeExceededException ex) {
    String errorMessage = "Image size exceeds the maximum limit of 5 MB.";
    log.warn(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.PAYLOAD_TOO_LARGE);
  }

  @ExceptionHandler(CustomTimeOutException.class)
  public ResponseEntity<HashMap<String, String>> handleCustomTimeOutException(
      CustomTimeOutException ex) {
    String errorMessage = "Request taking too long. Please try again later.";
    log.error(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.GATEWAY_TIMEOUT);
  }

  @ExceptionHandler(NotAFoodImageException.class)
  public ResponseEntity<?> handleNotAFoodImageExcpetion(NotAFoodImageException ex) {
    String errorMessage = "This is not a food image. Please upload an appropriate image.";
    log.warn(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<HashMap<String, String>> handleMethodArgumentNotValidException(
      MethodArgumentNotValidException ex) {

    HashMap<String, String> allErrors = new HashMap<>();

    ex.getBindingResult()
        .getAllErrors()
        .forEach(
            (error) -> {
              String fieldName = ((FieldError) error).getField();
              String message = error.getDefaultMessage();

              allErrors.put(fieldName, message);
            });

    log.warn("Validation error: {}", allErrors);
    return new ResponseEntity<>(allErrors, HttpStatus.BAD_REQUEST);
  }

  @ExceptionHandler(EmailAlreadyExistsException.class)
  public ResponseEntity<HashMap<String, String>> handleEmailAlreadyExistsException(
      EmailAlreadyExistsException ex) {
    String errorMessage = "Email already registered. Please use a different email.";
    HashMap<String, String> response = new HashMap<>();
    response.put("email", errorMessage);
    log.warn(errorMessage);
    return new ResponseEntity<>(response, HttpStatus.CONFLICT);
  }

  @ExceptionHandler(BadCredentialsException.class)
  public ResponseEntity<HashMap<String, String>> handleBadCredentialsException(
      BadCredentialsException ex) {
    String errorMessage = ex.getMessage();
    HashMap<String, String> response = new HashMap<>();
    response.put("password", errorMessage);
    log.warn(errorMessage);
    return new ResponseEntity<>(response, HttpStatus.CONFLICT);
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<HashMap<String, String>> handleGenericException(Exception ex) {
    String errorMessage = "Internal Server Error. Please try again later.";
    log.error(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.INTERNAL_SERVER_ERROR);
  }

  private ResponseEntity<HashMap<String, String>> buildErrorResponse(
      String message, HttpStatusCode status) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error", message);

    return new ResponseEntity<>(response, status);
  }
}
