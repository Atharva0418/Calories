package com.atharvadholakia.calories_backend.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class ApiKeyAuthFilter extends OncePerRequestFilter {

  @Value("${X_API_KEY}")
  private String xApiKey;

  private static final String API_KEY_HEADER = "x-api-key";

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws ServletException, IOException {

    String path = request.getRequestURI();
    if (path.equals("/api/health")) {
      filterChain.doFilter(request, response);
      return;
    }

    String requestApiKey = request.getHeader(API_KEY_HEADER);

    if (requestApiKey == null || !requestApiKey.equals(xApiKey)) {
      response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
      response
          .getWriter()
          .write(
              """
              {
                  "Error" : "Unauthorized access. Invalid or missing API key."
              }
              """);

      return;
    }

    filterChain.doFilter(request, response);
  }
}
