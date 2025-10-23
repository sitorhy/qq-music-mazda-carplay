package name.sitorhy.qq_music_client_app;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class MediaExtractor {
    private static final String TAG = "MediaExtractor";
    private static final String ZIP_FILE_NAME = "media_archive_flat.zip";
    private static final String LOCK_FILE_NAME = "cache.lock";
    private static final int BUFFER_SIZE = 4096;

    public static File getTargetDir(final Context context) {
        return context.getExternalFilesDir(null);
    }

    private static boolean isCacheLocked(File targetDir) {
        File lockFile = new File(targetDir, LOCK_FILE_NAME);
        return lockFile.exists();
    }

    /**
     * 从 assets 读取 ZIP 文件并解压到公共外部存储。
     *
     * @param context  Context
     * @param listener 进度监听器，用于更新 UI
     */
    public static void extractMediaIfNecessary(final Context context, final ProgressListener listener) {
        final File targetDir = getTargetDir(context);

        if (isCacheLocked(targetDir)) {
            Log.d(TAG, "检测到锁文件，跳过解压。");
            return;
        }

        listener.onReady();

        // 在后台线程执行解压操作
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!targetDir.exists()) {
                        if (!targetDir.mkdirs()) {
                            throw new IOException("目标目录创建失败: " + targetDir.getAbsolutePath());
                        }
                    }

                    Log.d(TAG, "开始解压媒体文件到: " + targetDir.getAbsolutePath());
                    listener.onProgressUpdate("初始化缓存中...");

                    // 1. 获取 ZIP 文件中的文件总数 (用于更精确的进度，这里先简单估算)
                    int fileCount = getZipEntryCount(context, listener);
                    int filesExtracted = 0;

                    InputStream assetInputStream = context.getAssets().open(ZIP_FILE_NAME);
                    ZipInputStream zipInputStream = new ZipInputStream(assetInputStream);
                    ZipEntry zipEntry = zipInputStream.getNextEntry();

                    while (zipEntry != null) {
                        File targetFile = new File(targetDir, zipEntry.getName());

                        // 报告进度（文件名和进度条文字）
                        filesExtracted++;
                        int progress = (int)(((double)filesExtracted / (double) fileCount) * 100.0);
                        String status = String.format("正在释放 %d%s", progress, "%");
                        listener.onProgressUpdate(status);

                        // 写入文件内容
                        FileOutputStream outputStream = new FileOutputStream(targetFile);
                        byte[] buffer = new byte[BUFFER_SIZE];
                        int length;
                        while ((length = zipInputStream.read(buffer)) >= 0) {
                            outputStream.write(buffer, 0, length);
                        }

                        outputStream.close();
                        zipInputStream.closeEntry();

                        zipEntry = zipInputStream.getNextEntry();
                    }

                    zipInputStream.close();
                    assetInputStream.close();

                    if (!new File(targetDir, LOCK_FILE_NAME).exists() && new File(targetDir, LOCK_FILE_NAME).createNewFile()) {
                        Log.d(TAG, "解压成功，并创建了锁文件!");
                    }

                    listener.onComplete(true, "所有文件解压完毕。");

                } catch (IOException e) {
                    Log.e(TAG, "解压媒体文件失败", e);
                    listener.onComplete(false, "错误：" + e.getMessage());
                }
            }
        }).start();
    }

    /**
     * 辅助方法：获取 ZIP 文件中的总文件数 (粗略估算进度需要)
     */
    private static int getZipEntryCount(Context context, final ProgressListener listener) throws IOException {
        int count = 0;
        InputStream is = null;
        ZipInputStream zis = null;
        try {
            is = context.getAssets().open(ZIP_FILE_NAME);
            zis = new ZipInputStream(is);
            ZipEntry entry = zis.getNextEntry();
            while (entry != null) {
                count++;
                listener.onProgressUpdate("正在准备 " + count);
                entry = zis.getNextEntry();
            }
            zis.close();
            is.close();
        } catch (Exception e) {
            if (zis != null) {
                zis.close();
            }
            if (is != null) {
                is.close();
            }
        }
        return count;
    }
}