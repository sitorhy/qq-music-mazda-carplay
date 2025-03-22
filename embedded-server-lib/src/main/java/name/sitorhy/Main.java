package name.sitorhy;

import name.sitorhy.server.service.*;
import name.sitorhy.server.session.RequestHeadersSession;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        RequestHeadersSession session = new RequestHeadersSession();
        try {
            var response = new UserService(session).getUserProfile();
            System.out.println(response);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}