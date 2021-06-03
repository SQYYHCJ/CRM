package top.sqyy.crm.settings.web.controller;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

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
        if ("/settings/user/save.do".equals(path)){

        }
        if ("/settings/user/xxx.do".equals(path)){

        }
    }
}
