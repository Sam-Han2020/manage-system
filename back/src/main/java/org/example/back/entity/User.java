package org.example.back.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
@Data
@TableName("user")

public class User {

    @TableId(type = IdType.AUTO)
    private Long id;
    private String date;        // 日期
    private String name;        // 姓名
    private String province;        // 城市
    private String city;        // 地区
    private String address;     // 地址
    private String zip;         // 邮编
}