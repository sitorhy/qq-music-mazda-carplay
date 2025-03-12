package name.sitorhy.server.session;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.net.URI;
import java.util.*;

import lombok.NonNull;
import name.sitorhy.server.utils.TextUtils;
import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


public class RequestHeadersSession {
    private OkHttpClient okHttpClient;

    private String cookie;

    private long uin = 0;
    private String hostUin;
    private String qqMusicKey = "";

    private String acceptLanguage = "zh-CN,zh;q=0.9";

    private String origin = "https://y.qq.com";

    private String referer = "https://y.qq.com/";

    private String secChUa = "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Google Chrome\";v=\"126\"";

    private String SecChUaMobile = "?0";

    private String secChUaPlatform = "Windows";

    private String secFetchDest = "empty";

    private String secFetchMode = "cors";

    private String secFetchSite = "same-site";

    private String userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36";

    public RequestHeadersSession() {
        okHttpClient = new OkHttpClient().newBuilder().addInterceptor(new Interceptor() {
            @NonNull
            @Override
            public Response intercept(@NonNull Chain chain) throws IOException {
                Request request = chain.request().newBuilder().
                        addHeader("Accept-Language", getAcceptLanguage()).
                        addHeader("Origin", getOrigin()).
                        addHeader("Referer", getReferer()).
                        addHeader("Sec-Ch-Ua", getSecChUa()).
                        addHeader("Sec-Ch-Ua-Mobile", getSecChUaMobile()).
                        addHeader("Sec-Ch-Ua-Platform", getSecChUaPlatform()).
                        addHeader("Sec-Fetch-Dest", getSecFetchDest()).
                        addHeader("Sec-Fetch-Mode", getSecFetchMode()).
                        addHeader("Sec-Fetch-Site", getSecFetchSite()).
                        addHeader("User-Agent", getUserAgent()).
                        addHeader("Cookie", Optional.ofNullable(getCookie()).orElse(""))
                        .build();
                return chain.proceed(request);
            }
        }).build();

		// 设置测试Cookie
        setCookie("pgv_pvid=5662667309; fqm_pvqid=4e62866a-bdde-408b-9bd3-b12e6db909bc; ts_uid=9691256345; RK=BXFh7QvjM7; ptcz=abdccce56f3f2b01de092bff77bdd6582bb75f8255579a8df6f56f00703d9eed; qq_domain_video_guid_verify=bde05e4c0276de1a; _qimei_uuid42=18b07113a29100a398a5ad51e3d07a6f821a03222c; _qimei_fingerprint=2ec95ea88f202a6480db8c53536d9388; _qimei_q36=; _qimei_h38=30e7522b98a5ad51e3d07a6f0200000bc18b07; o_cookie=876434932; ts_last=y.qq.com/; ts_refer=www.google.com/; wxrefresh_token=; qm_keyst=Q_H_L_63k3NABUM2eec_5vhzkJUN75fBJVabGM2-GpaNBC9Z2vpZvVW7dIqrPlvZZuiKMignY_7I9j-eU2X-H0jb1iG5g; psrf_qqaccess_token=46396F0752C3C36A6C65456F1E271184; wxunionid=; tmeLoginType=2; psrf_qqopenid=40EF8F92D2B461AC6959648D2D341B70; uin=876434932; psrf_qqunionid=97CBFB85EE554444130E069D7383A216; music_ignore_pskey=202306271436Hn@vBj; euin=NeSs7eoPNKoA; psrf_qqrefresh_token=2CC47A2599E67048DDE9EC2928D90243; qqmusic_key=Q_H_L_63k3NABUM2eec_5vhzkJUN75fBJVabGM2-GpaNBC9Z2vpZvVW7dIqrPlvZZuiKMignY_7I9j-eU2X-H0jb1iG5g; wxopenid=; psrf_access_token_expiresAt=1746985070; psrf_musickey_createtime=1741801070; fqm_sessionid=1c4299d3-b07f-4ff0-8a51-036f3450b034; pgv_info=ssid=s1209484100");
        setUin();
        setHostUin();
        setQQMusicKey();
    }

    private void setUin() {
        if (this.cookie != null) {
            String[] cookies = this.cookie.split(";");
            String strUin = Arrays.stream(cookies).filter(i -> i.trim().startsWith("uin=")).findFirst().orElse("").trim();
            if (!TextUtils.isEmpty(strUin)) {
                this.uin = Long.parseLong(strUin.split("=")[1].trim());
            } else {
                this.uin = 0;
            }
        } else {
            this.uin = 0;
        }
    }

    private void setQQMusicKey() {
        if (this.cookie != null) {
            String[] cookies = this.cookie.split(";");
            String strKey = Arrays.stream(cookies).filter(i -> i.trim().startsWith("qqmusic_key=")).findFirst().orElse("").trim();
            if (TextUtils.isEmpty(strKey)) {
                this.qqMusicKey = "";
            } else {
                this.qqMusicKey = strKey.split("=")[1].trim();
            }
        } else {
            this.qqMusicKey = "";
        }
    }

    private void setHostUin() {
        if (this.cookie != null) {
            String[] cookies = this.cookie.split(";");
            String strUin = Arrays.stream(cookies).filter(i -> i.trim().startsWith("euin=")).findFirst().orElse("").trim();
            if (TextUtils.isEmpty(strUin)) {
                this.hostUin = "";
            } else {
                this.hostUin = strUin.split("=")[1].trim();
            }
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
        if (variables != null) {
            variables.forEach((key, value) -> {
                queryParams.add(String.format("%s=%s", key, value));
            });
        }

        if (baseUrl.lastIndexOf("?") >= 0) {
            return URI.create(String.format("%s?%s", baseUrl, String.join("&", queryParams)));
        } else {
            return URI.create(baseUrl + "?" + String.join("&", queryParams));
        }
    }

    public String get(String uri, LinkedHashMap<String, Object> uriVariables) throws IOException {
        Request.Builder builder = new Request.Builder();
        HttpUrl.Builder httpBuilder = Objects.requireNonNull(HttpUrl.parse(uri)).newBuilder();
        if (uriVariables != null) {
            uriVariables.forEach((key, value) -> {
                httpBuilder.addQueryParameter(key, value.toString());
            });
        }
        URI httpUri = createUrl(uri, uriVariables);
        Request request = builder.url(httpUri.toURL()).build();

        return Objects.requireNonNull(okHttpClient.newCall(request).execute().body()).string();
    }


    public String post(String uri, LinkedHashMap<String, Object> uriVariables, Object bodyValue) throws IOException {
        Request.Builder builder = new Request.Builder();
        HttpUrl.Builder httpBuilder = Objects.requireNonNull(HttpUrl.parse(uri)).newBuilder();
        if (uriVariables != null) {
            uriVariables.forEach((key, value) -> {
                httpBuilder.addQueryParameter(key, value.toString());
            });
        }
        if (bodyValue != null) {
            String bodyJsonText = new ObjectMapper().writeValueAsString(bodyValue);
            RequestBody body = RequestBody.create(bodyJsonText, MediaType.get("application/json"));
            builder.post(body);
        } else {
            builder.post(RequestBody.create(new byte[] {}));
        }
        URI httpUri = createUrl(uri, uriVariables);
        Request request = builder.url(httpUri.toURL()).build();

        return Objects.requireNonNull(okHttpClient.newCall(request).execute().body()).string();
    }
}
