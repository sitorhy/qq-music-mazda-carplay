package name.sitorhy.server.session;

import name.sitorhy.server.utils.WebClientUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.net.URI;
import java.util.*;

@Component
public class RequestHeadersSession {

    private String cookie;

    private long uin = 0;
    private String hostUin;
    private String qqMusicKey = "";

    @Value("${headers.default.Accept-Language}")
    private String acceptLanguage;

    @Value("${headers.default.Origin}")
    private String origin;

    @Value("${headers.default.Referer}")
    private String referer;

    @Value("${headers.default.Sec-Ch-Ua}")
    private String secChUa;

    @Value("${headers.default.Sec-Ch-Ua-Mobile}")
    private String SecChUaMobile;

    @Value("${headers.default.Sec-Ch-Ua-Platform}")
    private String secChUaPlatform;

    @Value("${headers.default.Sec-Fetch-Dest}")
    private String secFetchDest;

    @Value("${headers.default.Sec-Fetch-Mode}")
    private String secFetchMode;

    @Value("${headers.default.Sec-Fetch-Site}")
    private String secFetchSite;

    @Value("${headers.default.User-Agent}")
    private String userAgent;

    private void setUin() {
        if (this.cookie != null) {
            String[] cookies = this.cookie.split(";");
            Arrays.stream(cookies).filter(i -> i.trim().startsWith("uin=")).findFirst().ifPresentOrElse((cookie) -> {
                this.uin = Long.parseLong(cookie.split("=")[1].trim());
            }, () -> {
                this.uin = 0;
            });
        } else {
            this.uin = 0;
        }
    }

    private void setQQMusicKey() {
        if (this.cookie != null) {
            String[] cookies = this.cookie.split(";");
            Arrays.stream(cookies).filter(i -> i.trim().startsWith("qqmusic_key=")).findFirst().ifPresentOrElse((cookie) -> {
                this.qqMusicKey = cookie.split("=")[1].trim();
            }, () -> {
                this.qqMusicKey = "";
            });
        } else {
            this.qqMusicKey = "";
        }
    }

    private void setHostUin() {
        if (this.cookie != null) {
            String[] cookies = this.cookie.split(";");
            Arrays.stream(cookies).filter(i -> i.trim().startsWith("euin=")).findFirst().ifPresentOrElse((cookie) -> {
                this.hostUin = cookie.split("=")[1].trim();
            }, () -> {
                this.hostUin = "";
            });
        } else {
            this.hostUin = "";
        }
    }

    public String getQQMusicKey() {
        return qqMusicKey;
    }

    public long getUin() {
        return this.uin;
    }

    public String getHostUin() {
        return hostUin;
    }

    public String getCookie() {
        return cookie;
    }

    @Value("${headers.default.Cookie}")
    public void setCookie(String cookie) {
        this.cookie = cookie;
        this.setUin();
        this.setQQMusicKey();
        this.setHostUin();
    }

    public String getAcceptLanguage() {
        return acceptLanguage;
    }

    public String getOrigin() {
        return origin;
    }

    public String getReferer() {
        return referer;
    }

    public String getSecChUa() {
        return secChUa;
    }

    public String getSecChUaMobile() {
        return SecChUaMobile;
    }

    public String getSecChUaPlatform() {
        return secChUaPlatform;
    }

    public String getSecFetchDest() {
        return secFetchDest;
    }

    public String getSecFetchMode() {
        return secFetchMode;
    }

    public String getSecFetchSite() {
        return secFetchSite;
    }

    public String getUserAgent() {
        return userAgent;
    }

    /**
     * 拼接地址核参数，因为WebClient使用了URI类，URI会对地址参数进行二次编码
     * @param baseUrl - 地址 baseUrl
     * @param variables - 地址参数 queryParams
     * @return 拼接后的地址
     */
    private URI createUrl(String baseUrl, LinkedHashMap<String, Object> variables) {
        List<String> queryParams = new ArrayList<>();
        variables.forEach((key, value) -> {
            queryParams.add(String.format("%s=%s", key, value));
        });

        if (baseUrl.lastIndexOf("?") >= 0) {
            return URI.create(String.format("%s?%s", baseUrl, String.join("&", queryParams)));
        } else {
            return URI.create(baseUrl + "?" + String.join("&", queryParams));
        }
    }

    public WebClient.RequestHeadersSpec<?> get(String uri, LinkedHashMap<String, Object> uriVariables) {
        return WebClientUtils.create(this, HttpMethod.GET, createUrl(uri, uriVariables), new HashMap<>());
    }

    public WebClient.RequestHeadersSpec<?> post(String uri, LinkedHashMap<String, Object> uriVariables, Object bodyValue) {
        return WebClientUtils.create(this, HttpMethod.POST, createUrl(uri, uriVariables), bodyValue);
    }
}
