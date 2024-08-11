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

    /**
     * 歌单歌曲列表
     */
    @GetMapping("/album/{dissId}")
    public Mono<ServiceResponse<List<Song>>> getAlbumSongs(@PathVariable("dissId") long dissId) {
        return songService.getAlbumSongs(dissId)
                .map(result -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }

    /**
     * 专辑歌曲列表
     */
    @GetMapping("/public/{albumMid}")
    public Mono<ServiceResponse<List<Song>>> getPublicationSongs(@PathVariable("albumMid") String albumMid, @RequestParam(value = "albumId", required = false) Long albumId) {
        try {
            return songService.getPublicationSongs(albumMid, albumId == null ? 0 : albumId)
                    .map(result -> new ServiceResponse<>(result, true))
                    .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
        } catch (JsonProcessingException e) {
            return Mono.just(new ServiceResponse<>(e.getMessage(), false));
        }
    }

    /**
     * 专辑/歌单 歌单列表，自动识别参数
     */
    @GetMapping("/list/{resId}")
    public Mono<ServiceResponse<List<Song>>> getSongs(@PathVariable("resId") String resId, @RequestParam(value = "albumId", required = false) Long albumId) {
        // dissId 是整型，不可能 '0' 开头
        if (resId.startsWith("0")) {
            return this.getPublicationSongs(resId, albumId);
        } else {
            return this.getAlbumSongs(Long.parseLong(resId));
        }
    }

    /**
     * 歌曲链接
     */
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
