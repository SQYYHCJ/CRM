package top.sqyy.crm.workbench.service.impl;

import top.sqyy.crm.settings.dao.UserDao;
import top.sqyy.crm.settings.domain.User;
import top.sqyy.crm.utils.SqlSessionUtil;
import top.sqyy.crm.vo.PaginationVO;
import top.sqyy.crm.workbench.dao.ActivityDao;
import top.sqyy.crm.workbench.dao.ActivityRemarkDao;
import top.sqyy.crm.workbench.domain.Activity;
import top.sqyy.crm.workbench.domain.ActivityRemark;
import top.sqyy.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Classname ActivityServiceImpl
 * @Created by HCJ
 * @Date 2021/6/4 23:12
 */
public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public boolean save(Activity activity) {
        boolean flag = true;
        int count = activityDao.save(activity);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {
//        取得total
        int total = activityDao.getTotalByCondition(map);
//        取得dataList
        List<Activity> dataList = activityDao.getActivityListByCondition(map);
//        封装
        PaginationVO<Activity> vo = new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
//        返回
        return vo;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
//        查询需要删除的备注
        int countS = activityRemarkDao.getCountByAids(ids);

//        删除备注，返回收到影响的条数
        int countR = activityRemarkDao.deleteByAids(ids);
        if (countR!=countS){
            flag = false;
        }
        int count3 = activityDao.delete(ids);
        if (count3!=ids.length){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        Map<String,Object> map = new HashMap<String, Object>();
//        获取userList
        List<User> userList = userDao.getUserList();
//        获取a
        Activity a = activityDao.getActivityById(id);
//        打包
        map.put("userList",userList);
        map.put("a",a);
//        返回map
        return map;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag = true;
        int count = activityDao.update(activity);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemarkListByActivityId(String activityId) {
        List<ActivityRemark> activityRemarkList = activityRemarkDao.getRemarkListByActivityId(activityId);
        return activityRemarkList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityRemarkDao.deleteById(id);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
        boolean flag = true;
        int count = activityRemarkDao.saveRemark(activityRemark);
        if (count!=1){
            flag =false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {
        boolean flag = true;
        int count = activityRemarkDao.updateRemark(activityRemark);
        if (count!=1){
            flag =false;
        }
        return flag;
    }

}
