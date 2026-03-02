package com.atharvadholakia.calories_backend.data.authentication;

import com.fasterxml.jackson.annotation.JsonProperty;

public record GoogleTokenResponse(
       @JsonProperty("access_token") String accessToken,
       @JsonProperty("id_token") String idToken,
       @JsonProperty("refresh_token") String refreshToken,
       @JsonProperty("expires_in") Integer expiresIn,
       @JsonProperty("scope") String scope,
       @JsonProperty("token_type") String tokenType) {
}
