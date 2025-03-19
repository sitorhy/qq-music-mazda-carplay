package name.sitorhy.server.model.my.follow.singers;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Data{
    @JsonProperty("Msg")
    public String msg;
    @JsonProperty("Total")
    public long total;
    @JsonProperty("FromLimit")
    public long fromLimit;
    @JsonProperty("List")
    public ArrayList<List> list;
    @JsonProperty("HasMore")
    public boolean hasMore;
    @JsonProperty("LastPos")
    public String lastPos;
    @JsonProperty("LockFlag")
    public long lockFlag;
    @JsonProperty("LockMsg")
    public String lockMsg;
    @JsonProperty("SelfInfo")
    public SelfInfo selfInfo;
}
