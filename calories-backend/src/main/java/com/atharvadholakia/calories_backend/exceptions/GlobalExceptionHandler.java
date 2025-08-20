package com.atharvadholakia.calories_backend.exceptions;

import java.util.HashMap;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import lombok.extern.slf4j.Slf4j;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

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
    //String errorMessage = "Invalid input. Please check the request body.";
    String errorMessage;
    var fieldError = ex.getBindingResult().getFieldError();
    if (fieldError != null) {
      errorMessage = fieldError.getDefaultMessage();
    } else {
      errorMessage = "Invalid input. Please check the request body.";
    }
    log.warn(errorMessage);
    return buildErrorResponse(errorMessage, HttpStatus.BAD_REQUEST);
  }

  // @ExceptionHandler(Exception.class)
  // public ResponseEntity<HashMap<String, String>> handleGenericException(Exception ex) {
  //   String errorMessage = "Internal Server Error. Please try again later.";
  //   log.error(errorMessage);
  //   return buildErrorResponse(errorMessage, HttpStatus.INTERNAL_SERVER_ERROR);
  // }

  private ResponseEntity<HashMap<String, String>> buildErrorResponse(
      String message, HttpStatusCode status) {
    HashMap<String, String> response = new HashMap<>();
    response.put("Error", message);

    return new ResponseEntity<>(response, status);
  }
}
