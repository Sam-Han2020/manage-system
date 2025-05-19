package org.example.back.controller;


import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.back.entity.AuthorT;
import org.example.back.service.AuthorTService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/authorts")
@RequiredArgsConstructor
public class AuthorTController {

    private final AuthorTService authorTService;

    /**
     * 按作者名查询
     * @param name 作者名
     * @return 作者信息
     */
    @GetMapping("/{name}")
    public ResponseEntity<AuthorT> getAuthorByName(@PathVariable String name) {
        AuthorT author = authorTService.getAuthorByName(name);
        if (author == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // 404未找到
        }
        return ResponseEntity.ok(author);
    }
    @GetMapping
    public Page<AuthorT> getAuthors(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        System.out.println(page+"页"+size);
        return authorTService.getAuthorPage(page+1, size); // 前端page从1开始，MyBatis-Plus分页从0开始
    }

    // 其他CRUD接口（可选）
    // @PostMapping 新增作者
    // @PutMapping 更新作者
    // @DeleteMapping 删除作者
    // @GetMapping 分页查询作者列表
}