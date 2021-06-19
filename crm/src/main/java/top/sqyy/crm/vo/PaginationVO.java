package top.sqyy.crm.vo;

import java.util.List;

/**
 * @Classname PaginationVO
 * @Created by HCJ
 * @Date 2021/6/16 14:04
 */
public class PaginationVO<T> {
    private int total;
    private List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
