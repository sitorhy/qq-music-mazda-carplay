package name.sitorhy.server.model;

import java.util.List;

public class CategoryGroup {
    private String title;
    private List<String> categoryTypes;
    private List<CategoryMeta> categories;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<String> getCategoryTypes() {
        return categoryTypes;
    }

    public void setCategoryTypes(List<String> categoryTypes) {
        this.categoryTypes = categoryTypes;
    }

    public List<CategoryMeta> getCategories() {
        return categories;
    }

    public void setCategories(List<CategoryMeta> categories) {
        this.categories = categories;
    }
}
