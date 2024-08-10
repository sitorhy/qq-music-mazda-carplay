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
                        String nickName = root.at("/data/creator/nick").asText();
                        if (!arrMyMusic.isEmpty()) {
                            JsonNode myMusicNode = arrMyMusic.get(0);
                            list.add(new Album() {{
                                this.setSubtitle(myMusicNode.at("/subtitle").asText());
                                this.setPicUrl(myMusicNode.at("/picurl").asText());
                                this.setDissId(myMusicNode.at("/id").asLong());
                                this.setTitle(myMusicNode.at("/title").asText());
                                this.setDirId(201);
                                this.setAuthor(nickName);
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
                                this.setAuthor(nickName);
                            }});
                        }
                        sink.next(list);
                    } catch (JsonProcessingException e) {
                        sink.error(new RuntimeException(e));
                    }
                });
    }

    public Mono<List<Album>> getMyFavAlbums() {
        return requestHeadersSession
                .get("https://c.y.qq.com/fav/fcgi-bin/fcg_get_profile_order_asset.fcg", new LinkedHashMap<>() {
                    {
                        put("ct", 20);
                        put("cid", 205360956);
                        put("userid", requestHeadersSession.getUin());
                        put("reqtype", 3);
                        put("sin", 0);
                        put("ein", 10);
                    }
                })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        List<Album> list = new ArrayList<>();
                        JsonMapper mapper = new JsonMapper();
                        JsonNode root = mapper.readTree(jsonText);

                        JsonNode arrNode = root.at("/data/cdlist");
                        for (JsonNode objNode : arrNode) {
                            list.add(new Album() {{
                                this.setSubtitle(objNode.at("/nickname").asText());
                                this.setPicUrl(objNode.at("/logo").asText());
                                this.setDissId(objNode.at("/dissid").asLong());
                                this.setTitle(objNode.at("/dissname").asText());
                                this.setDirId(objNode.at("/dirid").asLong());
                                this.setAuthor(objNode.at("/nickname").asText());
                            }});
                        }
                        sink.next(list);
                    } catch (JsonProcessingException e) {
                        sink.error(new RuntimeException(e));
                    }
                });
    }

    public Mono<List<Album>> getMyFavPublication() {
        return requestHeadersSession
                .get("https://c.y.qq.com/fav/fcgi-bin/fcg_get_profile_order_asset.fcg", new LinkedHashMap<>() {
                    {
                        put("ct", 20);
                        put("cid", 205360956);
                        put("userid", requestHeadersSession.getUin());
                        put("reqtype", 2);
                        put("sin", 0);
                        put("ein", 10);
                    }
                })
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        List<Album> list = new ArrayList<>();
                        JsonMapper mapper = new JsonMapper();
                        JsonNode root = mapper.readTree(jsonText);

                        JsonNode arrNode = root.at("/data/albumlist");
                        for (JsonNode objNode : arrNode) {
                            list.add(new Album() {{
                                this.setSubtitle(objNode.at("/singername").asText());
                                this.setPicUrl(objNode.at("/pic").asText());
                                this.setAlbumMid(objNode.at("/albummid").asText());
                                this.setAlbumId(objNode.at("/albumid").asLong());
                                this.setTitle(objNode.at("/albumname").asText());
                                this.setDirId(0);
                                this.setAuthor(objNode.at("/singername").asText());
                            }});
                        }
                        sink.next(list);
                    } catch (JsonProcessingException e) {
                        sink.error(new RuntimeException(e));
                    }
                });
    }
}
