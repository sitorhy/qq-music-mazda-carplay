package name.sitorhy.server.model.category.playlist; 
import com.fasterxml.jackson.annotation.JsonProperty; 
public class HeadBanner{
    @JsonProperty("APPID") 
    public String aPPID;
    @JsonProperty("AppName") 
    public String appName;
    @JsonProperty("DownloadLink") 
    public String downloadLink;
    @JsonProperty("HeadIcon") 
    public String headIcon;
    @JsonProperty("HeadText") 
    public String headText;
    @JsonProperty("ID") 
    public long iD;
    @JsonProperty("IsShow") 
    public boolean isShow;
    @JsonProperty("JumpType") 
    public long jumpType;
    @JsonProperty("Msg") 
    public String msg;
    @JsonProperty("PkgName") 
    public String pkgName;
    @JsonProperty("Schema") 
    public String schema;
    @JsonProperty("URL") 
    public String uRL;
}
