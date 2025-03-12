package name.sitorhy.server.service;

import name.sitorhy.server.session.RequestHeadersSession;

import java.io.IOException;
import java.util.LinkedHashMap;

public class FollowService {
    private RequestHeadersSession requestHeadersSession;

    public FollowService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public String getFollowSingers(long pageNo, long pageSize) throws IOException {
        return requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<String, Object>() {{
                    put("_", System.currentTimeMillis());
                }}, new LinkedHashMap<String, Object>() {{
                    put("comm", new LinkedHashMap<String, Object>() {{
                        put("cv", 4747474);
                        put("ct", 24);
                        put("format", "json");
                        put("inCharset", "utf-8");
                        put("outCharset", "utf-8");
                        put("notice", 0);
                        put("platform", "yqq.json");
                        put("needNewCode", 1);
                        put("uin", requestHeadersSession.getUin());
                        put("g_tk_new_20200303", 964630399);
                        put("g_tk", 964630399);
                    }});

                    put("req_1", new LinkedHashMap<String, Object>() {{
                        put("module", "music.concern.RelationList");
                        put("method", "GetFollowSingerList");
                        put("param", new LinkedHashMap<String, Object>() {{
                            put("From", (pageNo - 1) * pageSize);
                            put("Size", pageSize);
                            put("HostUin", requestHeadersSession.getHostUin());
                        }});
                    }});
                }});
    }
}
