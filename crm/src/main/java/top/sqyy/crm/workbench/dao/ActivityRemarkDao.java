package top.sqyy.crm.workbench.dao;

import top.sqyy.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @Classname ActivityRemarkDao
 * @Created by HCJ
 * @Date 2021/6/14 17:27
 */
public interface ActivityRemarkDao {
    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    int deleteById(String id);

    int saveRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
