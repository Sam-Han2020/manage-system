package org.example.back.entity;

import lombok.Data;

@Data
public class UpdateUserT {
    String username;
    String old_password;
    String new_password;
}
