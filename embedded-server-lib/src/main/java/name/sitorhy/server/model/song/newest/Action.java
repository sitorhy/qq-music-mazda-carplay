package name.sitorhy.server.model.song.newest;
import com.fasterxml.jackson.annotation.JsonProperty; 
public class Action{
    @JsonProperty("switch") 
    public long myswitch;
    public long msgid;
    public long alert;
    public long icons;
    public long msgshare;
    public long msgfav;
    public long msgdown;
    public long msgpay;
    public long switch2;
    public long icon2;
}
