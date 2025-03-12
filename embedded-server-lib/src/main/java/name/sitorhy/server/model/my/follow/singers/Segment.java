package name.sitorhy.server.model.my.follow.singers;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Segment{
    @JsonProperty("Width")
    public int width;
    @JsonProperty("Height")
    public int height;
    @JsonProperty("DarkIconURL")
    public String darkIconURL;
    @JsonProperty("LightIconURL")
    public String lightIconURL;
    @JsonProperty("StretchLeft")
    public int stretchLeft;
    @JsonProperty("StretchRight")
    public int stretchRight;
    @JsonProperty("Contents")
    public Object contents;
    @JsonProperty("MaxDisplayLen")
    public int maxDisplayLen;
    @JsonProperty("PaddingLeft")
    public int paddingLeft;
    @JsonProperty("PaddingRight")
    public int paddingRight;
    @JsonProperty("JumpURL")
    public String jumpURL;
}
