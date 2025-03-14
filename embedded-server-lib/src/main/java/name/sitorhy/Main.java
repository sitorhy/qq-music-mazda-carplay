package name.sitorhy;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import name.sitorhy.server.model.my.fav.playlists.Response;
import name.sitorhy.server.service.AlbumService;
import name.sitorhy.server.session.RequestHeadersSession;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        RequestHeadersSession session = new RequestHeadersSession();
        AlbumService albumService = new AlbumService(session);
        try {
            String response = albumService.getMyFavPlaylists(1, 30);
            JsonMapper root = new JsonMapper();
            root.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            Response response1 = root.readValue(response, Response.class);
            System.out.println(response1);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}