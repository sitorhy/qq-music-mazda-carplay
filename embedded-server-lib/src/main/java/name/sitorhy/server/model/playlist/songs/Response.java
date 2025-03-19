package name.sitorhy.server.model.playlist.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Response{
    public long code;
    public long subcode;
    public long accessed_plaza_cache;
    public long accessed_favbase;
    public String login;
    public long cdnum;
    public ArrayList<Cdlist> cdlist;
    public long realcdnum;
}


