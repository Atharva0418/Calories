package com.atharvadholakia.calories_backend.security;

import com.atharvadholakia.calories_backend.repository.UserRepository;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

  private final UserRepository userRepository;

  private final JwtUtil jwtUtil;

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws IOException, ServletException {

    String authHeader = request.getHeader("Authorization");

    if (authHeader != null && authHeader.startsWith("Bearer ")) {
      String token = authHeader.substring(7);

      try {
        String email = jwtUtil.extractEmailFromToken(token);
        userRepository
            .findByEmail(email)
            .ifPresent(
                (user) -> {
                  UsernamePasswordAuthenticationToken auth =
                      new UsernamePasswordAuthenticationToken(user, null, List.of());
                  SecurityContextHolder.getContext().setAuthentication(auth);
                });
      } catch (JwtException e) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response
            .getWriter()
            .write(
                """
                {
                "Error": "Unauthorized access. Invalid or expired token."
                }
                """);
        return;
      }
    }

    filterChain.doFilter(request, response);
  }
}
