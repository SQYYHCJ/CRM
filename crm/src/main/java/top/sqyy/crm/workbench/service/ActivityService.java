package top.sqyy.crm.workbench.service;

import top.sqyy.crm.vo.PaginationVO;
import top.sqyy.crm.workbench.domain.Activity;
import top.sqyy.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @Classname ActivityService
 * @Created by HCJ
 * @Date 2021/6/4 23:11
 */
public interface ActivityService {
    boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);
}
