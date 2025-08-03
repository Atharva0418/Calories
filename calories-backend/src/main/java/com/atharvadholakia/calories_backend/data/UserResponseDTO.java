package com.atharvadholakia.calories_backend.data;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserResponseDTO {
    private String name;
    private String Id;
    private String email;

    public UserResponseDTO(String name,String id, String email) {
        this.Id = id;
        this.email = email;
        this.name = name;
    }
}
