package name.sitorhy.server.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.model.Album;
import name.sitorhy.server.model.Singer;
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

    public Mono<List<Album>> getMyFavAlbums(long pageNo, long pageSize) {
        return requestHeadersSession
                .get("https://c.y.qq.com/fav/fcgi-bin/fcg_get_profile_order_asset.fcg", new LinkedHashMap<>() {
                    {
                        put("ct", 20);
                        put("cid", 205360956);
                        put("userid", requestHeadersSession.getUin());
                        put("reqtype", 3);
                        put("sin", (pageNo - 1) * pageSize);
                        put("ein", pageNo * pageSize);
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

    public Mono<List<Album>> getMyFavPublication(long pageNo, long pageSize) {
        return requestHeadersSession
                .get("https://c.y.qq.com/fav/fcgi-bin/fcg_get_profile_order_asset.fcg", new LinkedHashMap<>() {
                    {
                        put("ct", 20);
                        put("cid", 205360956);
                        put("userid", requestHeadersSession.getUin());
                        put("reqtype", 2);
                        put("sin", (pageNo - 1) * pageSize);
                        put("ein", pageNo * pageSize);
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

                                this.setSingers(new ArrayList<>());
                                JsonNode arrSingerList = objNode.at("/singer");
                                for (JsonNode singerNode : arrSingerList) {
                                    this.getSingers().add(new Singer() {{
                                        setId(0);
                                        setMid(singerNode.at("/mid").asText());
                                        setName(singerNode.at("/name").asText());
                                    }});
                                }
                            }});
                        }
                        sink.next(list);
                    } catch (JsonProcessingException e) {
                        sink.error(new RuntimeException(e));
                    }
                });
    }

    public Mono<List<Album>> getSingerPublication(String singerMid, long pageNo, long pageSize) {
        return requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<>() {{
                    put("_", System.currentTimeMillis());
                }}, new LinkedHashMap<String, Object>() {{
                    put("comm", new LinkedHashMap<String, Object>() {{
                        put("ct", 24);
                        put("cv", 0);
                    }});

                    put("singerAlbum", new LinkedHashMap<String, Object>() {{
                        put("method", "get_singer_album");
                        put("param", new LinkedHashMap<>() {{
                            put("singermid", singerMid);
                            put("order", "time");
                            put("begin", (pageNo - 1) * pageSize);
                            put("num", pageSize);
                            put("exstatus", 1);
                        }});
                        put("module", "music.web_singer_info_svr");
                    }});
                }})
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        List<Album> albums = new ArrayList<>();
                        ObjectMapper mapper = new ObjectMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode arrList = root.at("/singerAlbum/data/list");
                        if (arrList.isArray()) {
                            for (JsonNode albumNode : arrList) {
                                Album album = new Album() {{
                                    this.setAlbumId(albumNode.at("/albumid").asLong());
                                    this.setAlbumMid(albumNode.at("/album_mid").asText());
                                    this.setAuthor(albumNode.at("/singer_name").asText());
                                    this.setTitle(albumNode.at("/album_name").asText());
                                    this.setSubtitle(albumNode.at("/desc").asText());
                                    this.setPicUrl(String.format("https://y.gtimg.cn/music/photo_new/T002R300x300M000%s.jpg", this.getAlbumMid()));
                                    this.setDirId(0);
                                    this.setDissId(0);
                                    List<Singer> singers = new ArrayList<>();
                                    JsonNode arrSingerList = albumNode.at("/singers");
                                    for (JsonNode singerNode : arrSingerList) {
                                        singers.add(new Singer() {{
                                            setId(singerNode.at("/singer_id").asLong());
                                            setMid(singerNode.at("/singer_mid").asText());
                                            setName(singerNode.at("/singer_name").asText());
                                        }});
                                    }
                                    this.setSingers(singers);
                                }};

                                albums.add(album);
                            }
                        }
                        sink.next(albums);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }
}
