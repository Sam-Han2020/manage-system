package org.example.back.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user")
public class UserT {
    @TableId(type = IdType.AUTO)
    private Integer id;
    private String name;
    private String password;
    private String email;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ssXXX")
    private String birthday;
    private Double money;
    private String avatar;

    // 省略 getter 和 setter 方法
}
    