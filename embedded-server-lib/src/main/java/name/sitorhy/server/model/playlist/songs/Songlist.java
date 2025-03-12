package name.sitorhy.server.model.playlist.songs;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Songlist{
    public String albumdesc;
    public int albumid;
    public String albummid;
    public String albumname;
    public int alertid;
    public int belongCD;
    public int cdIdx;
    public int interval;
    public int isonly;
    public String label;
    public int msgid;
    public Pay pay;
    public Preview preview;
    public int rate;
    public ArrayList<Singer> singer;
    public int size128;
    public int size320;
    public int size5_1;
    public int sizeape;
    public int sizeflac;
    public int sizeogg;
    public int songid;
    public String songmid;
    public String songname;
    public String songorig;
    public int songtype;
    public String strMediaMid;
    public int stream;
    @JsonProperty("switch")
    public int myswitch;
    public int type;
    public String vid;
}
