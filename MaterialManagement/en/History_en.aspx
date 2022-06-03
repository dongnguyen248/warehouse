<%@ Page Title="" Language="C#" MasterPageFile="~/en/Site1.Master" AutoEventWireup="true" CodeBehind="History_en.aspx.cs" Inherits="MaterialManagement.en.History_en" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <link href="../Content/mystyle.css" rel="stylesheet" />
       
    <div class="row"></div>
    <div  id="tbDL" class="table-responsive">
    <table  id="tbContent" class="table table-striped table-bordered table-hover">
        <thead>
            <tr class="tbheader">
                <th>User</th>
                <th>Ip</th>
                <th>Operation</th>
                <th>Content</th>
                <th>Modify Date</th>
            </tr>
        </thead>
        <tbody>
            <%if (DTB.Rows.Count > 0)
              { %>
            <%for (int i = 0; i < DTB.Rows.Count; i++)
              {%>
              <tr>
                <td><%=DTB.Rows[i][0].ToString() %></td>
                <td><%=DTB.Rows[i][1].ToString() %></td>
                <td><%=DTB.Rows[i][2].ToString() %></td>
                <td><%=DTB.Rows[i][3].ToString() %></td>
                <td><%=DTB.Rows[i][4].ToString() %></td>
            </tr>
            <%}
              }else{ %>
            <tr><td colspan="5">Have no history</td></tr>
            <%} %>
        </tbody>
    </table>
    </div>
</asp:Content>
