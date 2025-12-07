package com.example.pcmvisualizer;

import android.content.pm.PackageManager;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;
import android.os.Bundle;

import com.google.android.material.snackbar.Snackbar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.view.View;

import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.fragment.NavHostFragment;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.example.pcmvisualizer.databinding.ActivityMainBinding;

import android.view.Menu;
import android.view.MenuItem;

public class MainActivity extends AppCompatActivity {

    private static final int REQUEST_RECORD_AUDIO_PERMISSION = 200;
    private AppBarConfiguration appBarConfiguration;
    private ActivityMainBinding binding;

    private MediaPlayer mMediaPlayer;
    private Visualizer mVisualizer;
    private MyVisualizerView mVisualizerView; // 在Activity中持有一个引用

    private AudioVisualizerViewModel viewModel;


    private void checkAndRequestAudioPermission() {
        if (checkSelfPermission(android.Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
            binding.getRoot().post(this::setupAudioAndVisualizer);
        } else {
            requestPermissions(new String[]{android.Manifest.permission.RECORD_AUDIO}, REQUEST_RECORD_AUDIO_PERMISSION);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == REQUEST_RECORD_AUDIO_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                binding.getRoot().post(this::setupAudioAndVisualizer);
            } else {
                Snackbar.make(binding.getRoot(), "必须授予录音权限才能使用音频可视化功能", Snackbar.LENGTH_LONG).show();
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setSupportActionBar(binding.toolbar);

        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_main);
        appBarConfiguration = new AppBarConfiguration.Builder(navController.getGraph()).build();
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);

        binding.fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAnchorView(R.id.fab)
                        .setAction("Action", null).show();
            }
        });

        viewModel = new ViewModelProvider(this).get(AudioVisualizerViewModel.class);
        // 添加一个目标变化监听器
        navController.addOnDestinationChangedListener((controller, destination, arguments) -> {
            // 当目标是 FirstFragment 时，我们知道它可以被获取了
            if (destination.getId() == R.id.FirstFragment) {
                // 为了防止重复初始化（例如从其他页面返回时），增加一个判断
                if (mVisualizer == null) {
                    // 使用 post 是一个非常安全的技巧，确保在下一个UI线程循环中执行，
                    // 此时所有视图都已布局完毕。
                    checkAndRequestAudioPermission();
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public boolean onSupportNavigateUp() {
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_main);
        return NavigationUI.navigateUp(navController, appBarConfiguration)
                || super.onSupportNavigateUp();
    }

    private void setupAudioAndVisualizer() {
        mMediaPlayer = MediaPlayer.create(this, R.raw.test);
        mMediaPlayer.setLooping(true);
        mMediaPlayer.start();

        NavHostFragment hostFragment = (NavHostFragment) getSupportFragmentManager().findFragmentById(R.id.nav_host_fragment_content_main);
        if (hostFragment != null) {
            // 从NavHostFragment的子管理器中获取当前显示的Fragment
            androidx.fragment.app.Fragment currentFragment = hostFragment.getChildFragmentManager().getFragments().get(0);
            // 判断它是不是我们想要的 FirstFragment
            if (currentFragment instanceof FirstFragment) {
                mVisualizerView = ((FirstFragment) currentFragment).getVisualizerView();
            }
        }

        if (mVisualizerView != null && mMediaPlayer != null) {
            int audioSessionId = mMediaPlayer.getAudioSessionId();
            if (audioSessionId != 0) {
                mVisualizer = new Visualizer(audioSessionId);
                mVisualizer.setCaptureSize(Visualizer.getCaptureSizeRange()[1]);

                mVisualizer.setDataCaptureListener(new Visualizer.OnDataCaptureListener() {
                    @Override
                    public void onWaveFormDataCapture(Visualizer visualizer, byte[] waveform, int samplingRate) {
                        viewModel = new ViewModelProvider(MainActivity.this).get(AudioVisualizerViewModel.class);
                        viewModel.updateWaveform(waveform);
                    }

                    @Override
                    public void onFftDataCapture(Visualizer visualizer, byte[] fft, int samplingRate) {
                        viewModel.updateFft(fft);
                    }
                }, Visualizer.getMaxCaptureRate() / 2, true, true);

                mVisualizer.setEnabled(true);
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mMediaPlayer != null) {
            if (mMediaPlayer.isPlaying()) {
                mMediaPlayer.stop();
            }
            mMediaPlayer.release(); // 释放MediaPlayer
            mMediaPlayer = null;
        }
        if (mVisualizer != null) {
            mVisualizer.release();
            mVisualizer = null;
        }
    }
}