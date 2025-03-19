package name.sitorhy.server.model.song.top; 
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;

public class Toplist{
    public long topId;
    public long recType;
    public long topType;
    public long updateType;
    public String title;
    public String titleDetail;
    public String titleShare;
    public String titleSub;
    public String intro;
    public long cornerMark;
    public String period;
    public String updateTime;
    public History history;
    public long listenNum;
    public long totalNum;
    public ArrayList<Song> song;
    public String headPicUrl;
    public String frontPicUrl;
    public String mbFrontPicUrl;
    public String mbHeadPicUrl;
    public ArrayList<Object> pcSubTopIds;
    public ArrayList<Object> pcSubTopTitles;
    public ArrayList<Object> subTopIds;
    public String adJumpUrl;
    public String h5JumpUrl;
    public String url_key;
    public String url_params;
    public String tjreport;
    public long rt;
    public String updateTips;
    public String bannerText;
    @JsonProperty("AdShareContent") 
    public String adShareContent;
    public String abt;
    public long cityId;
    public long provId;
    public long sinceCV;
    public String musichallTitle;
    public String musichallSubtitle;
    public String musichallPicUrl;
    public String specialScheme;
    public String mbFrontLogoUrl;
    public String mbHeadLogoUrl;
    public String cityName;
    public MagicColor magicColor;
    public String topAlbumURL;
    public long groupType;
    public long icon;
    public long adID;
    public String mbIntroWebUrl;
    public String mbLogoUrl;
}
