package name.sitorhy.server.service;

import java.io.IOException;
import java.util.LinkedHashMap;

import name.sitorhy.server.session.RequestHeadersSession;

public class AlbumService {
    private RequestHeadersSession requestHeadersSession;

    public AlbumService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public String getMyPlaylists() throws IOException {
        return requestHeadersSession
                .get("http://c.y.qq.com/rsc/fcgi-bin/fcg_get_profile_homepage.fcg", new LinkedHashMap<String, Object>() {
                    {
                        put("cid", 205360838);
                        put("userid", requestHeadersSession.getUin());
                        put("reqfrom", 1);
                    }
                });
    }

    public String getMyFavPlaylists(long pageNo, long pageSize) throws IOException {
        return requestHeadersSession
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
    }

    public String getMyFavAlbums(long pageNo, long pageSize) throws IOException {
        return requestHeadersSession
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
    }

    public String getSingerAlbums(String singerMid, long pageNo, long pageSize) throws IOException {
        return requestHeadersSession.post("https://u6.y.qq.com/cgi-bin/musicu.fcg", new LinkedHashMap<String, Object>() {{
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
    }
}
