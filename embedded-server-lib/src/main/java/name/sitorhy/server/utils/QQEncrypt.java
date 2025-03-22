package name.sitorhy.server.utils;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Random;

class Md5Encrypt {
    //必须要重视编码问题了！折腾了好多天才发现MD5要用UTF-8形式加密
    public static String convertToMd5(String plainText) {
        byte[] secretBytes = null;
        try {
            secretBytes = MessageDigest.getInstance("md5").digest(plainText.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            throw new RuntimeException("没有这个md5算法！");
        }
        StringBuilder md5code = new StringBuilder(new BigInteger(1, secretBytes).toString(16));
        for (int i = 0; i < 32 - md5code.length(); i++) {
            md5code.insert(0, "0");
        }
        return md5code.toString();
    }
}

/**
 * 引用: <a href="https://blog.csdn.net/qq_23594799/article/details/111477320">加密参数分析</a> <br>
 * <b>https://u.y.qq.com/cgi-bin/musicu.fcg</b> 支持加密和非加密 <br>
 * <b>https://u.y.qq.com/cgi-bin/musics.fcg</b> 仅支持加密 <br>
 */
public class QQEncrypt {
    private static final String encNonce = "CJBPACrRuNy7";
    private static final String signPrxfix = "zza";
    private static final char[] dir = "0234567890abcdefghijklmnopqrstuvwxyz".toCharArray();

    /**
     * @param encParams 需要加密的参数，这是一段请求体数据，为json字符串格式，例如下面的格式，可以抓包获取
     *                  {"comm":{"ct":24,"cv":0},"vip":{"module":"userInfo…baseinfo_v2","param":{"vec_uin":["3011429848"]}}}
     * @return 加密的方式为固定字串 zza加上一个10-16位的随机字符串再加上 固定字串 CJBPACrRuNy7加上请求数据拼接的 MD5值
     */
    public static String getSign(String encParams) {
        return signPrxfix + uuidGenerate() + Md5Encrypt.convertToMd5(encNonce + encParams);
    }

    private static String uuidGenerate() {
        int minLen = 10;
        int maxLen = 16;
        Random ran = new Random(System.currentTimeMillis());
        int ranLen = ran.nextInt(maxLen - minLen) + minLen;
        StringBuilder sb = new StringBuilder(ranLen);
        for (int i = 0; i < ranLen; i++) {
            sb.append(dir[ran.nextInt(dir.length)]);
        }
        return sb.toString();
    }
}

