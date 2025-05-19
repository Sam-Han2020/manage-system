package org.example.back.controller;

import lombok.RequiredArgsConstructor;
import org.example.back.entity.Article;
import org.example.back.entity.Result;
import org.example.back.service.ArticleService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/articles")
@RequiredArgsConstructor
public class ArticleController {
    private final ArticleService articleService;

    @GetMapping
    public Result<List<Article>> getArticles(
            @RequestParam String authorName,
            @RequestParam(required = false) String title) {

        List<Article> articles = articleService.getArticles(authorName, title);
        return Result.success(articles);
    }

    @PostMapping
    public Result<Void> createArticle(@RequestBody Article article) {
        articleService.createArticle(article);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteArticle(@PathVariable Long id) {
        articleService.deleteArticle(id);
        return Result.success();
    }
    @PutMapping("/{id}")
    public Result<Void> updateArticle(@PathVariable Long id, @RequestBody Article article) {
        articleService.update(article);
        return Result.success();
    }
}