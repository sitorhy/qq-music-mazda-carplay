package name.sitorhy.server.model.my.follow.singers;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Medal{
    @JsonProperty("ShowMedal")
    public long showMedal;
    @JsonProperty("ShowValue")
    public long showValue;
    @JsonProperty("FansValue")
    public long fansValue;
    @JsonProperty("Medal")
    public Medal medal;
    @JsonProperty("IsReceivedMedal")
    public long isReceivedMedal;
    @JsonProperty("Scheme")
    public String scheme;
    @JsonProperty("Title")
    public String title;
    @JsonProperty("Icon")
    public String icon;
    @JsonProperty("Color")
    public String color;
    @JsonProperty("Segment")
    public Segment segment;
    @JsonProperty("Style")
    public long style;
}
