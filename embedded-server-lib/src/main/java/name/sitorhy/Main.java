package name.sitorhy;

import name.sitorhy.server.service.AlbumService;
import name.sitorhy.server.service.CategoryService;
import name.sitorhy.server.service.SongService;
import name.sitorhy.server.session.RequestHeadersSession;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        RequestHeadersSession session = new RequestHeadersSession();
        try {
            var response = new SongService(session).getTopList();
            System.out.println(response);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}