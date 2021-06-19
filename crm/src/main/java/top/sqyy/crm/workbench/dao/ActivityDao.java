package top.sqyy.crm.workbench.dao;

import top.sqyy.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @Classname ActivityDao
 * @Created by HCJ
 * @Date 2021/6/4 23:09
 */
public interface ActivityDao {
    int save(Activity activity);

    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int delete(String[] ids);

    Activity getActivityById(String id);

    int update(Activity activity);

    Activity detail(String id);
}
