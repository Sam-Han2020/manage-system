package org.example.back.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import org.example.back.entity.AuthorT;


public interface AuthorTService extends IService<AuthorT> {
    /**
     * 按作者名查询
     * @param name 作者名
     * @return 作者对象
     */
    Page<AuthorT> getAuthorPage(int page, int size);


    AuthorT getAuthorByName(String name);
}