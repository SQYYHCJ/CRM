package top.sqyy.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @Classname ${NAME}
 * @Created by HCJ
 * @Date 2021/6/4 21:07
 */
public class EncodingFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");
        chain.doFilter(req, resp);
    }

    public void init(FilterConfig config) throws ServletException {

    }

}
