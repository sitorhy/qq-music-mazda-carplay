package name.sitorhy.server.utils;

import name.sitorhy.server.session.RequestHeadersSession;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.web.reactive.function.client.WebClient;

import java.net.URI;
import java.util.Map;

public class WebClientUtils {
    // 扩大接收缓存 4MB； 默认 256 KB 部分请求会溢出
    private final static int RESPONSE_BUFFER_SIZE = 1024 * 1024 * 4;

    static private void setDefaultHeaders(HttpHeaders httpHeaders, RequestHeadersSession requestHeadersSession) {
        httpHeaders.set("Accept-Language", requestHeadersSession.getAcceptLanguage());
        httpHeaders.set("Origin", requestHeadersSession.getOrigin());
        httpHeaders.set("Referer", requestHeadersSession.getReferer());
        httpHeaders.set("Sec-Ch-Ua", requestHeadersSession.getSecChUa());
        httpHeaders.set("Sec-Ch-Ua-Mobile", requestHeadersSession.getSecChUaMobile());
        httpHeaders.set("Sec-Ch-Ua-Platform", requestHeadersSession.getSecChUaPlatform());
        httpHeaders.set("Sec-Fetch-Dest", requestHeadersSession.getSecFetchDest());
        httpHeaders.set("Sec-Fetch-Mode", requestHeadersSession.getSecFetchMode());
        httpHeaders.set("Sec-Fetch-Site", requestHeadersSession.getSecFetchSite());
        httpHeaders.set("User-Agent", requestHeadersSession.getUserAgent());
        httpHeaders.set("Cookie", requestHeadersSession.getCookie());
    }

    public static WebClient.RequestHeadersSpec<? extends WebClient.RequestHeadersSpec<?>> create(RequestHeadersSession requestHeadersSession, HttpMethod httpMethod, URI uri) {
        WebClient webClient = WebClient.create();
        return webClient
                .mutate()
                .codecs(
                        configurer -> configurer
                                .defaultCodecs()
                                .maxInMemorySize(RESPONSE_BUFFER_SIZE)
                )
                .build()
                .method(httpMethod)
                .uri(uri)
                .headers(httpHeaders -> setDefaultHeaders(httpHeaders, requestHeadersSession));
    }

    public static WebClient.RequestHeadersSpec<? extends WebClient.RequestHeadersSpec<?>> create(RequestHeadersSession requestHeadersSession, HttpMethod httpMethod, URI uri, Object bodyValue) {
        WebClient webClient = WebClient.create();
        return webClient
                .mutate()
                .codecs(
                        configurer -> configurer
                                .defaultCodecs()
                                .maxInMemorySize(RESPONSE_BUFFER_SIZE)
                )
                .build()
                .method(httpMethod)
                .uri(uri)
                .bodyValue(bodyValue)
                .headers(httpHeaders -> setDefaultHeaders(httpHeaders, requestHeadersSession));
    }

    public static WebClient.RequestHeadersSpec<? extends WebClient.RequestHeadersSpec<?>> create(RequestHeadersSession requestHeadersSession, HttpMethod httpMethod, String uri, Map<String, Object> uriVariables) {
        WebClient webClient = WebClient.create();
        return webClient
                .mutate()
                .codecs(
                        configurer -> configurer
                                .defaultCodecs()
                                .maxInMemorySize(RESPONSE_BUFFER_SIZE)
                )
                .build()
                .method(httpMethod)
                .uri(uri, uriVariables)
                .headers(httpHeaders -> setDefaultHeaders(httpHeaders, requestHeadersSession));
    }

    public static WebClient.RequestHeadersSpec<? extends WebClient.RequestHeadersSpec<?>> create(RequestHeadersSession requestHeadersSession, HttpMethod httpMethod, String uri, Object bodyValue) {
        WebClient webClient = WebClient.create();
        return webClient
                .mutate()
                .codecs(
                        configurer -> configurer
                                .defaultCodecs()
                                .maxInMemorySize(RESPONSE_BUFFER_SIZE)
                )
                .build()
                .method(httpMethod)
                .uri(uri)
                .bodyValue(bodyValue)
                .headers(httpHeaders -> setDefaultHeaders(httpHeaders, requestHeadersSession));
    }
}
