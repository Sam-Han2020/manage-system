package org.example.back.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("t_region")
public class Region {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private Integer level; // 1-省 2-市
    @TableField("parent_id")
    private Long parentId;
}