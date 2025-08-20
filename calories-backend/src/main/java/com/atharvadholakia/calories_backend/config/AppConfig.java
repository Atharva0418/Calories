package com.atharvadholakia.calories_backend.config;

import com.atharvadholakia.calories_backend.security.JwtAuthFilter;
import java.time.Duration;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class AppConfig {

  private final JwtAuthFilter jwtAuthFilter;

  @Bean
  public WebClient webClient() {

    HttpClient httpClient = HttpClient.create().responseTimeout(Duration.ofSeconds(10));

    return WebClient.builder().clientConnector(new ReactorClientHttpConnector(httpClient)).build();
  }

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    return http.csrf(csrf -> csrf.disable())
        .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(
            auth ->
                auth.requestMatchers("/auth/**", "/api/health")
                    .permitAll()
                    .anyRequest()
                    .authenticated())
        .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
        .build();
  }

  @Bean
  public Argon2PasswordEncoder passwordEncoder() {

    int saltLength = 16;
    int hashLength = 32;
    int parallelism = 1;
    int iterations = 3;
    int memory = 65536; // 64 MB
    return new Argon2PasswordEncoder(saltLength, hashLength, parallelism, memory, iterations);
  }
}
