package com.example.pcmvisualizer;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.example.pcmvisualizer.databinding.FragmentFirstBinding;

public class FirstFragment extends Fragment {

    private FragmentFirstBinding binding;
    private AudioVisualizerViewModel viewModel;
    private MyVisualizerView mVisualizerView;

    @Override
    public View onCreateView(
            @NonNull LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState
    ) {

        binding = FragmentFirstBinding.inflate(inflater, container, false);

        mVisualizerView = binding.myVisualizerView;

        // 获取共享的ViewModel实例
        viewModel = new ViewModelProvider(requireActivity()).get(AudioVisualizerViewModel.class);

        // 观察LiveData的变化
        viewModel.getWaveformData().observe(getViewLifecycleOwner(), waveform -> {
            if (mVisualizerView != null) {
                mVisualizerView.updateWaveform(waveform);
            }
        });

        viewModel.getFftData().observe(getViewLifecycleOwner(), fft -> {
            if (mVisualizerView != null) {
                mVisualizerView.updateFft(fft);
            }
        });


        return binding.getRoot();

    }

    public MyVisualizerView getVisualizerView() {
        if (binding != null) {
            return binding.myVisualizerView;
        }
        return null;
    }

    public void onViewCreated(@NonNull View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

}