package org.example.back.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data

public class Contact {

    private Long id;
    private String name;
    private Long provinceId;
    private Long cityId;
    private String address;
    private String zip;
    private LocalDateTime createTime;
}