package name.sitorhy.server.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.session.RequestHeadersSession;
import name.sitorhy.server.utils.QQEncrypt;

import java.io.IOException;
import java.util.LinkedHashMap;

public class UserService {
    private RequestHeadersSession requestHeadersSession;

    public UserService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public void setCookie(String cookie) {
        requestHeadersSession.setCookie(cookie);
    }

    public String getCookie() {
        return requestHeadersSession.getCookie();
    }

    public name.sitorhy.server.model.user.profile.Response getUserProfile() throws IOException {
        String jsonText = requestHeadersSession.get("https://c6.y.qq.com/rsc/fcgi-bin/fcg_get_profile_homepage.fcg", new LinkedHashMap<>() {{
            put("_", System.currentTimeMillis());
            put("cv", 4747474);
            put("ct", 24);
            put("format", "json");
            put("inCharset", "utf-8");
            put("outCharset", "utf-8");
            put("notice", 0);
            put("platform", "yqq.json");
            put("needNewCode", 0);
            put("uin", requestHeadersSession.getUin());
            put("g_tk_new_20200303", 1660296258);
            put("g_tk", 1660296258);
            put("cid", 205360838);
            put("userid", requestHeadersSession.getUin());
            put("reqfrom", 1);
            put("reqtype", 0);
            put("hostUin", 0);
            put("loginUin", requestHeadersSession.getUin());
        }});


        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.user.profile.Response.class);
    }
}
