package name.sitorhy.device_info_plugin;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;
import android.os.storage.StorageManager;
import android.os.storage.StorageVolume;
import android.util.DisplayMetrics;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import kotlin.text.Regex;

/**
 * DeviceInfoPlugin
 */
public class DeviceInfoPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private FlutterPluginBinding binding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        binding = flutterPluginBinding;
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "device_info_plugin");
        channel.setMethodCallHandler(this);
    }

    private static long convertMemInfoToBytes(String line) {
        int index = line.indexOf(':');
        String num = line.substring(index + 1).trim();
        num = num.replaceAll("[^0-9]", "");
        return Integer.parseInt(num) * 1024; // MemTotal的单位是KB，需要转换为Bytes
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "getResolutionRatio": {
                DisplayMetrics displayMetrics = binding.getApplicationContext().getResources().getDisplayMetrics();
                result.success(new HashMap<String, Integer>() {{
                    put("width", displayMetrics.widthPixels);
                    put("height", displayMetrics.heightPixels);
                    put("dpi", displayMetrics.densityDpi);
                }});
            }
            break;
            case "getAvailMemorySize": {
                ActivityManager.MemoryInfo memInfo = new ActivityManager.MemoryInfo();
                ActivityManager activityManager = (ActivityManager) binding.getApplicationContext().getSystemService(Context.ACTIVITY_SERVICE);
                activityManager.getMemoryInfo(memInfo);
                result.success(memInfo.availMem);
            }
            break;
            case "getTotalMemorySize": {
                String path = "/proc/meminfo";
                String line;
                try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
                    while ((line = reader.readLine()) != null) {
                        if (line.startsWith("MemTotal:")) {
                            result.success(convertMemInfoToBytes(line));
                            return;
                        }
                    }
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
                result.success(0);
            }
            break;
            case "getStorageSize": {
                File path = Environment.getDataDirectory();
                StatFs stat = new StatFs(path.getPath());
                long blockSize = stat.getBlockSizeLong();
                long totalBlocks = stat.getBlockCountLong();

                long totalSize = blockSize * totalBlocks;

                result.success(totalSize);
            }
            break;
            case "getAvailStorageSize": {
                File path = Environment.getDataDirectory();
                StatFs stat = new StatFs(path.getPath());
                long blockSize = stat.getBlockSizeLong();
                long availableBlocks = stat.getAvailableBlocksLong();

                long availableSize = blockSize * availableBlocks;

                result.success(availableSize);
            }
            break;
            case "getExtStorageSize": {
                StorageManager storageManager = (StorageManager) binding.getApplicationContext().getSystemService(Context.STORAGE_SERVICE);
                List<StorageVolume> volumeInfos = storageManager.getStorageVolumes();

                for (StorageVolume vol : volumeInfos) {
                    if (vol.isRemovable()) {
                        String name = vol.getMediaStoreVolumeName();
                        StatFs stat = new StatFs(vol.getDirectory().getPath());

                        long blockSize = stat.getBlockSizeLong();
                        long totalBlocks = stat.getBlockCountLong();

                        long totalSize = blockSize * totalBlocks;

                        result.success(totalSize);
                    }
                }

                result.success(0);
            }
            break;
            case "getAvailExtStorageSize": {
                StorageManager storageManager = (StorageManager) binding.getApplicationContext().getSystemService(Context.STORAGE_SERVICE);
                List<StorageVolume> volumeInfos = storageManager.getStorageVolumes();

                for (StorageVolume vol : volumeInfos) {
                    if (vol.isRemovable()) {
                        String name = vol.getMediaStoreVolumeName();
                        StatFs stat = new StatFs(vol.getDirectory().getPath());

                        long blockSize = stat.getBlockSizeLong();
                        long availableBlocks = stat.getAvailableBlocksLong();

                        long availableSize = blockSize * availableBlocks;

                        result.success(availableSize);
                    }
                }

                result.success(0);
            }
            break;
            case "getManufacturer": {
                result.success(Build.MANUFACTURER);
            }
            break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
