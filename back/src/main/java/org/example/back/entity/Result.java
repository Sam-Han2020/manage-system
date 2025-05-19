package org.example.back.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Result<T> {
    private Integer code;
    private String message;
    private T datas;

    public static <T> Result<T> success(T datas) {
        return new Result<>(200, "success", datas);
    }

    public static Result<Void> success() {
        return new Result<>(200, "success", null);
    }

    public static Result<Void> error(String message) {
        return new Result<>(500, message, null);
    }
}