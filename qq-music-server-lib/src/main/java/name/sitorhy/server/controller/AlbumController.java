package name.sitorhy.server.controller;

import name.sitorhy.server.model.Album;
import name.sitorhy.server.model.ServiceResponse;
import name.sitorhy.server.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/album")
public class AlbumController {
    private AlbumService albumService;

    @Autowired
    public void setAlbumService(AlbumService albumService) {
        this.albumService = albumService;
    }

    /**
     * 自建歌单
     */
    @GetMapping("/my/albums")
    Mono<ServiceResponse<List<Album>>> getMyAlbums() {
        return albumService.getMyAlbums()
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 收藏的歌单
     */
    @GetMapping("/fav/albums")
    Mono<ServiceResponse<List<Album>>> getMyFavAlbums(
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "12") Long pageSize
    ) {
        return albumService.getMyFavAlbums(pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 收藏的有版权发行专辑
     */
    @GetMapping("/fav/public")
    Mono<ServiceResponse<List<Album>>> getMyFavPublication(
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "12") Long pageSize
    ) {
        return albumService.getMyFavPublication(pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    @GetMapping("/singer/public/{singerMid}")
    public Mono<ServiceResponse<List<Album>>> getSingerPublication(
            @PathVariable(value = "singerMid") String singerMid,
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "12") Long pageSize
    ) {
        return albumService.getSingerPublication(singerMid, pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }
}
