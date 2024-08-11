package name.sitorhy.server.model;

import java.util.List;

/**
 * 歌单基本信息，不包含歌曲
 */
public class Album {
    /**
     * 歌单公共id，用于获取歌曲列表
     */
    private long dissId;

    /**
     * 用户自建歌单私有id，《我喜欢》固定为201，私有id用于歌曲收藏/取消收藏
     */
    private long dirId;

    /**
     * 有版权的专辑id，专辑歌曲详情使用另外的接口
     */
    private String albumMid;
    private long albumId;

    /**
     * 专辑歌手，自建歌单为空
     */
    private List<Singer> singers;

    private String title;
    private String subtitle;
    private String picUrl;
    private String author;

    public long getDissId() {
        return dissId;
    }

    public void setDissId(long dissId) {
        this.dissId = dissId;
    }

    public long getDirId() {
        return dirId;
    }

    public void setDirId(long dirId) {
        this.dirId = dirId;
    }

    public String getAlbumMid() {
        return albumMid;
    }

    public void setAlbumMid(String albumMid) {
        this.albumMid = albumMid;
    }

    public long getAlbumId() {
        return albumId;
    }

    public void setAlbumId(long albumId) {
        this.albumId = albumId;
    }

    public List<Singer> getSingers() {
        return singers;
    }

    public void setSingers(List<Singer> singers) {
        this.singers = singers;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getPicUrl() {
        return picUrl;
    }

    public void setPicUrl(String picUrl) {
        this.picUrl = picUrl;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }
}
