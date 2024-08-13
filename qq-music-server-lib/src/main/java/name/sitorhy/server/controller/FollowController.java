package name.sitorhy.server.controller;

import name.sitorhy.server.model.ServiceResponse;
import name.sitorhy.server.model.Singer;
import name.sitorhy.server.service.FollowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/follow")
public class FollowController {
    private FollowService followService;

    @Autowired
    public void setFollowService(FollowService followService) {
        this.followService = followService;
    }

    @GetMapping("/singers")
    public Mono<ServiceResponse<List<Singer>>> getFollowSingers(
            @RequestParam(value = "pageNo", required = false, defaultValue = "1") Long pageNo,
            @RequestParam(value = "pageSize", required = false, defaultValue = "12") Long pageSize
    ) {
        return followService.getFollowSingers(pageNo, pageSize)
                .map((result) -> new ServiceResponse<>(result, true))
                .onErrorResume(ex -> Mono.just(new ServiceResponse<>(ex.getMessage(), false)));
    }
}
