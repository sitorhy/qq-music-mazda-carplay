package name.sitorhy.server.model.playlist.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Songlist{
    public String albumdesc;
    public long albumid;
    public String albummid;
    public String albumname;
    public long alertid;
    public long belongCD;
    public long cdIdx;
    public long interval;
    public long isonly;
    public String label;
    public long msgid;
    public Pay pay;
    public Preview preview;
    public long rate;
    public ArrayList<Singer> singer;
    public long size128;
    public long size320;
    public long size5_1;
    public long sizeape;
    public long sizeflac;
    public long sizeogg;
    public long songid;
    public String songmid;
    public String songname;
    public String songorig;
    public long songtype;
    public String strMediaMid;
    public long stream;
    @JsonProperty("switch")
    public long myswitch;
    public long type;
    public String vid;
}
