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

        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (mVisualizerMode == MODE_LINEAR) {
            onDrawLine(canvas);
        } else if (mVisualizerMode == MODE_BAR) {
            // onDrawBar(canvas);
            onDrawBarGroup(canvas);
        }
    }


    // 在类的顶部添加一个常量，用于表示相对dB的最小范围
    // 这个值定义了最弱的信号（相对于最强信号）能显示到多低
    private static final float MIN_RELATIVE_DB_VALUE = -60f;

    // 绘制经过对数分组和平滑处理的相对分贝图像
    protected void onDrawBarGroup(Canvas canvas) {
        // 先清空画布
        canvas.drawColor(0xFF111111);

        // 检查原始FFT数据是否存在
        if (mFftData == null) {
            return;
        }

        // mFftData.length / 2 是FFT分析出的总频率点数
        int totalFrequencyCount = mFftData.length / 2;
        if (totalFrequencyCount == 0 || mBarCount == 0) {
            return;
        }

        // **第一步：对FFT数据进行对数分组，并计算每组的平均幅值**

        // `groupedMagnitudes` 数组用于存放最终 mBarCount 个柱子的幅值
        float[] groupedMagnitudes = new float[mBarCount];
        // `groupCounts` 用于记录每个分组包含了多少个原始频率点，方便计算平均值
        int[] groupCounts = new int[mBarCount];

        // 定义对数分组的边界点。第0个边界点是0。
        int[] groupBoundaries = new int[mBarCount + 1];
        groupBoundaries[0] = 0;

        // 使用对数公式计算每个分组的右边界
        // totalFrequencyCount - 1 是最后一个频率点的索引
        // Math.log(mBarCount) 是底数
        for (int i = 1; i <= mBarCount; i++) {
            // 这个公式使得低频部分分组更窄，高频部分分组更宽
            double logIndex = Math.log(i) / Math.log(mBarCount) * (totalFrequencyCount - 1);
            groupBoundaries[i] = (int) logIndex + 1;
        }

        // 遍历所有原始频率点，将它们的幅值累加到对应的分组中
        for (int i = 0; i < totalFrequencyCount; i++) {
            // 计算当前频率点的幅值
            int index = i * 2;
            float real = mFftData[index];
            float imag = mFftData[index + 1];
            float magnitude = (float) Math.sqrt(real * real + imag * imag);

            // 寻找当前频率点 `i` 属于哪个分组 `j`
            for (int j = 0; j < mBarCount; j++) {
                if (i >= groupBoundaries[j] && i < groupBoundaries[j + 1]) {
                    groupedMagnitudes[j] += magnitude;
                    groupCounts[j]++;
                    break; // 找到分组后即可跳出内层循环
                }
            }
        }

        // 计算每组的平均幅值，并找到所有组中的最大平均幅值
        float maxGroupedMagnitude = 0f;
        for (int i = 0; i < mBarCount; i++) {
            if (groupCounts[i] > 0) {
                groupedMagnitudes[i] /= groupCounts[i]; // 除以数量，求平均
            }
            if (groupedMagnitudes[i] > maxGroupedMagnitude) {
                maxGroupedMagnitude = groupedMagnitudes[i];
            }
        }

        // 防止除以零
        if (maxGroupedMagnitude == 0) {
            return;
        }


        // **第二步：使用分组后的相对分贝值绘制所有柱子**

        // 计算每个柱子的宽度
        float barWidth = (float) getWidth() / mBarCount;

        for (int i = 0; i < mBarCount; i++) {
            float magnitude = groupedMagnitudes[i];

            // 计算相对dB值
            float ratio = (magnitude > 0) ? (magnitude / maxGroupedMagnitude) : 0f;
            float dbValue = (ratio > 0) ? (float) (20 * Math.log10(ratio)) : MIN_RELATIVE_DB_VALUE;

            // 归一化dB值并映射到视图高度
            float normalizedHeight = (dbValue - MIN_RELATIVE_DB_VALUE) / -MIN_RELATIVE_DB_VALUE;
            normalizedHeight = Math.max(0f, Math.min(1f, normalizedHeight));

            float barHeight = normalizedHeight * getHeight();

            // 计算当前柱子的四个坐标
            float left = i * barWidth;
            float top = getHeight() - barHeight;
            float right = left + barWidth;
            float bottom = getHeight();

            // 绘制长方形
            canvas.drawRect(left, top, right, bottom, mFftPaint);
        }
    }

    // 绘制相对分贝图像
    protected void onDrawBar(Canvas canvas) {
        // 先清空画布
        canvas.drawColor(0xFF111111);

        // 检查原始FFT数据是否存在
        if (mFftData == null) {
            return;
        }

        // 计算要绘制的柱子总数，即FFT数据长度的一半
        int barCount = mFftData.length / 2;
        if (barCount == 0) {
            return;
        }

        // **第一步：计算所有幅值并找到最大值**
        // 创建一个数组来存储当前帧的所有幅值
        float[] magnitudes = new float[barCount];
        // 用于寻找当前帧的最大幅值
        float maxMagnitude = 0f;
        for (int i = 0; i < barCount; i++) {
            // 计算当前频率点的数组索引
            int index = i * 2;
            // 获取实部和虚部
            float real = mFftData[index];
            float imag = mFftData[index + 1];

            // 计算该频率的能量幅值
            float magnitude = (float) Math.sqrt(real * real + imag * imag);
            magnitudes[i] = magnitude;

            if (magnitude > maxMagnitude) {
                maxMagnitude = magnitude;
            }
        }

        // 防止除以零
        if (maxMagnitude == 0) {
            return;
        }

        // 计算每个柱子的宽度
        float barWidth = (float) getWidth() / barCount;

        // **第二步：使用相对分贝值绘制所有柱子**
        for (int i = 0; i < barCount; i++) {
            float magnitude = magnitudes[i];

            // 计算当前幅值相对于最大幅值的比例
            // 为避免log(0)，给一个极小的下限
            float ratio = (magnitude > 0) ? (magnitude / maxMagnitude) : 0f;

            // 计算相对dB值。结果范围在 (-∞, 0]
            float dbValue = (ratio > 0) ? (float) (20 * Math.log10(ratio)) : MIN_RELATIVE_DB_VALUE;

            // 将相对dB值 [MIN_RELATIVE_DB_VALUE, 0] 映射到视图高度 [0, getHeight()]
            // 公式: (当前值 - 最小值) / (最大值 - 最小值)
            float normalizedHeight = (dbValue - MIN_RELATIVE_DB_VALUE) / -MIN_RELATIVE_DB_VALUE;

            // 确保高度比例在 0.0 到 1.0 之间
            normalizedHeight = Math.max(0f, Math.min(1f, normalizedHeight));

            float barHeight = normalizedHeight * getHeight();

            // 计算当前柱子的四个坐标
            float left = i * barWidth;
            float top = getHeight() - barHeight;
            float right = left + barWidth;
            float bottom = getHeight();

            // 绘制长方形
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
