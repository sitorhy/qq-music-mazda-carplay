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

    /**
     * 检查目标目录是否存在 cache.lock 文件。
     */
    private static boolean isCacheLocked(File targetDir) {
        File lockFile = new File(targetDir, LOCK_FILE_NAME);
        return lockFile.exists();
    }

    /**
     * 从 assets 读取 ZIP 文件并解压到公共外部存储。
     * 必须确保在调用此方法前已获取 WRITE_EXTERNAL_STORAGE 权限。
     *
     * @param context Context
     */
    public static void extractMediaIfNecessary(final Context context) {
        final File targetDir = getTargetDir(context);

        if (isCacheLocked(targetDir)) {
            Log.d(TAG, "检测到 " + targetDir.getAbsolutePath() + "/" + LOCK_FILE_NAME + " 文件，跳过解压。");
            return;
        }

        // 在后台线程执行解压操作，避免阻塞 UI 线程
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // 如果目标目录不存在，创建它
                    if (!targetDir.exists()) {
                        if (!targetDir.mkdirs()) {
                            Log.e(TAG, "目标目录创建失败: " + targetDir.getAbsolutePath());
                            return;
                        }
                    }

                    Log.d(TAG, "未检测到锁文件，开始解压媒体文件到: " + targetDir.getAbsolutePath());

                    // 1. 获取 Assets 中的输入流
                    InputStream assetInputStream = context.getAssets().open(ZIP_FILE_NAME);
                    ZipInputStream zipInputStream = new ZipInputStream(assetInputStream);
                    ZipEntry zipEntry;

                    // 2. 遍历 ZIP 归档中的每个文件
                    while ((zipEntry = zipInputStream.getNextEntry()) != null) {
                        if (zipEntry.isDirectory()) {
                            continue;
                        }

                        // ZIP 文件是平铺结构，name 即为纯文件名
                        File targetFile = new File(targetDir, zipEntry.getName());

                        // 3. 写入文件内容
                        FileOutputStream outputStream = new FileOutputStream(targetFile);
                        byte[] buffer = new byte[BUFFER_SIZE];
                        int length;
                        while ((length = zipInputStream.read(buffer)) > 0) {
                            outputStream.write(buffer, 0, length);
                        }

                        outputStream.close();
                        zipInputStream.closeEntry();
                    }

                    zipInputStream.close();
                    assetInputStream.close();

                    // 4. 解压完成后创建 cache.lock 文件
                    if (new File(targetDir, LOCK_FILE_NAME).createNewFile()) {
                        Log.d(TAG, "🎉 媒体文件解压成功，并创建了 " + LOCK_FILE_NAME + " 锁文件!");
                    } else {
                        Log.e(TAG, "创建锁文件失败: " + LOCK_FILE_NAME);
                    }

                } catch (IOException e) {
                    Log.e(TAG, "❌ 解压媒体文件失败", e);
                }
            }
        }).start();
    }
}
