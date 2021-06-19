<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
		  rel="stylesheet"/>
	
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript"
			src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript"
			src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.css"></script>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" type="text/javascript">

        $(function () {
		//	为创建按钮绑定事件
			$("#addBtn").click(function () {
			    $(".time").datetimepicker({
					minView:"month",
					language:"zh-CN",
					format:'yyyy-mm-dd',
					autoclose:true,
					todayBtn:true,
					pickerPosition:"bottom-left"
				});
			//    从后台取出所有者信息，为所有请求获取信息
                $.ajax({
                    url:"workbench/activity/getUserList.do",
                    data:{},
                    type:"get",
                    dataType:"json",
                    success:function (data) {
						var html = "<option></option>";
						$.each(data,function (i,n) {
							html += "<option value = '"+n.id+"'>"+n.name+"</option>";
                        });
						$("#create-owner").html(html);
						//将当前用户设为默认
						$("#create-owner").val("${user.id}");
						alert($("#create-owner").val());

                        //	操作模态窗口的方法，需要操作的模态窗口的jquery对象，show为打开 hide为关闭
                        $("#createActivityModal").modal("show");
                        
                    }

                });
			
            });
		
		//保存添加事件操作
			$("#saveBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/save.do",
                    data:{
                        "owner" : $.trim($("#create-owner").val()),
                        "name" : $.trim($("#create-name").val()),
                        "startDate" : $.trim($("#create-startDate").val()),
                        "endDate" : $.trim($("#create-endDate").val()),
                        "cost" : $.trim($("#create-cost").val()),
						"description": $.trim($("#create-description").val())

                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
						if (data.success){
						//	添加成功后
						//	刷新市场活动列表
                            pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
						//	清空表单数据
						//	注意表单的submit方法可以提交，没有reset方法重置表单
						$("#activityAdd")[0].reset();
						//	关闭添加操作的模态窗口
                            $("#createActivityModal").modal("hide");
						}else {
						    alert("添加市场活动失败");
						}
                    }

                })
            });
		//	页面加载完毕后加载触发方法，默认展示列表的第一页，展示两个句句
			pageList(1,2);
		//	为查询按钮绑定事件
			$("#search-button").click(function () {
			    //将搜索的信息保存到隐藏域中
				$("#hidden-name").val($.trim($("#search-name").val()));
				$("#hidden-owner").val($.trim($("#search-owner").val()));
				$("#hidden-startDate").val($.trim($("#search-startDate").val()));
				$("#hidden-endDate").val($.trim($("#search-endDate").val()));
				pageList(1,2)
            });
		//	为全选按钮绑定
			$("#selectAll").click(function () {
				$("input[name=seletItem]").prop("checked",this.checked)
            });
		//	动态生成的元素以on方法的形式来触发事件
			/*
			有效的外层元素 on事件（绑定的事件，需要绑定的对象，回调函数）
			*/
			$("#activityBody").on("click",$("input[name=seletItem]"),function () {
                $("#selectAll").prop("checked",$("input[name=seletItem]").length==$("input[name=seletItem]:checked").length);
            });
		//	为删除按钮绑定事件
			$("#deleteBtn").click(function () {
				var $selectItem = $("input[name=seletItem]:checked");
				if ($selectItem.length==0){
				    alert("请选择需要删除的元素");
				}else {
				    if (confirm("确定删除所选中的记录吗？")) {
                        //拼接参数
                        var param="";
                        //	遍历取值
                        for (var i = 0; i <$selectItem.length ; i++) {
                            param += "id="+ $selectItem[i].value;
                            if (i!=$selectItem.length-1){
                                param +="&";
                            }
                            
                        }
                        $.ajax({
                            url:"workbench/activity/delete.do",
                            data:param,
                            type:"post",
                            dataType:"json",
                            success:function (data) {
                                if (data.success){
                                    $("#activityPage").bs_pagination('getOption','rowsPerPage');
                                }else {
                                    alert("删除信息失败")
                                }
                            }

                        });
                    }
			
				}
            
            });
		//	为修改按钮绑定事件，打开修改操作的模态窗口
			$("#editBtn").click(function () {
				var $selectItem =$("input[name=seletItem]:checked");
				if ($selectItem.length === 0){
				    alert("请选择需要修改的记录");
				}else if($selectItem.length>1){
				    alert("只能选择一条记录");
				}else {
				    var id = $selectItem.val();
                    $.ajax({
                        url:"workbench/activity/getInfo.do",
                        data:{
                            "id":id
						},
                        type:"get",
                        dataType:"json",
                        success:function (data) {
						//	用户列表
						//	市场活动对象
							var html = "<option></option>";
							$.each(data.userList,function (i,n) {
                                html += "<option value = '"+n.id+"'>"+n.name+"</option>";
                            });
							$("#edit-owner").html(html);
							$("#edit-owner").val(data.a.owner);
						//	处理单挑activity
							$("#edit-id").val(data.a.id);
							$("#edit-name").val(data.a.name);
							$("#edit-startDate").val(data.a.startDate);
							$("#edit-endDate").val(data.a.endDate);
							$("#edit-description").val(data.a.description);
							$("#edit-owner").val(data.a.description);
							$("#edit-cost").val(data.a.cost);
						//	所有值添加好之后可以打开添加窗口
							$("#editActivityModal").modal("show");
							
							
                        }

                    })
				}
            });
		//	为更新按钮绑定操作
			$("#updateBtn").click(
			    function () {
                    $.ajax({
                        url:"workbench/activity/update.do",
                        data:{
                            "id" : $.trim($("#edit-id").val()),
                            "owner" : $.trim($("#edit-owner").val()),
                            "name" : $.trim($("#edit-name").val()),
                            "startDate" : $.trim($("#edit-startDate").val()),
                            "endDate" : $.trim($("#edit-endDate").val()),
                            "cost" : $.trim($("#edit-cost").val()),
                            "description": $.trim($("#edit-description").val())

                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if (data.success){
                                //	修改成功后
                                //	刷新市场活动列表
                                pageList($("#activityPage").bs_pagination('getOption','currentPage'),$("#activityPage").bs_pagination('getOption','rowsPerPage'));
                                //	清空表单数据
                                //	注意表单的submit方法可以提交，没有reset方法重置表单
                                // $("#activityAdd")[0].reset();
                                //	关闭修改操作的模态窗口
                                $("#editActivityModal").modal("hide");
                            }else {
                                alert("修改市场活动失败");
                            }
                        }

                    })
                }
			)
			
			
			
			
			
			
			
			
			
			
			
        });
        function pageList(pageNo,pageSize) {
        //    将全选的复选框去掉
			$("#selectAll").prop("checked",false);
        //    查询前从隐藏信息中读取查询信息
		//	重新赋值
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));
		//	传入页码和每页的记录数
			/* 在什么情况下需要刷新市场活动列表
			* 点击左边菜单栏中的市场活动超链接
			* 添加，修改，删除的操作结束后刷新
			* 点击查询按钮的时候
			* 点击页码和上一页下一页的时候*/
            $.ajax({
                url:"workbench/activity/pageList.do",
                data:{
                    "pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#search-name").val()),
                    "owner":$.trim($("#search-owner").val()),
                    "startDate":$.trim($("#search-startDate").val()),
                    "endDate":$.trim($("#search-endDate").val())
					
				},
                type:"get",
                dataType:"json",
                success:function (data) {
				//	市场活动信息列表
				//	总记录条数
					var html = "";
					$.each(data.dataList,function (i,n) {
                    html += '<tr class="active">';
                    html += '<td><input type="checkbox" name="seletItem" value="'+n.id+'"/></td>';
                    html += '<td><a style="text-decoration: none; cursor: pointer;"';
                    html += 'onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
                    html += '<td>'+n.owner+'</td>';
                    html += '<td>'+n.startDate+'</td>';
                    html += '<td>'+n.endDate+'</td>';
                    html += '</tr>';
                    });
					$("#activityBody").html(html);
				//	处理完毕后，结合分页插件使用分页
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        onChangePage : function(event, data){
                            pageList(data.currentPage , data.rowsPerPage);
                        }
                    });


                }

            })
        }
	
	</script>
</head>
<body>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">
<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
			</div>
			<div class="modal-body">
				
				<form class="form-horizontal" role="form">
					
					<div class="form-group">
						<input type="hidden" id="edit-id">
						<label for="edit-owner" class="col-sm-2 control-label">所有者<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-owner">
							
							</select>
						</div>
						<label for="edit-name" class="col-sm-2 control-label">名称<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-name">
						</div>
					</div>
					
					<div class="form-group">
						<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-startDate">
						</div>
						<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-endDate">
						</div>
					</div>
					
					<div class="form-group">
						<label for="edit-cost" class="col-sm-2 control-label">成本</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-cost">
						</div>
					</div>
					
					<div class="form-group">
						<label for="edit-description" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-description"></textarea>
						</div>
					</div>
				
				</form>
			
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			</div>
		</div>
	</div>
</div>


<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
			</div>
			<div class="modal-body">
				
				<form id="activityAdd" class="form-horizontal" role="form">
					
					<div class="form-group">
						<label for="create-owner" class="col-sm-2 control-label">所有者<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-owner">
							
							</select>
						</div>
						<label for="create-name" class="col-sm-2 control-label">名称<span
								style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-name">
						</div>
					</div>
					
					<div class="form-group">
						<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="create-startDate" readonly>
						</div>
						<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="create-endDate" readonly>
						</div>
					</div>
					<div class="form-group">
						
						<label for="create-cost" class="col-sm-2 control-label">成本</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-cost">
						</div>
					</div>
					<div class="form-group">
						<label for="create-description" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="create-description"></textarea>
						</div>
					</div>
				
				</form>
			
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			</div>
		</div>
	</div>
</div>



<div>
	<div style="position: relative; left: 10px; top: -10px;">
		<div class="page-header">
			<h3>市场活动列表</h3>
		</div>
	</div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
		<div class="btn-toolbar" role="toolbar" style="height: 80px;">
			<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">名称</div>
						<input class="form-control" type="text" id="search-name">
					</div>
				</div>
				
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">所有者</div>
						<input class="form-control" type="text" id="search-owner">
					</div>
				</div>
				
				
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">开始日期</div>
						<input class="form-control" type="text" id="search-startDate"/>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">结束日期</div>
						<input class="form-control" type="text" id="search-endDate">
					</div>
				</div>
				
				<button type="button" class="btn btn-default" id="search-button">查询</button>
			
			</form>
		</div>
		<div class="btn-toolbar" role="toolbar"
			 style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
			<div class="btn-group" style="position: relative; top: 18%;">
				<button type="button" class="btn btn-primary" id="addBtn">
					<span class="glyphicon glyphicon-plus"></span> 创建
				</button>
				<button type="button" class="btn btn-default" id="editBtn"><span
						class="glyphicon glyphicon-pencil"></span> 修改
				</button>
				<button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>
		
		</div>
		<div style="position: relative;top: 10px;">
			<table class="table table-hover">
				<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="selectAll"/></td>
					<td>名称</td>
					<td>所有者</td>
					<td>开始日期</td>
					<td>结束日期</td>
				</tr>
				</thead>
				<tbody id="activityBody">

				<%--<tr class="active">--%>
					<%--<td><input type="checkbox"/></td>--%>
					<%--<td><a style="text-decoration: none; cursor: pointer;"--%>
						   <%--onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>--%>
					<%--<td>zhangsan</td>--%>
					<%--<td>2020-10-10</td>--%>
					<%--<td>2020-10-20</td>--%>
				</tr>
				</tbody>
			</table>
		</div>
		
		<div style="height: 50px; position: relative;top: 30px;">
			<div id="activityPage"></div>
			<%--<div>--%>
				<%--<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
			<%--</div>--%>
			<%--<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
				<%--<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
				<%--<div class="btn-group">--%>
					<%--<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
						<%--10--%>
						<%--<span class="caret"></span>--%>
					<%--</button>--%>
					<%--<ul class="dropdown-menu" role="menu">--%>
						<%--<li><a href="#">20</a></li>--%>
						<%--<li><a href="#">30</a></li>--%>
					<%--</ul>--%>
				<%--</div>--%>
				<%--<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
			<%--</div>--%>
			<%--<div style="position: relative;top: -88px; left: 285px;">--%>
				<%--<nav>--%>
					<%--<ul class="pagination">--%>
						<%--<li class="disabled"><a href="#">首页</a></li>--%>
						<%--<li class="disabled"><a href="#">上一页</a></li>--%>
						<%--<li class="active"><a href="#">1</a></li>--%>
						<%--<li><a href="#">2</a></li>--%>
						<%--<li><a href="#">3</a></li>--%>
						<%--<li><a href="#">4</a></li>--%>
						<%--<li><a href="#">5</a></li>--%>
						<%--<li><a href="#">下一页</a></li>--%>
						<%--<li class="disabled"><a href="#">末页</a></li>--%>
					<%--</ul>--%>
				<%--</nav>--%>
			<%--</div>--%>
		</div>
	
	</div>

</div>
</body>
</html>