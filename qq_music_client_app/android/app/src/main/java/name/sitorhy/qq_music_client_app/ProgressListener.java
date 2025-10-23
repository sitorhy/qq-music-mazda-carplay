package name.sitorhy.qq_music_client_app;

public interface ProgressListener {
    // 显示对话框
    void onReady();

    // 用于更新对话框中的文字状态
    void onProgressUpdate(String status);

    // 用于通知任务完成
    void onComplete(boolean success, String message);
}