package org.example.back.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import lombok.RequiredArgsConstructor;
import org.example.back.entity.Article;
import org.example.back.entity.AuthorT;
import org.example.back.mapper.ArticleMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleService {
    private final ArticleMapper articleMapper;
    private final AuthorTService authorTService;

    public List<Article> getArticles(String authorName, String title) {
        LambdaQueryWrapper<Article> query = new LambdaQueryWrapper<>();
        query.eq(Article::getAuthorName, authorName);
        if (StringUtils.isNotBlank(title)) {
            query.like(Article::getTitle, title);
        }
        return articleMapper.selectList(query);
    }

    public void createArticle(Article article) {
        // 验证作者存在
        AuthorT authorT = authorTService.getAuthorByName(article.getAuthorName());
        if (authorT == null) {
            throw new RuntimeException("作者不存在");
        }
        articleMapper.insert(article);
    }

    public void deleteArticle(Long id) {
        articleMapper.deleteById(id);
    }

    public void update(Article article) {
        articleMapper.updateById(article);
    }
}