package name.sitorhy.server.model.my.follow.singers;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Segment{
    @JsonProperty("Width")
    public long width;
    @JsonProperty("Height")
    public long height;
    @JsonProperty("DarkIconURL")
    public String darkIconURL;
    @JsonProperty("LightIconURL")
    public String lightIconURL;
    @JsonProperty("StretchLeft")
    public long stretchLeft;
    @JsonProperty("StretchRight")
    public long stretchRight;
    @JsonProperty("Contents")
    public Object contents;
    @JsonProperty("MaxDisplayLen")
    public long maxDisplayLen;
    @JsonProperty("PaddingLeft")
    public long paddingLeft;
    @JsonProperty("PaddingRight")
    public long paddingRight;
    @JsonProperty("JumpURL")
    public String jumpURL;
}
