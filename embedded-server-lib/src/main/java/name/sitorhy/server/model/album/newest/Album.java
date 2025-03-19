package name.sitorhy.server.model.album.newest;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Album{
    public long id;
    public String mid;
    public String name;
    public String trans_name;
    public ArrayList<Singer> singers;
    public long type;
    public long language;
    public long genre;
    public long area;
    public String movie;
    public String release_time;
    public Company company;
    public long status;
    public String index;
    public String tag;
    public Pay pay;
    public Ex ex;
    public Photo photo;
    public String tmetags;
    public long ex_status;
    public long show_com_new;
    public Companyshow companyshow;
    public String modify_time;
    public String str_genre;
    public long album_right;
    @JsonProperty("Fpay_control")
    public long fpay_control;
    public String cd_album_id;
    public String mini_album_id;
    public Data data;
    public String album_wiki;
    public VipPlayConf vip_play_conf;
    public String album_ori_name;
    public ArrayList<Object> singers_with_anonymous;
    public String other_name;
    public String mv_ids;
    public String vids;
    public String head_magic_color;
}
