package com.example.pcmvisualizer;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class AudioVisualizerViewModel extends ViewModel {
    private final MutableLiveData<byte[]> waveformData = new MutableLiveData<>();
    private final MutableLiveData<byte[]> fftData = new MutableLiveData<>();

    public LiveData<byte[]> getWaveformData() {
        return waveformData;
    }

    public LiveData<byte[]> getFftData() {
        return fftData;
    }

    public void updateWaveform(byte[] data) {
        waveformData.setValue(data);
    }

    public void updateFft(byte[] data) {
        fftData.setValue(data);
    }
}
