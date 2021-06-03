package top.sqyy.crm.settings.dao.impl;

import top.sqyy.crm.settings.dao.UserDao;
import top.sqyy.crm.utils.SqlSessionUtil;

/**
 * @Classname UserDaoImpl
 * @Created by HCJ
 * @Date 2021/6/3 13:26
 */
public class UserDaoImpl implements UserDao {
    private UserDao  userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
}
