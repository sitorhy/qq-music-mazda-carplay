package name.sitorhy.server.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.model.Album;
import name.sitorhy.server.session.RequestHeadersSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@Service
public class AlbumService {
    private RequestHeadersSession requestHeadersSession;

    @Autowired
    public void setRequestHeadersSession(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public Mono<List<Album>> getMyAlbums() {
        return requestHeadersSession
                .get("http://c.y.qq.com/rsc/fcgi-bin/fcg_get_profile_homepage.fcg", new LinkedHashMap<>() {
                    {
                        put("cid", 205360838);
                        put("userid", requestHeadersSession.getUin());
                        put("reqfrom", 1);
                    }
                })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        List<Album> list = new ArrayList<>();
                        JsonMapper mapper = new JsonMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode arrMyMusic = root.at("/data/mymusic");
                        if (!arrMyMusic.isEmpty()) {
                            JsonNode myMusicNode = arrMyMusic.get(0);
                            list.add(new Album() {{
                                this.setSubtitle(myMusicNode.at("/subtitle").asText());
                                this.setPicUrl(myMusicNode.at("/picurl").asText());
                                this.setDissId(myMusicNode.at("/id").asLong());
                                this.setTitle(myMusicNode.at("/title").asText());
                                this.setDirId(201);
                            }});
                        }

                        JsonNode arrNode = root.at("/data/mydiss/list");
                        for (JsonNode objNode : arrNode) {
                            list.add(new Album() {{
                                this.setSubtitle(objNode.at("/subtitle").asText());
                                this.setPicUrl(objNode.at("/picurl").asText());
                                this.setDissId(objNode.at("/dissid").asLong());
                                this.setTitle(objNode.at("/title").asText());
                                this.setDirId(objNode.at("/dirid").asLong());
                            }});
                        }
                        sink.next(list);
                    } catch (JsonProcessingException e) {
                        sink.error(new RuntimeException(e));
                    }
                });
    }
}
