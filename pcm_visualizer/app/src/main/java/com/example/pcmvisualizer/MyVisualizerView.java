package com.example.pcmvisualizer;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
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
    private Paint mForePaint = new Paint();
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

        mForePaint.setStrokeWidth(10f);
        mForePaint.setAntiAlias(true);
        mForePaint.setColor(Color.rgb(0, 128, 255));

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

        updateVisualizer(fft);

        // invalidate(); // 请求重绘
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

    private byte[] mBytes;

    private final Rect mRect = new Rect();

    public void updateVisualizer(byte[] fft) {
        byte[] model = new byte[fft.length / 2 + 1];
        model[0] = (byte) Math.abs(fft[0]);
        for (int i = 2, j = 1; j < mBarCount; ++j) {
            model[j] = (byte) Math.hypot(fft[i], fft[i + 1]);
            i += 2;
        }
        mBytes = model;
        invalidate();
    }

    protected void onDrawBar(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawColor(0xFF111111);
        if (mBytes == null) {
            return;
        }
        mRect.set(0, 0, getWidth(), getHeight());

        final int width = mRect.width();
        final int height = mRect.height();

        // 计算每个柱子的总宽度（包含间隙）
        final float barTotalWidth = (float)width / mBarCount;
        // 定义柱子之间的间隙，例如总宽度的 1/4
        final float gap = barTotalWidth / 4;
        // 计算柱子本身的绘制宽度
        final float barDrawWidth = barTotalWidth - gap;

        for (int i = 0; i < mBarCount; i++) {
            if (mBytes[i] < 0) {
                mBytes[i] = 127;
            }

            // 计算当前柱子的高度
            // 为了让视觉效果更好，可以乘以一个缩放因子
            float barHeight = mBytes[i] * 5; // 尝试乘以2，让柱子更高
            if (barHeight > height) {
                barHeight = height;
            }

            // 计算当前柱子的坐标
            float left = i * barTotalWidth + gap / 2;
            float top = height - barHeight;
            float right = left + barDrawWidth;
            float bottom = height;

            // 使用 drawRect 绘制实心矩形
            canvas.drawRect(left, top, right, bottom, mFftPaint);
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
                Log.d("能量值", String.valueOf(magnitude));
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
