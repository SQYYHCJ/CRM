package top.sqyy.crm.settings.dao;

import top.sqyy.crm.settings.domain.User;

import java.util.Map;

/**
 * @Classname UserDao
 * @Created by HCJ
 * @Date 2021/6/3 13:23
 */
public interface UserDao   {
    User login(Map<String, String> map);
}
