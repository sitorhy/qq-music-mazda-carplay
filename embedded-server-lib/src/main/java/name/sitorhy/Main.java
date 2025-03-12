package name.sitorhy;

import name.sitorhy.server.service.FollowService;
import name.sitorhy.server.service.SongService;
import name.sitorhy.server.session.RequestHeadersSession;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        RequestHeadersSession session = new RequestHeadersSession();
        try {
            var response = new FollowService(session).getFollowSingers(1, 30);
            System.out.println(response);
            var response2 = new SongService(session).getSingerTopSongs("001e2PK318EKPa", 1, 30);
            System.out.println(response2);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}