import org.junit.Test;
import top.sqyy.crm.utils.DateTimeUtil;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @Classname Test1
 * @Created by HCJ
 * @Date 2021/6/3 14:26
 */
public class Test1 {


    @Test
    public static void main(String[] args) {
        String expireTime = "2021-10-10 10:10:10";
        Date date = new Date();
        String currentTime = DateTimeUtil.getSysTime();

        System.out.println(expireTime.compareTo(currentTime));

    }
}
