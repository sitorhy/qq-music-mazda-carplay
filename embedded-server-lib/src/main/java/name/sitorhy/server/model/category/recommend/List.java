package name.sitorhy.server.model.category.recommend;

import com.fasterxml.jackson.annotation.JsonProperty; 

public class List{
    @JsonProperty("Playlist") 
    public Playlist playlist;
    @JsonProperty("WhereFrom") 
    public String whereFrom;
    public Object ext;
}
