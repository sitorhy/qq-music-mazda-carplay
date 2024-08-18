package name.sitorhy.server.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.model.*;
import name.sitorhy.server.session.RequestHeadersSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import reactor.core.publisher.Mono;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.StreamSupport;

@Service
public class SongService {
    private RequestHeadersSession requestHeadersSession;

    private final Map<String, Map<String, String>> typeMap = new HashMap<>() {{
        put("m4a", new HashMap<>() {{
            put("s", "C400");
            put("e", ".m4a");
        }});

        put("128", new HashMap<>() {{
            put("s", "M500");
            put("e", ".mp3");
        }});

        put("320", new HashMap<>() {{
            put("s", "M800");
            put("e", ".mp3");
        }});

        put("ape", new HashMap<>() {{
            put("s", "A000");
            put("e", ".ape");
        }});

        put("flac", new HashMap<>() {{
            put("s", "F000");
            put("e", ".flac");
        }});
    }};

    @Autowired
    public void setRequestHeadersSession(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public Mono<List<Song>> getAlbumSongs(long dissId) {
        return requestHeadersSession.get("http://c.y.qq.com/qzone/fcg-bin/fcg_ucc_getcdinfo_byids_cp.fcg", new LinkedHashMap<>() {
                    {
                        put("type", 1);
                        put("utf8", 1);
                        put("loginUin", 0);
                        put("disstid", dissId);
                    }
                })
                .header("Referer", "https://y.qq.com/n/yqq/playlist")
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonpText, sink) -> {
                    try {
                        List<Song> songList = new ArrayList<>();
                        JsonMapper mapper = new JsonMapper();
                        String jsonText = jsonpText.substring("jsonCallback(".length(), jsonpText.lastIndexOf(")"));
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode arrCdList = root.at("/cdlist");
                        for (JsonNode cdNode : arrCdList) {
                            JsonNode arrSongList = cdNode.at("/songlist");
                            for (JsonNode songNode : arrSongList) {
                                Song song = new Song();
                                song.setDissId(cdNode.at("/disstid").asText());
                                song.setDissName(cdNode.at("/dissname").asText());
                                song.setSongId(songNode.at("/songid").asLong());
                                song.setSongMid(songNode.at("/songmid").asText());
                                song.setSongName(songNode.at("/songname").asText());
                                song.setSongOrig(songNode.at("/songorig").asText());
                                song.setAlbumDesc(songNode.at("/albumdesc").asText());
                                song.setAlbumId(songNode.at("/albumid").asLong());
                                song.setAlbumName(songNode.at("/albumname").asText());
                                song.setAlbumMid(songNode.at("/albummid").asText());
                                song.setStrMediaMid(songNode.at("/strMediaMid").asText());
                                song.setInterval(songNode.at("/interval").asLong());
                                song.setAlbumCoverUrl(String.format("https://y.qq.com/music/photo_new/T002R300x300M000%s.jpg", song.getAlbumMid()));
                                song.setSingers(new ArrayList<>());
                                JsonNode arrSingerList = songNode.at("/singer");
                                for (JsonNode singerNode : arrSingerList) {
                                    song.getSingers().add(new Singer() {{
                                        setId(singerNode.at("/id").asLong());
                                        setMid(singerNode.at("/mid").asText());
                                        setName(singerNode.at("/name").asText());
                                    }});
                                }

                                songList.add(song);
                            }
                        }
                        sink.next(songList);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    public Mono<SongSource> getSongSource(String songMid, String strMediaMid, SongTypeEnum type) throws JsonProcessingException {
        String typeName = switch (type) {
            case MP3 -> "320";
            case APE -> "ape";
            case FLAC -> "flac";
            case M4A -> "m4a";
            default -> "128";
        };
        Map<String, String> typeObj = typeMap.get(typeName);
        String file = String.format("%s%s%s%s", typeObj.get("s"), songMid, StringUtils.hasLength(strMediaMid) ? strMediaMid : songMid, typeObj.get("e"));
        String guid = String.valueOf((long) (Math.random() * 10000000));

        LinkedHashMap<String, Object> variables = new LinkedHashMap<>() {{
            put("-", "getplaysongvkey");
            put("g_tk", 5381);
            put("loginUin", requestHeadersSession.getUin());
            put("hostUin", 0);
            put("format", "json");
            put("inCharset", "utf-8");
            put("outCharset", "utf-8");
            put("platform", "yqq.json");
            put("needNewCode", 0);

            Map<String, Object> dataMap = new LinkedHashMap<>() {{
                put("req_0", new LinkedHashMap<String, Object>() {{
                    put("module", "vkey.GetVkeyServer");
                    put("method", "CgiGetVkey");
                    put("param", new LinkedHashMap<String, Object>() {{
                        put("filename", new String[]{file});
                        put("guid", guid);
                        put("songmid", new String[]{songMid});
                        put("songtype", new int[]{0});
                        put("uin", String.valueOf(requestHeadersSession.getUin()));
                        put("loginflag", 1);
                        put("platform", "20");
                    }});
                }});

                put("comm", new LinkedHashMap<String, Object>() {{
                    put("uin", String.valueOf(requestHeadersSession.getUin()));
                    put("format", "json");
                    put("platform", "yqq.json");
                    put("ct", 19);
                    put("cv", 0);
                    put("authst", requestHeadersSession.getQQMusicKey());
                }});
            }};
            String dataJsonText = new JsonMapper().writeValueAsString(dataMap);
            String dataJsonEncodeText = URLEncoder.encode(dataJsonText, StandardCharsets.UTF_8);
            put("data", dataJsonEncodeText);
        }};

        return requestHeadersSession
                .get("https://u.y.qq.com/cgi-bin/musicu.fcg", variables)
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        SongSource songSource = new SongSource();
                        JsonMapper mapper = new JsonMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode sipArrNode = root.at("/req_0/data/sip");
                        String host = StreamSupport.stream(sipArrNode.spliterator(), false)
                                .map(JsonNode::asText)
                                .filter(text -> text.contains("ws.stream"))
                                .findFirst()
                                .orElse("");

                        JsonNode midUrlInfoArrNode = root.at("/req_0/data/midurlinfo");
                        String purlUrl = StreamSupport.stream(midUrlInfoArrNode.spliterator(), false)
                                .filter(i -> i.at("/songmid").asText().equals(songMid))
                                .map(i -> i.at("/purl").asText())
                                .findFirst()
                                .orElse("");

                        songSource.setUrl(StringUtils.hasLength(purlUrl) ? String.format("%s%s", host, purlUrl) : purlUrl);
                        songSource.setType(type.name().toLowerCase());

                        long expiration = root.at("/req_0/data/expiration").asLong();
                        songSource.setExpire(expiration);

                        sink.next(songSource);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    public Mono<List<Song>> getPublicationSongs(String albumMid, long albumId, long pageNo, long pageSize) throws JsonProcessingException {
        return requestHeadersSession.get("https://u.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<>() {
                    {
                        put("g_tk", 5381);
                        put("format", "json");
                        put("inCharset", "utf-8");
                        put("outCharset", "utf-8");

                        String dataJsonText = new JsonMapper().writeValueAsString(new LinkedHashMap<>() {{
                            put("comm", new LinkedHashMap<String, Object>() {{
                                put("ct", 24);
                                put("cv", 10000);
                            }});

                            put("albumSonglist", new LinkedHashMap<String, Object>() {{
                                put("method", "GetAlbumSongList");
                                put("cv", 10000);
                                put("param", new LinkedHashMap<String, Object>() {{
                                    put("albumMid", albumMid);
                                    put("albumID", albumId);
                                    put("begin", (pageNo - 1) * pageSize);
                                    put("num", pageSize);
                                    put("order", 2);
                                }});
                                put("module", "music.musichallAlbum.AlbumSongList");
                            }});
                        }});
                        String dataJsonEncodeText = URLEncoder.encode(dataJsonText, StandardCharsets.UTF_8);
                        put("data", dataJsonEncodeText);
                    }
                })
                .header("Referer", "https://y.qq.com/n/yqq/playlist")
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonText, sink) -> {
                    try {
                        List<Song> songList = new ArrayList<>();
                        JsonMapper mapper = new JsonMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode arrSongList = root.at("/albumSonglist/data/songList");
                        for (JsonNode songNode : arrSongList) {
                            JsonNode songInfoNode = songNode.at("/songInfo");

                            Song song = new Song();
                            song.setSongId(songInfoNode.at("/id").asLong());
                            song.setSongMid(songInfoNode.at("/mid").asText());
                            song.setSongName(songInfoNode.at("/name").asText());
                            song.setSongOrig(songInfoNode.at("/title").asText());
                            song.setAlbumDesc(songInfoNode.at("/album/title").asText());
                            song.setAlbumId(songInfoNode.at("/album/id").asLong());
                            song.setAlbumName(songInfoNode.at("/album/name").asText());
                            song.setAlbumMid(songInfoNode.at("/album/mid").asText());
                            song.setStrMediaMid(songInfoNode.at("/file/media_mid").asText());
                            song.setInterval(songInfoNode.at("/interval").asLong());
                            song.setAlbumCoverUrl(String.format("https://y.qq.com/music/photo_new/T002R300x300M000%s.jpg", song.getAlbumMid()));
                            song.setSingers(new ArrayList<>());
                            JsonNode arrSingerList = songInfoNode.at("/singer");
                            for (JsonNode singerNode : arrSingerList) {
                                song.getSingers().add(new Singer() {{
                                    setId(singerNode.at("/id").asLong());
                                    setMid(singerNode.at("/mid").asText());
                                    setName(singerNode.at("/name").asText());
                                }});
                            }

                            songList.add(song);
                        }
                        sink.next(songList);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    public Mono<List<Song>> getSingerTopSongs(String singerMid, long pageNo, long pageSize) throws JsonProcessingException {
        return requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<>() {{
                    put("_", System.currentTimeMillis());
                }}, new LinkedHashMap<String, Object>() {{
                    put("comm", new LinkedHashMap<String, Object>() {{
                        put("ct", 24);
                        put("cv", 0);
                    }});

                    put("singer", new LinkedHashMap<String, Object>() {{
                        put("method", "get_singer_detail_info");
                        put("param", new LinkedHashMap<>() {{
                            put("sort", 5);
                            put("singermid", singerMid);
                            put("sin", (pageNo - 1) * pageSize);
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
                        List<Song> songList = new ArrayList<>();
                        JsonMapper mapper = new JsonMapper();
                        JsonNode root = mapper.readTree(jsonText);
                        JsonNode songListArr = root.at("/singer/data/songlist");
                        if (songListArr.isArray()) {
                            for (JsonNode songNode : songListArr) {
                                Song song = new Song();
                                song.setSongId(songNode.at("/id").asLong());
                                song.setSongMid(songNode.at("/mid").asText());
                                song.setSongName(songNode.at("/name").asText());
                                song.setSongOrig(songNode.at("/title").asText());
                                song.setAlbumDesc(songNode.at("/album/title").asText());
                                song.setAlbumId(songNode.at("/album/id").asLong());
                                song.setAlbumName(songNode.at("/album/name").asText());
                                song.setAlbumMid(songNode.at("/album/mid").asText());
                                song.setStrMediaMid(songNode.at("/file/media_mid").asText());
                                song.setInterval(songNode.at("/interval").asLong());
                                song.setAlbumCoverUrl(String.format("https://y.qq.com/music/photo_new/T002R300x300M000%s.jpg", song.getAlbumMid()));
                                song.setSingers(new ArrayList<>());
                                JsonNode arrSingerList = songNode.at("/singer");
                                for (JsonNode singerNode : arrSingerList) {
                                    song.getSingers().add(new Singer() {{
                                        setId(singerNode.at("/id").asLong());
                                        setMid(singerNode.at("/mid").asText());
                                        setName(singerNode.at("/name").asText());
                                    }});
                                }

                                songList.add(song);
                            }
                        }
                        sink.next(songList);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }

    public Mono<String> getSongLyric(String songMid) {
        return requestHeadersSession.get("http://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg", new LinkedHashMap<>() {
                    {
                        put("songmid", songMid);
                        put("pcachetime", System.currentTimeMillis());
                        put("g_tk", 5381);
                        put("loginUin", 0);
                        put("hostUin", 0);
                        put("inCharset", "utf8");
                        put("outCharset", "utf-8");
                        put("notice", 0);
                        put("platform", "yqq");
                        put("needNewCode", 0);
                    }
                })
                .header("Referer", "https://y.qq.com")
                .retrieve()
                .bodyToMono(String.class)
                .handle((jsonpText, sink) -> {
                    try {
                        JsonMapper mapper = new JsonMapper();
                        String dataJsonText = jsonpText.substring("MusicJsonCallback(".length(), jsonpText.length() - 1);
                        JsonNode dataNode = mapper.readTree(dataJsonText);
                        String lyricTextEncode = dataNode.at("/lyric").asText();
                        byte[] decodedBytes = Base64.getDecoder().decode(lyricTextEncode);
                        String lyricText = new String(decodedBytes);
                        sink.next(lyricText);
                    } catch (Exception e) {
                        sink.error(e);
                    }
                });
    }
}
