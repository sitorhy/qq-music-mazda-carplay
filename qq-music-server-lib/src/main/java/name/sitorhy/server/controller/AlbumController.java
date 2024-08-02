package name.sitorhy.server.controller;

import name.sitorhy.server.model.Album;
import name.sitorhy.server.model.ServiceResponse;
import name.sitorhy.server.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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

    @GetMapping("/my")
    Mono<ServiceResponse<List<Album>>> getMyAlbums() {
        return albumService.getMyAlbums()
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }
}
