package top.sqyy.crm.settings.web.controller;

import top.sqyy.crm.settings.domain.User;
import top.sqyy.crm.settings.service.UserService;
import top.sqyy.crm.settings.service.impl.UserServiceImpl;
import top.sqyy.crm.utils.MD5Util;
import top.sqyy.crm.utils.PrintJson;
import top.sqyy.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @Classname UserController
 * @Created by HCJ
 * @Date 2021/6/3 13:31
 */
public class UserController extends HttpServlet {

    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器");
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }
        if ("/settings/user/xxx.do".equals(path)){

        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到验证登陆操作");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        System.out.println("ip======" +ip);
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        try {
            User user = us.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
//          登陆成功
            PrintJson.printJsonFlag(response,true);

        } catch (Exception e) {
            e.printStackTrace();
//            抛出异常表示登陆失败
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);

            PrintJson.printJsonObj(response,map);

        }


    }
}
