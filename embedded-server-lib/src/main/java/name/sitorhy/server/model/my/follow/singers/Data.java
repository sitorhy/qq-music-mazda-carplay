package name.sitorhy.server.model.my.follow.singers;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Data{
    @JsonProperty("Msg")
    public String msg;
    @JsonProperty("Total")
    public int total;
    @JsonProperty("FromLimit")
    public int fromLimit;
    @JsonProperty("List")
    public ArrayList<List> list;
    @JsonProperty("HasMore")
    public boolean hasMore;
    @JsonProperty("LastPos")
    public String lastPos;
    @JsonProperty("LockFlag")
    public int lockFlag;
    @JsonProperty("LockMsg")
    public String lockMsg;
    @JsonProperty("SelfInfo")
    public SelfInfo selfInfo;
}
