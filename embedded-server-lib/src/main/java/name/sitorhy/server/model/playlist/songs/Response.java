package name.sitorhy.server.model.playlist.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Response{
    public int code;
    public int subcode;
    public int accessed_plaza_cache;
    public int accessed_favbase;
    public String login;
    public int cdnum;
    public ArrayList<Cdlist> cdlist;
    public int realcdnum;
}


