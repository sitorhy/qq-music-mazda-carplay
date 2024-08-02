package name.sitorhy.server.model;

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

    private String title;
    private String subtitle;
    private String picUrl;

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
}
