package name.sitorhy.server.model.category.recommend;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.ArrayList;

public class Data{
    @JsonProperty("Msg") 
    public String msg;
    @JsonProperty("List") 
    public ArrayList<List> list;
    @JsonProperty("HasMore") 
    public boolean hasMore;
    @JsonProperty("FromLimit") 
    public long fromLimit;
}
