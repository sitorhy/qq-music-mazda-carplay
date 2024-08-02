package name.sitorhy.server.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import name.sitorhy.server.model.ServiceResponse;
import name.sitorhy.server.model.Song;
import name.sitorhy.server.model.SongSource;
import name.sitorhy.server.model.SongTypeEnum;
import name.sitorhy.server.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/song")
public class SongController {
    private SongService songService;

    @Autowired
    public SongController(SongService songService) {
        this.songService = songService;
    }

    @GetMapping("/album/{dissId}")
    public Mono<ServiceResponse<List<Song>>> getAlbumSongs(@PathVariable("dissId") long dissId) {
        return songService.getAlbumSongs(dissId)
                .map(result -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    @GetMapping("/source/{songMid}")
    public Mono<ServiceResponse<SongSource>> getSongSource(
            @PathVariable("songMid") String songMid,
            @RequestParam(value = "strMediaMid", required = false) String strMediaMid,
            @RequestParam(value = "type", required = false) String type
    ) {
        try {
            SongTypeEnum songTypeEnum = !StringUtils.hasLength(type) ? SongTypeEnum.MP3_128 : SongTypeEnum.valueOf(type.toUpperCase());
            return songService.getSongSource(songMid, strMediaMid, songTypeEnum)
                    .map(result -> {
                        ServiceResponse<SongSource> response = new ServiceResponse<>(result, true);
                        if (!StringUtils.hasLength(result.getUrl())) {
                            response.setMessage("歌曲已下架");
                        }
                        return response;
                    })
                    .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
        } catch (JsonProcessingException e) {
            return Mono.just(new ServiceResponse<>(e.getMessage(), false));
        }
    }
}
