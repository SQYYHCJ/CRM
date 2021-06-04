<%--
  Created by IntelliJ IDEA.
  User: HCJ
  Date: 2021/6/3
  Time: 14:45
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<title>Title</title>
	<script>
        $.ajax({
            url:"",
            data:{},
            type:"",
            dataType:"json",
            success:function (data) {

            }

        })
	</script>
</head>
<body>

</body>
</html>