package name.sitorhy.server.model;

import java.util.List;

public class CategoryGroup {
    private String title;
    private List<CategoryMeta> metaList;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<CategoryMeta> getMetaList() {
        return metaList;
    }

    public void setMetaList(List<CategoryMeta> metaList) {
        this.metaList = metaList;
    }
}
