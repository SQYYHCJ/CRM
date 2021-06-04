package top.sqyy.crm.settings.service.impl;

import top.sqyy.crm.exception.LoginException;
import top.sqyy.crm.settings.dao.UserDao;
import top.sqyy.crm.settings.domain.User;
import top.sqyy.crm.settings.service.UserService;
import top.sqyy.crm.utils.DateTimeUtil;
import top.sqyy.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.Map;

/**
 * @Classname UserServiceImpl
 * @Created by HCJ
 * @Date 2021/6/4 16:02
 */
public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map = new HashMap<String,String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);
        if (user == null){
            throw new LoginException("账号密码错误");
        }
//        验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){

            throw new LoginException("账号已失效");
        }
//        判断锁定状态
        String lockState = user.getLockState();

        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定");
        }
//        判断ip
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("IP地址受限");
        }
        return user;
    }
}
