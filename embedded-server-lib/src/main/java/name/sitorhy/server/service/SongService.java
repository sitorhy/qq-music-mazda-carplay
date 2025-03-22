package name.sitorhy.server.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.model.SongTypeEnum;
import name.sitorhy.server.session.RequestHeadersSession;
import name.sitorhy.server.utils.QQEncrypt;
import name.sitorhy.server.utils.TextUtils;

import java.io.IOException;
import java.util.*;

public class SongService {
    private final RequestHeadersSession requestHeadersSession;

    private final Map<String, Map<String, String>> typeMap = new HashMap<>() {{
        put("m4a", new HashMap<String, String>() {{
            put("s", "C400");
            put("e", ".m4a");
        }});

        put("128", new HashMap<String, String>() {{
            put("s", "M500");
            put("e", ".mp3");
        }});

        put("320", new HashMap<String, String>() {{
            put("s", "M800");
            put("e", ".mp3");
        }});

        put("ape", new HashMap<String, String>() {{
            put("s", "A000");
            put("e", ".ape");
        }});

        put("flac", new HashMap<String, String>() {{
            put("s", "F000");
            put("e", ".flac");
        }});
    }};

    public SongService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public name.sitorhy.server.model.playlist.songs.Response getPlaylistSongs(long dissId) throws IOException {
        String jsonpText = requestHeadersSession.get("http://c.y.qq.com/qzone/fcg-bin/fcg_ucc_getcdinfo_byids_cp.fcg", new LinkedHashMap<String, Object>() {
            {
                put("type", 1);
                put("utf8", 1);
                put("loginUin", 0);
                put("disstid", dissId);
            }
        });
        String jsonText = jsonpText.substring("jsonCallback(".length(), jsonpText.length() - 1);
        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.playlist.songs.Response.class);
    }

    public name.sitorhy.server.model.song.source.Response getSongSource(String songMid, String strMediaMid, SongTypeEnum type) throws IOException {
        String typeName;
        switch (type) {
            case MP3: {
                typeName = "320";
            }
            break;
            case APE: {
                typeName = "ape";
            }
            break;
            case FLAC: {
                typeName = "flac";
            }
            break;
            case M4A: {
                typeName = "m4a";
            }
            break;
            default: {
                typeName = "128";
            }
        }
        ;
        Map<String, String> typeObj = typeMap.get(typeName);
        String file = String.format("%s%s%s%s", typeObj.get("s"), songMid, TextUtils.isEmpty(strMediaMid) ? strMediaMid : songMid, typeObj.get("e"));
        String guid = String.valueOf((long) (Math.random() * 10000000));

        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {{
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

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession
                .post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
                    put("_", System.currentTimeMillis());
                    put("sign", sign);
                    put("-", "getplaysongvkey");
                    put("g_tk", 1419151954);
                    put("loginUin", requestHeadersSession.getUin());
                    put("hostUin", 0);
                    put("format", "json");
                    put("inCharset", "utf-8");
                    put("outCharset", "utf-8");
                    put("platform", "yqq.json");
                    put("needNewCode", 1);
                }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.song.source.Response.class);
    }

    public name.sitorhy.server.model.album.songs.Response getAlbumSongs(String albumMid, long albumId, long pageNo, long pageSize) throws IOException {
        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {
            {
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
            }
        };

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<>() {{
            put("g_tk", 5381);
            put("format", "json");
            put("inCharset", "utf-8");
            put("outCharset", "utf-8");
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.album.songs.Response.class);
    }

    public name.sitorhy.server.model.singer.top.songs.Response getSingerTopSongs(String singerMid, long pageNo, long pageSize) throws IOException {
        LinkedHashMap<String, Object> body = new LinkedHashMap<>() {{
            put("comm", new LinkedHashMap<String, Object>() {{
                put("ct", 24);
                put("cv", 0);
            }});

            put("singer", new LinkedHashMap<String, Object>() {{
                put("method", "get_singer_detail_info");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("sort", 5);
                    put("singermid", singerMid);
                    put("sin", (pageNo - 1) * pageSize);
                    put("num", pageSize);
                    put("exstatus", 1);
                }});
                put("module", "music.web_singer_info_svr");
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.singer.top.songs.Response.class);
    }

    public name.sitorhy.server.model.song.newest.Response getNewSongs() throws IOException {
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
                put("method", "get_new_song_info");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("type", 5);
                }});
                put("module", "newsong.NewSongServer");
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.song.newest.Response.class);
    }

    public name.sitorhy.server.model.song.top.Response getTopList() throws IOException {
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
                put("method", "GetAll");
                put("param", new LinkedHashMap<String, Object>() {{
                }});
                put("module", "musicToplist.ToplistInfoServer");
            }});
        }};

        String sign = QQEncrypt.getSign(new ObjectMapper().writeValueAsString(body));

        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musics.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
            put("sign", sign);
        }}, body);

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.song.top.Response.class);
    }

    public String getSongLyric(String songMid) throws IOException {
        String jsonpText = requestHeadersSession.get("http://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg", new LinkedHashMap<String, Object>() {
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
        });

        String jsonText = jsonpText.substring("MusicJsonCallback(".length(), jsonpText.length() - 1);
        name.sitorhy.server.model.song.lyric.Response response = new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.song.lyric.Response.class);
        byte[] decodedBytes = Base64.getDecoder().decode(response.lyric);
        return new String(decodedBytes);
    }
}
