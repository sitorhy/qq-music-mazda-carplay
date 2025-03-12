package name.sitorhy.server.model.album.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

// import com.fasterxml.jackson.databind.ObjectMapper; // version 2.11.1
// import com.fasterxml.jackson.annotation.JsonProperty; // version 2.11.1
/* ObjectMapper om = new ObjectMapper();
Root root = om.readValue(myJsonString, Root.class); */
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
    public int switch2;
    public int icon2;
}
