package top.sqyy.crm.settings.service;

import top.sqyy.crm.exception.LoginException;
import top.sqyy.crm.settings.domain.User;

import java.util.List;

/**
 * @Classname UserService
 * @Created by HCJ
 * @Date 2021/6/4 16:01
 */
public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
