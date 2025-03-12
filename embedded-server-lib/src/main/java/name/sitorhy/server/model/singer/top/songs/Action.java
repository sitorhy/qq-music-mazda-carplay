package name.sitorhy.server.model.singer.top.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Action{
    @JsonProperty("switch")
    public int myswitch;
    public int msgid;
    public int alert;
    public int icons;
    public int msgshare;
    public int msgfav;
    public int msgdown;
    public int msgpay;
}
