package org.example.back.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@TableName("authort") // 修正表名（原表名可能拼写错误，应为author）
public class AuthorT {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;        // 作者名（唯一）
    private String email;       // 邮箱
    private BigDecimal money;   // 余额（保留两位小数）
    private LocalDate birthday; // 生日（Java 8+ LocalDate类型）
    private String avatar;// 头像URL
    @TableField("article_count")
    private Integer articleCount;
}