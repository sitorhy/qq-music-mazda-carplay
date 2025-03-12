package name.sitorhy.server.service;

import name.sitorhy.server.session.RequestHeadersSession;

public class UserService {
    private RequestHeadersSession requestHeadersSession;

    public UserService(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public void setCookie(String cookie) {
        requestHeadersSession.setCookie(cookie);
    }

    public String getCookie() {
        return requestHeadersSession.getCookie();
    }
}
