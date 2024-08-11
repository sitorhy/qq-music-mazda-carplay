package name.sitorhy.server.controller;

import name.sitorhy.server.model.Album;
import name.sitorhy.server.model.ServiceResponse;
import name.sitorhy.server.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/album")
public class AlbumController {
    AlbumService albumService;

    @Autowired
    public void setAlbumService(AlbumService albumService) {
        this.albumService = albumService;
    }

    /**
     * 自建歌单
     */
    @GetMapping("/my")
    Mono<ServiceResponse<List<Album>>> getMyAlbums() {
        return albumService.getMyAlbums()
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 收藏的歌单
     */
    @GetMapping("/fav")
    Mono<ServiceResponse<List<Album>>> getMyFavAlbums(
            @RequestParam(value = "pageNo", required = false, defaultValue = "0") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "12") Long pageSize
    ) {
        return albumService.getMyFavAlbums(pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 收藏的有版权发行专辑
     */
    @GetMapping("/public")
    Mono<ServiceResponse<List<Album>>> getMyFavPublication(
            @RequestParam(value = "pageNo", required = false, defaultValue = "0") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "12") Long pageSize
    ) {
        return albumService.getMyFavPublication(pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }
}
