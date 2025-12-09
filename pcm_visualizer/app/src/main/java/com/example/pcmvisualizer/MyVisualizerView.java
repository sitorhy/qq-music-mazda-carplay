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
            // onDrawBarGroup(canvas);
            // onDrawBarGroup2(canvas);
            // onDrawBarGroupMel(canvas);
            onDrawBarGroupBark(canvas);
        }
    }


    /**
     * 将频率(Hz)转换为巴克刻度。
     * 使用 Traunmüller (1990) 的公式。
     * @param hz 频率值，单位 Hz
     * @return 对应的巴克刻度值
     */
    private double hzToBark(double hz) {
        return ((26.81 * hz) / (1960 + hz)) - 0.53;
    }

    /**
     * 将巴克刻度转换回频率(Hz)。
     * hzToBark 公式的反函数。
     * @param bark 巴克刻度值
     * @return 对应的频率值，单位 Hz
     */
    private double barkToHz(double bark) {
        return 1960 * (bark + 0.53) / (26.81 - (bark + 0.53));
    }

    /**
     * 基于巴克刻度（Bark Scale）的可视化方案。
     * 巴克刻度是另一种基于心理声学临界频带的非线性频率标度。
     * 1. 设定一个固定的频率范围 [fmin, fmax]。
     * 2. 将此频率范围的两端转换为巴克刻度 [barkMin, barkMax]。
     * 3. 在巴克刻度上进行线性（均匀）分割，得到每个柱子的巴克刻度边界。
     * 4. 将这些巴克刻度边界再转换回频率（Hz）边界。
     * 5. 将FFT数据按计算出的频率边界进行分组、求平均能量，并绘制。
     */
    protected void onDrawBarGroupBark(Canvas canvas) {
        // 先清空画布
        canvas.drawColor(0xFF111111);

        // 检查原始FFT数据是否存在
        if (mFftData == null) {
            return;
        }

        // totalFrequencyCount 是FFT分析出的总频率点数
        int totalFrequencyCount = mFftData.length / 2;
        if (totalFrequencyCount == 0 || mBarCount == 0) {
            return;
        }

        // **第一步：基于巴克刻度，定义频率边界 (Hz)**

        // 设定我们感兴趣的频率范围
        float fMin = 20f;  // 频率下限 (Hz)
        float fMax = Math.min(20000f, (float) AUDIO_SAMPLE_RATE / 2.0f); // 频率上限 (Hz)

        // 1. 将频率范围的端点转换为巴克刻度
        double barkMin = hzToBark(fMin);
        double barkMax = hzToBark(fMax);

        // 2. 在巴克刻度上进行线性（均匀）分割
        double barkStep = (barkMax - barkMin) / mBarCount;

        // 3. 将巴克刻度边界转换回频率(Hz)边界
        float[] freqBoundaries = new float[mBarCount + 1];
        for (int i = 0; i <= mBarCount; i++) {
            // 对于hzToBark(20)返回的负值，我们进行修正，确保频率从fMin开始
            double currentBark = barkMin + i * barkStep;
            if (currentBark < 0) currentBark = 0; // 避免bark为负导致转换结果异常
            freqBoundaries[i] = (float) barkToHz(currentBark);
        }
        // 确保边界严格从fMin开始，到fMax结束
        freqBoundaries[0] = fMin;
        freqBoundaries[mBarCount] = fMax;


        // 计算每个FFT频率点代表的频率宽度 (Hz)
        float hzPerFftBin = (float) AUDIO_SAMPLE_RATE / (mFftData.length);

        // **第二步：将FFT数据分配到频率组，并计算能量**

        float[] groupedMagnitudes = new float[mBarCount];
        int[] groupCounts = new int[mBarCount]; // 用于计算平均值

        // 遍历所有FFT频率点
        for (int i = 0; i < totalFrequencyCount; i++) {
            // 计算当前FFT索引 `i` 对应的实际频率值 (Hz)
            float currentFreq = i * hzPerFftBin;

            // 寻找这个频率 `currentFreq` 属于哪个分组 `j`
            for (int j = 0; j < mBarCount; j++) {
                // 如果当前频率落在第 j 个分组的区间 [freqBoundaries[j], freqBoundaries[j+1]) 内
                if (currentFreq >= freqBoundaries[j] && currentFreq < freqBoundaries[j + 1]) {
                    // 计算该频率点的能量幅值
                    int index = i * 2;
                    float real = mFftData[index];
                    float imag = mFftData[index + 1];
                    float magnitude = (float) Math.sqrt(real * real + imag * imag);

                    // 将能量累加到对应的分组
                    groupedMagnitudes[j] += magnitude;
                    groupCounts[j]++;
                    break; // 找到分组后即可跳出内层循环
                }
            }
        }

        // 计算每个分组的平均能量，并找到所有分组中的最大值
        float maxGroupedMagnitude = 0f;
        for (int i = 0; i < mBarCount; i++) {
            if (groupCounts[i] > 0) {
                groupedMagnitudes[i] /= groupCounts[i];
            }
            if (groupedMagnitudes[i] > maxGroupedMagnitude) {
                maxGroupedMagnitude = groupedMagnitudes[i];
            }
        }

        // 防止除以零
        if (maxGroupedMagnitude == 0) {
            return;
        }

        // **第三步：将计算出的能量值转换为分贝并绘制柱状图**

        float barWidth = (float) getWidth() / mBarCount;

        for (int i = 0; i < mBarCount; i++) {
            float magnitude = groupedMagnitudes[i];

            // 计算相对dB值
            float ratioVal = (magnitude > 0) ? (magnitude / maxGroupedMagnitude) : 0f;
            float dbValue = (ratioVal > 0) ? (float) (20 * Math.log10(ratioVal)) : MIN_RELATIVE_DB_VALUE;

            // 归一化dB值并映射到视图高度
            float normalizedHeight = (dbValue - MIN_RELATIVE_DB_VALUE) / -MIN_RELATIVE_DB_VALUE;
            normalizedHeight = Math.max(0f, Math.min(1f, normalizedHeight)); // 裁剪到 [0, 1] 区间

            float barHeight = normalizedHeight * getHeight();

            // 计算当前柱子的坐标并绘制
            float left = i * barWidth;
            float top = getHeight() - barHeight;
            float right = left + barWidth;
            float bottom = getHeight();

            canvas.drawRect(left, top, right, bottom, mFftPaint);
        }
    }



    /**
     * 将频率(Hz)转换为梅尔刻度。
     * @param hz 频率值，单位 Hz
     * @return 对应的梅尔刻度值
     */
    private double hzToMel(double hz) {
        return 2595 * Math.log10(1 + hz / 700);
    }

    /**
     * 将梅尔刻度转换回频率(Hz)。
     * @param mel 梅尔刻度值
     * @return 对应的频率值，单位 Hz
     */
    private double melToHz(double mel) {
        return 700 * (Math.pow(10, mel / 2595) - 1);
    }

    /**
     * 基于梅尔刻度（Mel Scale）的可视化方案。
     * 梅尔刻度是一种更精确模拟人耳听觉感知的非线性频率标度。
     * 1. 设定一个固定的频率范围 [fmin, fmax]。
     * 2. 将此频率范围的两端转换为梅尔刻度 [melMin, melMax]。
     * 3. 在梅尔刻度上进行线性（均匀）分割，得到每个柱子的梅尔刻度边界。
     * 4. 将这些梅尔刻度边界再转换回频率（Hz）边界。
     * 5. 将FFT数据按计算出的频率边界进行分组、求平均能量，并绘制。
     */
    protected void onDrawBarGroupMel(Canvas canvas) {
        // 先清空画布
        canvas.drawColor(0xFF111111);

        // 检查原始FFT数据是否存在
        if (mFftData == null) {
            return;
        }

        // totalFrequencyCount 是FFT分析出的总频率点数
        int totalFrequencyCount = mFftData.length / 2;
        if (totalFrequencyCount == 0 || mBarCount == 0) {
            return;
        }

        // **第一步：基于梅尔刻度，定义频率边界 (Hz)**

        // 设定我们感兴趣的频率范围
        float fMin = 20f;  // 频率下限 (Hz)
        // 奈奎斯特-香农采样定理的核心思想是：
        // 为了能够从数字信号中无失真地恢复原始模拟信号，采样率必须大于原始信号中最高频率的两倍。
        float fMax = Math.min(20000f, (float) AUDIO_SAMPLE_RATE / 2.0f); // 频率上限 (Hz)

        // 1. 将频率范围的端点转换为梅尔刻度
        double melMin = hzToMel(fMin);
        double melMax = hzToMel(fMax);

        // 2. 在梅尔刻度上进行线性（均匀）分割
        double melStep = (melMax - melMin) / mBarCount;

        // 3. 将梅尔刻度边界转换回频率(Hz)边界
        float[] freqBoundaries = new float[mBarCount + 1];
        for (int i = 0; i <= mBarCount; i++) {
            freqBoundaries[i] = (float) melToHz(melMin + i * melStep);
        }

        // 计算每个FFT频率点代表的频率宽度 (Hz)
        float hzPerFftBin = (float) AUDIO_SAMPLE_RATE / (mFftData.length);

        // **第二步：将FFT数据分配到频率组，并计算能量**

        float[] groupedMagnitudes = new float[mBarCount];
        int[] groupCounts = new int[mBarCount]; // 用于计算平均值

        // 遍历所有FFT频率点
        for (int i = 0; i < totalFrequencyCount; i++) {
            // 计算当前FFT索引 `i` 对应的实际频率值 (Hz)
            float currentFreq = i * hzPerFftBin;

            // 寻找这个频率 `currentFreq` 属于哪个分组 `j`
            for (int j = 0; j < mBarCount; j++) {
                // 如果当前频率落在第 j 个分组的区间 [freqBoundaries[j], freqBoundaries[j+1]) 内
                if (currentFreq >= freqBoundaries[j] && currentFreq < freqBoundaries[j + 1]) {
                    // 计算该频率点的能量幅值
                    int index = i * 2;
                    float real = mFftData[index];
                    float imag = mFftData[index + 1];
                    float magnitude = (float) Math.sqrt(real * real + imag * imag);

                    // 将能量累加到对应的分组
                    groupedMagnitudes[j] += magnitude;
                    groupCounts[j]++;
                    break; // 找到分组后即可跳出内层循环
                }
            }
        }

        // 计算每个分组的平均能量，并找到所有分组中的最大值
        float maxGroupedMagnitude = 0f;
        for (int i = 0; i < mBarCount; i++) {
            if (groupCounts[i] > 0) {
                groupedMagnitudes[i] /= groupCounts[i];
            }
            if (groupedMagnitudes[i] > maxGroupedMagnitude) {
                maxGroupedMagnitude = groupedMagnitudes[i];
            }
        }

        // 防止除以零
        if (maxGroupedMagnitude == 0) {
            return;
        }

        // **第三步：将计算出的能量值转换为分贝并绘制柱状图**

        float barWidth = (float) getWidth() / mBarCount;

        for (int i = 0; i < mBarCount; i++) {
            float magnitude = groupedMagnitudes[i];

            // 计算相对dB值
            float ratioVal = (magnitude > 0) ? (magnitude / maxGroupedMagnitude) : 0f;
            float dbValue = (ratioVal > 0) ? (float) (20 * Math.log10(ratioVal)) : MIN_RELATIVE_DB_VALUE;

            // 归一化dB值并映射到视图高度
            float normalizedHeight = (dbValue - MIN_RELATIVE_DB_VALUE) / -MIN_RELATIVE_DB_VALUE;
            normalizedHeight = Math.max(0f, Math.min(1f, normalizedHeight)); // 裁剪到 [0, 1] 区间

            float barHeight = normalizedHeight * getHeight();

            // 计算当前柱子的坐标并绘制
            float left = i * barWidth;
            float top = getHeight() - barHeight;
            float right = left + barWidth;
            float bottom = getHeight();

            canvas.drawRect(left, top, right, bottom, mFftPaint);
        }
    }



    // 在类的顶部添加一个常量，用于表示相对dB的最小范围
    // 这个值定义了最弱的信号（相对于最强信号）能显示到多低
    private static final float MIN_RELATIVE_DB_VALUE = -60f;

    // private static final float MIN_RELATIVE_DB_VALUE = -60f;
    private static final int AUDIO_SAMPLE_RATE = 44100; // 标准CD音质采样率，需要根据实际情况调整

    /**
     * 基于对数频率分度（等比数列）的可视化方案。
     * 利用指数增长快的特性扩宽高频带宽
     * 1. 设定一个固定的、符合人耳感知的频率范围 [fmin, fmax]。
     * 2. 在此频率范围上，使用等比数列计算出每个柱状图的频率边界。
     *    公式: R = (fmax / fmin)^(1 / B), b(i) = fmin * R^i
     *    这使得每个柱子的频率带宽随频率的升高而指数级增宽，符合听觉模型。
     * 3. 将FFT数据按计算出的频率边界进行分组、求平均能量，并绘制。
     */
    protected void onDrawBarGroup2(Canvas canvas) {
        // 先清空画布
        canvas.drawColor(0xFF111111);

        // 检查原始FFT数据是否存在
        if (mFftData == null) {
            return;
        }

        // totalFrequencyCount 是FFT分析出的总频率点数
        int totalFrequencyCount = mFftData.length / 2;
        if (totalFrequencyCount == 0 || mBarCount == 0) {
            return;
        }

        // **第一步：基于等比数列，定义频率边界 (Hz)**

        // 设定我们感兴趣的频率范围
        float fMin = 20f;  // 频率下限 (Hz)，人耳听觉下限
        // 频率上限 (Hz)，应小于采样率的一半（奈奎斯特频率）
        float fMax = Math.min(20000f, (float) AUDIO_SAMPLE_RATE / 2.0f);

        // 计算等比数列的公比 R。我们需要将 [fMin, fMax] 区间划分成 mBarCount 个子区间。
        // 公式：f_i = fMin * R^i，当 i = mBarCount 时，f_mBarCount = fMax
        // 所以 fMax = fMin * R^mBarCount  =>  R = (fMax / fMin)^(1 / mBarCount)
        double ratio = Math.pow((double) fMax / fMin, 1.0 / mBarCount);

        // 创建一个数组来存储每个柱状图（分组）的频率边界 (Hz)
        float[] freqBoundaries = new float[mBarCount + 1];
        freqBoundaries[0] = fMin;
        for (int i = 1; i <= mBarCount; i++) {
            // 通过公比计算下一个边界
            freqBoundaries[i] = (float) (freqBoundaries[i - 1] * ratio);
        }
        // 确保最后一个边界精确为 fMax
        freqBoundaries[mBarCount] = fMax;

        // 计算每个FFT频率点代表的频率宽度 (Hz)
        // 例如：采样率44100Hz，FFT大小1024，则频率点数512，频率分辨率为 44100 / 1024 ≈ 43Hz/点
        float hzPerFftBin = (float) AUDIO_SAMPLE_RATE / (mFftData.length);

        // **第二步：将FFT数据分配到频率组，并计算能量**

        float[] groupedMagnitudes = new float[mBarCount];
        int[] groupCounts = new int[mBarCount]; // 用于计算平均值

        // 遍历所有FFT频率点
        for (int i = 0; i < totalFrequencyCount; i++) {
            // 计算当前FFT索引 `i` 对应的实际频率值 (Hz)
            float currentFreq = i * hzPerFftBin;

            // 寻找这个频率 `currentFreq` 属于哪个分组 `j`
            for (int j = 0; j < mBarCount; j++) {
                // 如果当前频率落在第 j 个分组的区间 [freqBoundaries[j], freqBoundaries[j+1]) 内
                if (currentFreq >= freqBoundaries[j] && currentFreq < freqBoundaries[j + 1]) {
                    // 计算该频率点的能量幅值
                    int index = i * 2;
                    float real = mFftData[index];
                    float imag = mFftData[index + 1];
                    float magnitude = (float) Math.sqrt(real * real + imag * imag);

                    // 将能量累加到对应的分组
                    groupedMagnitudes[j] += magnitude;
                    groupCounts[j]++;
                    break; // 找到分组后即可跳出内层循环
                }
            }
        }

        // 计算每个分组的平均能量，并找到所有分组中的最大值
        float maxGroupedMagnitude = 0f;
        for (int i = 0; i < mBarCount; i++) {
            if (groupCounts[i] > 0) {
                groupedMagnitudes[i] /= groupCounts[i];
            }
            if (groupedMagnitudes[i] > maxGroupedMagnitude) {
                maxGroupedMagnitude = groupedMagnitudes[i];
            }
        }

        // 防止除以零
        if (maxGroupedMagnitude == 0) {
            return;
        }

        // **第三步：将计算出的能量值转换为分贝并绘制柱状图**

        float barWidth = (float) getWidth() / mBarCount;

        for (int i = 0; i < mBarCount; i++) {
            float magnitude = groupedMagnitudes[i];

            // 计算相对dB值
            float ratioVal = (magnitude > 0) ? (magnitude / maxGroupedMagnitude) : 0f;
            float dbValue = (ratioVal > 0) ? (float) (20 * Math.log10(ratioVal)) : MIN_RELATIVE_DB_VALUE;

            // 归一化dB值并映射到视图高度
            float normalizedHeight = (dbValue - MIN_RELATIVE_DB_VALUE) / -MIN_RELATIVE_DB_VALUE;
            normalizedHeight = Math.max(0f, Math.min(1f, normalizedHeight)); // 裁剪到 [0, 1] 区间

            float barHeight = normalizedHeight * getHeight();

            // 计算当前柱子的坐标并绘制
            float left = i * barWidth;
            float top = getHeight() - barHeight;
            float right = left + barWidth;
            float bottom = getHeight();

            canvas.drawRect(left, top, right, bottom, mFftPaint);
        }
    }





    //// 基于索引的对数映射分组（注意是非线性分组）
    //// 直接使用对数函数的变化趋势直接达到扩宽高频的分组范围
    //// 比如，当 i 从 1 增加到 2 时，log(i)变化很快。
    //// 当 i 从 9 增加到 10 时，log(i) 变化很慢。
    /// 最终导致分配给低频频带（小的 i）的 FFT 原始索引数量较少，而分配给高频频带（大的 i）的 FFT 原始索引数量较多。
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
            // 当 i 范围取值 = (0, n] 时候，分组刚好占满 fft 数组
            // 可以理解为计算区间的百分比 log(i) / log(max) * 100%，注意区间范围是 (0, log(i)]
            // Math.log(i) / Math.log(mBarCount) 正是在计算一个非线性的、符合对数规律的百分比
            // 百分比计算出来后直接乘以 fft数组长度 n 就可以得出“前面的区间一共拿走了多少份”
            // 百分比 * n 的结果 logIndex，就是第 i 个柱子所代表的频率区间的右边界在FFT数组中的索引位置。
            // 所以 groupBoundaries[i] 记录有两个含义，
            // 1， fft 数组索引最大值
            // 第 j 个分组的频率点索引范围是 [groupBoundaries[j], groupBoundaries[j+1])
            // 2. 前面n个区间拿走了多少份 fft数据
            // 它代表了从第 0 个频率点开始，一直到第 i 个分组结束，总共覆盖了多少个FFT频率点
            // 分组算法总结：
            // 1. 创建对数比例：通过 log(i) / log(mBarCount) 建立一个模拟听觉感知的非线性百分比模型。
            // 2. 映射到实际数据：将这个百分比乘以FFT数据的总长度，从而计算出每个柱状图分组的边界。
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
            // 当声音强度（magnitude）为0时，ratio (magnitude / maxMagnitude) 也为0。
            // 在数学上，log10(0) 的结果是负无穷大 (-∞)。如果直接使用这个结果来计算柱子的高度，程序会出错或者得到一个无意义的、无限低的柱子。
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
