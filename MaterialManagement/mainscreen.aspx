<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="mainscreen.aspx.cs" Inherits="MaterialManagement.mainscreen" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .dvImg {
        /*width:150px;*/
        height:220px;
        float:left;
        margin-left:20px;
        border:1px solid blue;
        }
        .hinh {
        width:180px;
        height:220px
        }
    </style>
    <script src="Scripts/Include/mainscreen.js"></script>
    <div style="margin-top:10px"></div>
    <div style="margin-top:50px;width:1240px;margin:0 auto;border:4px solid #8f0909;height:610px">
    <div style="width:1240px;margin-top:50px;height:200px">
        <div id="A"  class="dvImg"><img src="images/A.jpg" class="hinh" /></div>
        <div id="B"  class="dvImg"><img src="images/B.jpg" class="hinh" /></div>
        <div id="C"  class="dvImg"><img src="images/C.jpg" class="hinh" /></div>
        <div id="D"  class="dvImg"><img src="images/D.jpg"  class="hinh"/></div>
        <div id="E"  class="dvImg"><img src="images/E.jpg" class="hinh"/></div>
        <div id="F"  class="dvImg"><img src="images/F.jpg" class="hinh"/></div>
    </div>
    <div style="clear:both;width:1240px;margin-top:80px;height:200px">
        <div id="G" class="dvImg"><img src="images/G.jpg" class="hinh"/></div>
        <div id="H" class="dvImg"><img src="images/H.jpg" class="hinh"/></div>
        <div id="I"  class="dvImg"><img src="images/I.jpg" class="hinh"/></div>
        <div id="K"  class="dvImg"><img src="images/K.jpg" class="hinh"/></div>
        <div id="L"  class="dvImg"><img src="images/L.jpg" class="hinh"/></div>
        <div id="O"  class="dvImg"><img src="images/O.jpg" class="hinh"/></div>
    </div>
        </div>
    <div style="margin-top:10px"></div>
</asp:Content>
