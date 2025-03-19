package name.sitorhy.server.model.my.follow.singers;

import com.fasterxml.jackson.annotation.JsonProperty;

public class List{
    @JsonProperty("MID")
    public String mID;
    @JsonProperty("EncUin")
    public String encUin;
    @JsonProperty("Name")
    public String name;
    @JsonProperty("Desc")
    public String desc;
    @JsonProperty("AvatarUrl")
    public String avatarUrl;
    @JsonProperty("VipIconUrl")
    public String vipIconUrl;
    @JsonProperty("MarkUrl")
    public String markUrl;
    @JsonProperty("FanNum")
    public long fanNum;
    @JsonProperty("IsFollow")
    public boolean isFollow;
    @JsonProperty("OtherInfo")
    public OtherInfo otherInfo;
    @JsonProperty("ExtraInfo")
    public ExtraInfo extraInfo;
    public ExtraInfo extra_info;
    @JsonProperty("NewIconInfo")
    public NewIconInfo newIconInfo;
    @JsonProperty("BeFollowed")
    public boolean beFollowed;
    @JsonProperty("Time")
    public long time;
    @JsonProperty("Medal")
    public Medal medal;
}
