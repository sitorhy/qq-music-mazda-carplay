package name.sitorhy.server.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import name.sitorhy.server.model.Singer;
import name.sitorhy.server.session.RequestHeadersSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@Service
public class FollowService {
    private RequestHeadersSession requestHeadersSession;

    @Autowired
    public void setRequestHeadersSession(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public Mono<List<Singer>> getFollowSingers(long pageNo, long pageSize) {
        return requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<>() {{
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
                        put("param", new LinkedHashMap<>() {{
                            put("From", (pageNo - 1) * pageSize);
                            put("Size", pageSize);
                            put("HostUin", requestHeadersSession.getHostUin());
                        }});
                    }});
                }})
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        List<Singer> singers = new ArrayList<>();
                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode dataNode = root.at("/req_1/data/List");
                        if (dataNode.isArray()) {
                            for (JsonNode singerNode : dataNode) {
                                Singer singer = new Singer();
                                singer.setMid(singerNode.at("/MID").asText());
                                singer.setName(singerNode.at("/Name").asText());
                                singer.setDescription(singerNode.at("/Desc").asText());
                                singer.setAvatarUrl(singerNode.at("/AvatarUrl").asText());
                                singer.setId(singerNode.at("/OtherInfo/SingerID").asLong());
                                singers.add(singer);
                            }
                        }
                        sink.next(singers);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }
}
