package name.sitorhy.server.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.session.RequestHeadersSession;
import name.sitorhy.server.utils.QQEncrypt;

import java.io.IOException;
import java.util.LinkedHashMap;

public class CategoryService {
    private final RequestHeadersSession requestHeadersSession;

    public CategoryService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public name.sitorhy.server.model.category.recommend.Response getRecommendFeed(long pageNo, long pageSize) throws IOException {
        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {{
            put("comm", new LinkedHashMap<String, Object>() {{
                put("ct", 24);
                put("cv", 4747474);
                put("format", "json");
                put("platform", "yqq.json");
                put("notice", 0);
                put("inCharset", "utf-8");
                put("outCharset", "utf-8");
                put("uin", String.valueOf(requestHeadersSession.getUin()));
            }});

            put("req_1", new LinkedHashMap<String, Object>() {{
                put("method", "GetRecommendFeed");
                put("module", "music.playlist.PlaylistSquare");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("From", pageNo);
                    put("Size", pageSize);
                }});
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.category.recommend.Response.class);
    }

    public name.sitorhy.server.model.category.hot.category.Response getHotCategory() throws IOException {
        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {{
            put("comm", new LinkedHashMap<String, Object>() {{
                put("ct", 24);
                put("cv", 4747474);
                put("format", "json");
                put("platform", "yqq.json");
                put("notice", 0);
                put("inCharset", "utf-8");
                put("outCharset", "utf-8");
            }});

            put("req_1", new LinkedHashMap<String, Object>() {{
                put("method", "get_hot_category");
                put("module", "music.web_category_svr");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("location", 0);
                }});
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.category.hot.category.Response.class);
    }

    public name.sitorhy.server.model.category.tags.Response getAllTag() throws IOException {
        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {{
            put("comm", new LinkedHashMap<String, Object>() {{
                put("ct", 24);
                put("cv", 4747474);
                put("format", "json");
                put("platform", "yqq.json");
                put("notice", 0);
                put("inCharset", "utf-8");
                put("outCharset", "utf-8");
            }});

            put("req_1", new LinkedHashMap<String, Object>() {{
                put("method", "GetAllTag");
                put("module", "music.playlist.PlaylistSquare");
                put("param", new LinkedHashMap<String, Object>() {});
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.category.tags.Response.class);
    }

    public name.sitorhy.server.model.category.playlist.Response getPlayListCategory(long categoryId, long pageNo, long pageSize) throws IOException {
        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {{
            put("comm", new LinkedHashMap<String, Object>() {{
                put("ct", 24);
                put("cv", 4747474);
                put("format", "json");
                put("platform", "yqq.json");
                put("notice", 0);
                put("inCharset", "utf-8");
                put("outCharset", "utf-8");
            }});

            put("req_1", new LinkedHashMap<String, Object>() {{
                put("method", "get_category_content");
                put("module", "music.playlist.PlayListCategory");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("caller", String.valueOf(requestHeadersSession.getUin()));
                    put("category_id", categoryId);
                    put("size", pageSize);
                    put("page", pageNo);
                    put("use_page", 1);
                }});
            }});

            put("req_2", new LinkedHashMap<String, Object>() {{
                put("method", "get_category_basic");
                put("module", "playlist.PlayListCategoryServer");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("caller", String.valueOf(requestHeadersSession.getUin()));
                    put("category_id", categoryId);
                }});
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.category.playlist.Response.class);
    }
}
