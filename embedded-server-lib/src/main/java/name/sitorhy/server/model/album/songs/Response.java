package name.sitorhy.server.model.album.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Response{
    public int code;
    public long ts;
    public long start_ts;
    public String traceid;
    public AlbumSonglist albumSonglist;
}

