package top.sqyy.crm.web.filter;

import top.sqyy.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @Classname ${NAME}
 * @Created by HCJ
 * @Date 2021/6/4 22:03
 */
public class LoginFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        String path = request.getServletPath();
        User user = (User) request.getSession().getAttribute("user");
        if ("/login.jsp".equals(path)||"/settings/user/login.do".equals(path)){
            chain.doFilter(req,resp);
        }else {
            if (user!=null){
                chain.doFilter(req, resp);
            }else {
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }

    }

    public void init(FilterConfig config) throws ServletException {

    }

}
