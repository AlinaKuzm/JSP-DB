<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    boolean clicked = false;
    Connection conn;
    Statement stmt;
    ResultSet rs = null;

    int id = 0;
    String name = " ";
    if (request.getParameter("number") != null && (!request.getParameter("number").equals("0") && !request.getParameter("number").equals(""))) {
        id = Integer.parseInt(request.getParameter("number"));
    }
    if (request.getParameter("name") != null && !request.getParameter("name").equals("")) {
        name = request.getParameter("name");
    }

    if (request.getParameter("information") != null && request.getParameter("information").equals("Вывести информацию о сотрудниках")) {
        clicked = true;
    }

    //Class.forName("com.oracle.jdbc.driver.OracleDriver");
    InitialContext initContext = null;
    Context envContext = null;
    try {
        initContext = new InitialContext();
        envContext = (Context) initContext.lookup("java:/comp/env");

    } catch (NamingException e) {
        e.printStackTrace();
    }
    DataSource ds = null;
    try {
        ds = (DataSource) envContext.lookup("jdbc/JSP2");
    } catch (NamingException e) {
        e.printStackTrace();
    }
    Connection con = ds.getConnection();
    //out.print("Соединение установлено");
%>


<html>
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="style1.css"/>
    <script>

        function searchById(form) {
            var n = document.forms["myForm"]["number"].value;
            if (isNaN(n) !== false) {
                alert("Введите число");
            }
            <%  if(id != 0){
            String queryId = "SELECT\n" +
                 "    emp.empno,\n" +
                 "    emp.ename,\n" +
                 "    emp.job,\n" +
                 "    coalesce(emp.mgr,0),\n" +
                 "    TO_CHAR(emp.hiredate,'DD-MON-YY','NLS_DATE_LANGUAGE = ENGLISH') AS HIREDATE,\n" +
                 "    emp.sal,\n" +
                 "    coalesce(emp.comm,0),\n" +
                 "    emp.deptno,\n" +
                 "    dept.dname,\n" +
                 "    dept.loc,\n" +
                 "    salgrade.grade\n" +
                 "FROM\n" +
                 "    emp, dept, salgrade\n" +
                 "WHERE\n" +
                 "    emp.empno = " + id +
                 " AND emp.deptno = dept.deptno " +
                 "AND (emp.sal >= salgrade.losal AND emp.sal <= salgrade.hisal)";


             stmt = con.createStatement();
             rs = stmt.executeQuery(queryId);}

         %>
        }

        function showAll() {
            <%
            if ( clicked ){
           String queryAll = "SELECT\n" +
                  "    emp.empno,\n" +
                  "    emp.ename,\n" +
                  "    emp.job,\n" +
                  "    coalesce(emp.mgr,0),\n" +
                  "    TO_CHAR(emp.hiredate,'DD-MON-YY','NLS_DATE_LANGUAGE = ENGLISH') AS HIREDATE,\n" +
                  "    emp.sal,\n" +
                  "    coalesce(emp.comm,0),\n" +
                  "    emp.deptno,\n" +
                  "    dept.dname,\n" +
                  "    dept.loc,\n" +
                  "    salgrade.grade\n" +
                  "FROM\n" +
                  "    emp, dept, salgrade\n" +
                  "WHERE\n" +
                  "emp.deptno = dept.deptno " +
                  "AND (emp.sal >= salgrade.losal AND emp.sal <= salgrade.hisal)";

              stmt = con.createStatement();
              rs = stmt.executeQuery(queryAll);}
          %>
        }

        function searchByName() {
            var tempName = document.forms["myForm"]["name"].value;
            var availableTags = [];
            <% if (!name.equals(" ")){
            String queryName = "SELECT\n" +
                   "    emp.empno,\n" +
                   "    emp.ename,\n" +
                   "    emp.job,\n" +
                   "    coalesce(emp.mgr,0),\n" +
                   "    TO_CHAR(emp.hiredate,'DD-MON-YY','NLS_DATE_LANGUAGE = ENGLISH') AS HIREDATE,\n" +
                   "    emp.sal,\n" +
                   "    coalesce(emp.comm,0),\n" +
                   "    emp.deptno,\n" +
                   "    dept.dname,\n" +
                   "    dept.loc,\n" +
                   "    salgrade.grade\n" +
                   "FROM\n" +
                   "    emp, dept, salgrade\n" +
                   "WHERE\n" +
                   "    emp.ename = \'"+ name +
                   "\' AND emp.deptno = dept.deptno " +
                   "AND (emp.sal >= salgrade.losal AND emp.sal <= salgrade.hisal)";

               stmt = con.createStatement();
               rs = stmt.executeQuery(queryName);}
           %>

        }

        $( function() {
            var availableTags = [
                <% String queryName2 = "SELECT\n" +
                    "    emp.ename,\n" +
                    "FROM\n" +
                   "    emp";
              stmt = con.createStatement();
              rs = stmt.executeQuery(queryName2);%>
            ];
            $( "#name" ).autocomplete({
                source: availableTags
            });
        } );
    </script>

</head>
<body>
<div class="info">
    <form name="myForm">
        <label for="number">Введите номер сотрудника:</label> <br>

        <input type="search" name="number" id="number" placeholder="XX">

        <input type="submit" name="send" value="Поиск" onclick="searchById()">

        <br>
        <label for="name">Введите имя сотрудника:</label><br>
        <input type="search" name="name" placeholder="Например, Иванов" id="name" onfocus="this.placeholder=''"
               onblur="this.placeholder='Например, Иванов'">

        <input type="submit" name="send" value="Поиск" onclick="searchByName()">
        <br>
        <p> </p>
        <br>
        <input type="submit" name="information" id="information" onclick="showAll()"
               value="Вывести информацию о сотрудниках">
    </form>
</div>
<ul class="elas"></ul>
<li>Lorem</li>
<li>AGGG</li>
<li>Mnpmnp</li>


<div class="table" id="table">
    <table>
        <caption>Сотрудники</caption>
        <tr>
            <th></th>
            <th>Номер</th>
            <th>Имя</th>
            <th>Должность</th>
            <th>Дата принятия на работу</th>
            <th>Департамент</th>
        </tr>
        <% if (rs != null) {
            while (rs.next()) {%>
        <tr>
            <td><input type="checkbox" value="a1"></td>
            <td><a href="URL"><%=rs.getInt(1)%>
            </a></td>
            <td><%=rs.getString(2)%>
            </td>
            <td><%=rs.getString(3)%>
            </td>
            <td><%=rs.getString(5)%>
            </td>
            <td><%=rs.getInt(8)%>
            </td>
        </tr>
        <%
                }
            }
        %>


    </table>
</div>

</body>

</html>

