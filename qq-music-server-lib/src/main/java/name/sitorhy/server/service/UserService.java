package name.sitorhy.server.service;

import name.sitorhy.server.session.RequestHeadersSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private RequestHeadersSession requestHeadersSession;

    @Autowired
    public void setRequestParamsSession(RequestHeadersSession requestHeadersSession) {
        this.requestHeadersSession = requestHeadersSession;
    }

    public void setCookie(String cookie) {
        requestHeadersSession.setCookie(cookie);
    }

    public String getCookie() {
        return requestHeadersSession.getCookie();
    }
}
