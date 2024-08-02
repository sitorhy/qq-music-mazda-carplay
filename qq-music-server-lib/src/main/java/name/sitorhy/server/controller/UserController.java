package name.sitorhy.server.controller;

import name.sitorhy.server.model.TextServiceResponse;
import name.sitorhy.server.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/user")
public class UserController {
    private UserService userService;

    @Autowired
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/cookie")
    public Mono<TextServiceResponse> setCookie(@RequestBody String cookie) {
        userService.setCookie(cookie);
        return Mono.just(new TextServiceResponse());
    }

    @GetMapping("/cookie")
    public Mono<TextServiceResponse> getCookie() {
        return Mono.just(new TextServiceResponse(userService.getCookie()));
    }
}
