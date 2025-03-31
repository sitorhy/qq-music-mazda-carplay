package name.sitorhy;

import name.sitorhy.server.service.*;
import name.sitorhy.server.session.RequestHeadersSession;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        RequestHeadersSession session = new RequestHeadersSession();
        try {
            var response = new SongService(session).getSongDetail("004LV3xj05XDZc");
            System.out.println(response);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}