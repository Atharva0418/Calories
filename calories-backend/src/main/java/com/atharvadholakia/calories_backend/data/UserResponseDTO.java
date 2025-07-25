package com.atharvadholakia.calories_backend.data;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserResponseDTO {
    private String Id;
    private String email;

    public UserResponseDTO(String id, String email) {
        this.Id = id;
        this.email = email;
    }
}
