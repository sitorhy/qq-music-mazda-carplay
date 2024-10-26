package name.sitorhy.server.controller;

import name.sitorhy.server.model.Category;
import name.sitorhy.server.model.CategoryGroup;
import name.sitorhy.server.model.ServiceResponse;
import name.sitorhy.server.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/category")
public class CategoryController {
    private CategoryService categoryService;

    @Autowired
    public void setAlbumService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    /**
     * 首页推荐分类的信息，解析HTML耗时长，前端需要缓存该结果
     */
    @GetMapping("/list")
    Mono<ServiceResponse<List<CategoryGroup>>> getRecommendCategories() {
        return categoryService.getCategories()
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 自动识别分类
     */
    @GetMapping("/detail")
    Mono<ServiceResponse<Category>> getCategoryDetail(
            @RequestParam(value = "type", required = false, defaultValue = "RECOMMEND_FOR_ME") String type,
            @RequestParam(value = "code", required = false, defaultValue = "1") Long code,
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "25") Long pageSize
    ) {
        return categoryService.getCategoryDetail(type.toUpperCase(), code, pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 为你推荐
     */
    @GetMapping("/recommend/me")
    Mono<ServiceResponse<Category>> getRecommendForMe(
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "25") Long pageSize
    ) {
        return categoryService.getRecommendForMe(pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 歌单推荐
     */
    @GetMapping("/recommend")
    Mono<ServiceResponse<Category>> getRecommend(
            @RequestParam(value = "code", required = false, defaultValue = "1") Long code,
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "25") Long pageSize
    ) {
        return categoryService.getRecommend(code, pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 新碟
     */
    @GetMapping("/album")
    Mono<ServiceResponse<Category>> getNewAlbum(
            @RequestParam(value = "code", required = false, defaultValue = "1") Long code,
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "25") Long pageSize
    ) {
        return categoryService.getNewAlbum(code, pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 新歌
     */
    @GetMapping("/song")
    Mono<ServiceResponse<Category>> getNewSong(
            @RequestParam(value = "code", required = false, defaultValue = "1") Long code,
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "25") Long pageSize
    ) {
        return categoryService.getNewSong(code, pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 排行榜
     */
    @GetMapping("/top")
    Mono<ServiceResponse<Category>> getTopList(
            @RequestParam(value = "code", required = false, defaultValue = "1") Long code,
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "20") Long pageSize
    ) {
        return categoryService.getTopList(code, pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }
}
