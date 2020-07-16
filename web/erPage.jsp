<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page isErrorPage="true" %>
<%
    String message = pageContext.getException().getMessage();
    String exceptions = pageContext.getException().getClass().toString();
%>

<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="style.css"/>
    <title>Ошибочка вышла</title>
</head>
<body>
<h1>Ошибка!!!</h1>
<p>Тип ошибки: <%= exceptions%>
</p>
<p>Сообщение об ошибке: <%= message %>
</p>
<p> Нажмите <a href="index.jsp"> здесь, </a> чтобы вернуться назад</p>
</body>
</html>
