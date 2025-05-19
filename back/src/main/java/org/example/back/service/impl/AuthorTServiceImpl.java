package org.example.back.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import org.example.back.entity.AuthorT;
import org.example.back.mapper.AuthorTMapper;
import org.example.back.service.AuthorTService;
import org.springframework.stereotype.Service;

@Service
public class AuthorTServiceImpl extends ServiceImpl<AuthorTMapper, AuthorT> implements AuthorTService {

    private final AuthorTMapper authorTMapper;

    public AuthorTServiceImpl(AuthorTMapper authorTMapper) {
        this.authorTMapper = authorTMapper;
    }

    @Override
    public Page<AuthorT> getAuthorPage(int page, int size) {
        Page<AuthorT> authorPage = new Page<>(page, size);
        return baseMapper.selectPage(authorPage, null);
    }
    public AuthorT getAuthorByName(String name) {
        return authorTMapper.selectByName(name);
    }
}