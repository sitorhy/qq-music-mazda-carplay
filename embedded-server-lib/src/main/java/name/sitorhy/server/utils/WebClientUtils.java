package name.sitorhy.server.utils;

import java.util.Optional;

import fi.iki.elonen.NanoHTTPD;

public class WebClientUtils {
    // 扩大接收缓存 4MB； 默认 256 KB 部分请求会溢出
    private final static int RESPONSE_BUFFER_SIZE = 1024 * 1024 * 4;

    static public String getQueryStringFirstValue(NanoHTTPD.IHTTPSession session, String key) {
        final String[] values = {""};
        Optional.ofNullable(
                session.getParameters().get(key)
        ).ifPresent(list -> {
            values[0] = list.get(0);
        });
        return values[0];
    }

    static public String getQueryStringFirstValue(NanoHTTPD.IHTTPSession session, String key, String defaultValue) {
        final String[] values = {""};
        Optional.ofNullable(
                session.getParameters().get(key)
        ).ifPresent(list -> {
            values[0] = list.get(0);
        });
        if (TextUtils.isEmpty(values[0])) {
            return defaultValue;
        };
        return values[0];
    }
}
