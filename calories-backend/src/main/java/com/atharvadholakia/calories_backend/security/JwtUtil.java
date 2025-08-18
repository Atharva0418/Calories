package com.atharvadholakia.calories_backend.security;

import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;

public class JwtUtil {

  private static final String SECRET = "V9vAllIpu6TfN2B3z7eAc9RwVhQ8mX1a+0X4U2rT6sW=";
  private static final Key key = Keys.hmacShaKeyFor(SECRET.getBytes());

  public static String generateAccessToken(String email) {
    return Jwts.builder()
        .setSubject(email)
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 15 * 60 * 1000))
        .signWith(key, SignatureAlgorithm.HS256)
        .compact();
  }

  public static String generateRefreshToken(String email) {
    return Jwts.builder()
        .setSubject(email)
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000))
        .signWith(key, SignatureAlgorithm.HS256)
        .compact();
  }

  public static boolean validateToken(String token) {
    try {
      Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
      return true;
    } catch (JwtException e) {
      return false;
    }
  }

  public static String extractEmailFromToken(String token) {
    return Jwts.parserBuilder()
        .setSigningKey(key)
        .build()
        .parseClaimsJws(token)
        .getBody()
        .getSubject();
  }
}
