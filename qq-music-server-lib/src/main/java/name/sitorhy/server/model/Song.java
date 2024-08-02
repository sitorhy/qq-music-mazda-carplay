package name.sitorhy.server.model;

import java.util.List;

public class Song {
    private String dissId;
    private String dissName;
    private String albumDesc;
    private long albumId;
    private String albumMid;
    private String albumName;
    private String albumCoverUrl;
    private List<Singer> singers;
    private long songId;
    private String songMid;
    private String songName;
    private String songOrig;
    private String strMediaMid;

    /**
     * 歌曲时常，单位：秒
     */
    private long interval;

    public String getDissId() {
        return dissId;
    }

    public void setDissId(String dissId) {
        this.dissId = dissId;
    }

    public String getDissName() {
        return dissName;
    }

    public void setDissName(String dissName) {
        this.dissName = dissName;
    }

    public String getAlbumDesc() {
        return albumDesc;
    }

    public void setAlbumDesc(String albumDesc) {
        this.albumDesc = albumDesc;
    }

    public long getAlbumId() {
        return albumId;
    }

    public void setAlbumId(long albumId) {
        this.albumId = albumId;
    }

    public String getAlbumMid() {
        return albumMid;
    }

    public void setAlbumMid(String albumMid) {
        this.albumMid = albumMid;
    }

    public String getAlbumName() {
        return albumName;
    }

    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }

    public String getAlbumCoverUrl() {
        return albumCoverUrl;
    }

    public void setAlbumCoverUrl(String albumCoverUrl) {
        this.albumCoverUrl = albumCoverUrl;
    }

    public List<Singer> getSingers() {
        return singers;
    }

    public void setSingers(List<Singer> singers) {
        this.singers = singers;
    }

    public long getSongId() {
        return songId;
    }

    public void setSongId(long songId) {
        this.songId = songId;
    }

    public String getSongMid() {
        return songMid;
    }

    public void setSongMid(String songMid) {
        this.songMid = songMid;
    }

    public String getSongName() {
        return songName;
    }

    public void setSongName(String songName) {
        this.songName = songName;
    }

    public String getSongOrig() {
        return songOrig;
    }

    public void setSongOrig(String songOrig) {
        this.songOrig = songOrig;
    }

    public String getStrMediaMid() {
        return strMediaMid;
    }

    public void setStrMediaMid(String strMediaMid) {
        this.strMediaMid = strMediaMid;
    }

    public long getInterval() {
        return interval;
    }

    public void setInterval(long interval) {
        this.interval = interval;
    }
}
