package com.example.pcmvisualizer;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;

public class MyVisualizerView extends View {
    private static final int MODE_LINEAR = 0; // 线性模式
    private static final int MODE_BAR = 1;    // Bar模式

    private int mVisualizerMode = MODE_LINEAR; // 默认是线性模式

    private int mBarCount = 256;               // 默认柱子数量是256

    private byte[] mWaveformData;
    private byte[] mFftData;
    private Paint mWavePaint = new Paint(); // 用于绘制波形的画笔
    private Paint mFftPaint = new Paint();   // 用于绘制频谱的画笔

    private float[] mLastBarHeights;

    public MyVisualizerView(Context context) {
        super(context);
        init(null);
    }

    public MyVisualizerView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(attrs);
    }

    public MyVisualizerView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(attrs);
    }

    public MyVisualizerView(Context context, @Nullable AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init(attrs);
    }

    private void init(@Nullable AttributeSet attrs) {
        // 初始化画笔
        mWavePaint.setColor(0xFF8E44AD);
        mWavePaint.setStrokeWidth(4f);
        mWavePaint.setAntiAlias(true);

        mFftPaint.setColor(0xFF3498DB);
        mFftPaint.setStrokeWidth(5f);
        mFftPaint.setAntiAlias(true);

        // 如果 attrs 不为 null，则解析自定义属性
        if (attrs != null) {
            TypedArray typedArray = getContext().obtainStyledAttributes(attrs, R.styleable.MyVisualizerView);

            // 读取 visualizerMode 属性，如果未设置，则默认为 MODE_LINEAR (0)
            mVisualizerMode = typedArray.getInt(R.styleable.MyVisualizerView_visualizerMode, MODE_LINEAR);

            // 读取 barCount 属性，如果未设置，则默认为 256
            mBarCount = typedArray.getInt(R.styleable.MyVisualizerView_barCount, 256);

            // 回收 TypedArray，这是一个必须的步骤
            typedArray.recycle();
        }
    }


    public void updateWaveform(byte[] waveform) {
        this.mWaveformData = waveform;
        invalidate(); // 请求重绘
    }

    public void updateFft(byte[] fft) {
        this.mFftData = fft;
        invalidate(); // 请求重绘
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (mVisualizerMode == MODE_LINEAR) {
            onDrawLine(canvas);
        } else if (mVisualizerMode == MODE_BAR) {
            onDrawBar(canvas);
        }
    }

    protected void onDrawBar(Canvas canvas) {
        canvas.drawColor(0xFF111111);

        if (mFftData == null) {
            return;
        }

        int barCount = mBarCount;
        if (barCount <= 0) {
            return;
        }

        // 初始化或检查平滑数组
        if (mLastBarHeights == null || mLastBarHeights.length != barCount) {
            mLastBarHeights = new float[barCount];
        }

        float barWidth = (float) getWidth() / barCount;
        int totalFftBins = mFftData.length / 2;
        int binsPerBar = totalFftBins / barCount;
        if (binsPerBar < 1) binsPerBar = 1;

        // --- 视觉增强: 柱子间隙 ---
        float gap = barWidth * 0.2f; // 20% 的间隙
        float barDrawWidth = barWidth - gap;

        for (int i = 0; i < barCount; i++) {
            float magnitudeSum = 0;
            int startBin = i * binsPerBar;
            int endBin = (i + 1) * binsPerBar;
            if (endBin > totalFftBins) endBin = totalFftBins;

            for (int j = startBin; j < endBin; j++) {
                int index = j * 2;
                if (index + 1 < mFftData.length) {
                    float real = mFftData[index];
                    float imag = mFftData[index + 1];
                    magnitudeSum += (float) Math.sqrt(real * real + imag * imag);
                }
            }

            int numBinsInBar = endBin - startBin;
            float averageMagnitude = (numBinsInBar > 0) ? magnitudeSum / numBinsInBar : 0;


            // --- 新增：频率均衡（EQ）增益 ---
            // i 是当前柱子的索引，从左到右 (0 -> barCount-1)
            // 我们设计一个简单的增益函数：频率越高，增益越大
            // float gain = 1.0f + ((float)i / barCount) * 1.0f; // 线性增益，最右边的柱子增益为5倍
            float gain = 1.0f;
            float eqMagnitude = averageMagnitude * gain;

            // 1. --- 专业核心：对数缩放 ---
            // double dbValue = 20 * Math.log10(averageMagnitude + 1e-6);
            // 使用增加了EQ的 eqMagnitude 进行后续计算
            double dbValue = 20 * Math.log10(eqMagnitude + 1e-6);


            float dbRange = -80; // 动态范围可以调，越大，低音部分越高
            float barHeight = (float) ((dbValue + dbRange) / dbRange) * getHeight();
            if (barHeight < 0) barHeight = 0;
            if (barHeight > getHeight()) barHeight = getHeight();

            // 2. --- 专业核心：平滑处理 ---
            float smoothingFactor = 0.2f; // 系数越小越平滑
            float finalBarHeight = mLastBarHeights[i] * (1 - smoothingFactor) + barHeight * smoothingFactor;

            // 3. --- 专业核心：视觉增强 ---
            float left = i * barWidth + (gap / 2);
            float top = getHeight() - finalBarHeight;
            float right = left + barDrawWidth;
            float bottom = getHeight();

            // 根据高度给一点简单的颜色变化
            int alpha = (int) ((finalBarHeight / getHeight()) * 200) + 55;
            mFftPaint.setAlpha(alpha);

            // 使用圆角矩形绘制
            float cornerRadius = barDrawWidth / 2;
            canvas.drawRoundRect(left, top, right, bottom, cornerRadius, cornerRadius, mFftPaint);

            // 更新历史高度
            mLastBarHeights[i] = finalBarHeight;
        }
    }


    protected void onDrawLine(Canvas canvas) {
        canvas.drawColor(0xFF111111); // 使用一个深灰色背景，效果更好

        // 紫色
        if (mWaveformData != null) {
            // 计算每个点在X轴的间距
            float xStep = (float) getWidth() / mWaveformData.length;
            float centerY = getHeight() / 2f; // Y轴的中心线

            // 遍历数据，绘制连接线
            for (int i = 0; i < mWaveformData.length - 1; i++) {
                // waveform 原始值是 byte (-128 to 127)
                // (byteValue + 128) 将其转换为 unsigned byte (0 to 255)
                // 再除以 255.0f 得到一个 0.0 到 1.0 的比例
                // 最后乘以 centerY 来决定振幅高度
                float startY = centerY + ((byte) (mWaveformData[i] + 128)) * getHeight() / 256f - centerY;
                float stopY = centerY + ((byte) (mWaveformData[i + 1] + 128)) * getHeight() / 256f - centerY;

                // 绘制当前点到下一个点的连线
                canvas.drawLine(i * xStep, startY, (i + 1) * xStep, stopY, mWavePaint);
            }
        }

        // 蓝色
        if (mFftData != null) {
            // 计算要绘制的柱子总数，即FFT数据长度的一半
            int barCount = mFftData.length / 2;

            // 计算每个柱子的宽度
            float barWidth = (float) getWidth() / barCount;

            // 遍历所有FFT数据点并绘制
            for (int i = 0; i < barCount; i++) {
                // 计算当前频率点的数组索引
                int index = i * 2;

                // 获取实部和虚部
                float real = mFftData[index];
                float imag = mFftData[index + 1];

                // 计算该频率的能量幅值
                float magnitude = (float) Math.sqrt(real * real + imag * imag);

                // 将幅值映射到视图的高度
                float barHeight = (magnitude / 150f) * getHeight();
                // 增加一个保护，防止柱子画出屏幕
                if (barHeight > getHeight()) {
                    barHeight = getHeight();
                }

                // 计算当前柱子的四个坐标
                float left = i * barWidth;
                float top = getHeight() - barHeight;
                float right = left + barWidth;
                float bottom = getHeight();

                // 绘制长方形
                canvas.drawRect(left, top, right, bottom, mFftPaint);
            }
        }
    }
}
