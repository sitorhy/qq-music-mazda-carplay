package name.sitorhy.server.service;

import java.io.IOException;
import java.util.LinkedHashMap;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.session.RequestHeadersSession;

public class AlbumService {
    private final RequestHeadersSession requestHeadersSession;

    public AlbumService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public name.sitorhy.server.model.my.playlists.Response getMyPlaylists() throws IOException {
        String jsonText = requestHeadersSession
                .get("http://c.y.qq.com/rsc/fcgi-bin/fcg_get_profile_homepage.fcg", new LinkedHashMap<String, Object>() {
                    {
                        put("cid", 205360838);
                        put("userid", requestHeadersSession.getUin());
                        put("reqfrom", 1);
                    }
                });
        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.my.playlists.Response.class);
    }

    public name.sitorhy.server.model.my.fav.playlists.Response getMyFavPlaylists(long pageNo, long pageSize) throws IOException {
        String jsonText = requestHeadersSession
                .get("https://c.y.qq.com/fav/fcgi-bin/fcg_get_profile_order_asset.fcg", new LinkedHashMap<String, Object>() {
                    {
                        put("ct", 20);
                        put("cid", 205360956);
                        put("userid", requestHeadersSession.getUin());
                        put("reqtype", 3);
                        put("sin", (pageNo - 1) * pageSize);
                        put("ein", pageNo * pageSize);
                    }
                });

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.my.fav.playlists.Response.class);
    }

    public name.sitorhy.server.model.my.fav.albums.Response getMyFavAlbums(long pageNo, long pageSize) throws IOException {
        String jsonText = requestHeadersSession
                .get("https://c.y.qq.com/fav/fcgi-bin/fcg_get_profile_order_asset.fcg", new LinkedHashMap<String, Object>() {
                    {
                        put("ct", 20);
                        put("cid", 205360956);
                        put("userid", requestHeadersSession.getUin());
                        put("reqtype", 2);
                        put("sin", (pageNo - 1) * pageSize);
                        put("ein", pageNo * pageSize);
                    }
                });
        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.my.fav.albums.Response.class);
    }

    public name.sitorhy.server.model.singer.albums.Response getSingerAlbums(String singerMid, long pageNo, long pageSize) throws IOException {
        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
        }}, new LinkedHashMap<String, Object>() {{
            put("comm", new LinkedHashMap<String, Object>() {{
                put("ct", 24);
                put("cv", 0);
            }});

            put("singerAlbum", new LinkedHashMap<String, Object>() {{
                put("method", "get_singer_album");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("singermid", singerMid);
                    put("order", "time");
                    put("begin", (pageNo - 1) * pageSize);
                    put("num", pageSize);
                    put("exstatus", 1);
                }});
                put("module", "music.web_singer_info_svr");
            }});
        }});

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.singer.albums.Response.class);
    }

    public name.sitorhy.server.model.album.newest.Response getNewAlbums() throws IOException {
        String jsonText = requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<String, Object>() {{
            put("_", System.currentTimeMillis());
        }}, new LinkedHashMap<String, Object>() {{
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
                put("method", "get_new_album_info");
                put("param", new LinkedHashMap<String, Object>() {{
                    put("area", 1);
                    put("sin", 0);
                    put("num", 20);
                }});
                put("module", "newalbum.NewAlbumServer");
            }});
        }});

        return new JsonMapper()
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                .readValue(jsonText, name.sitorhy.server.model.album.newest.Response.class);
    }
}
