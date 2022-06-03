<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="MaterialManagement.mainscreen" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <link href="Content/w3full.css" rel="stylesheet" />--%>
    <style>
        .dvImg {
            /*width:150px;*/
            height: 180px;
            float: left;
            margin-left: 20px;
            /*border:1px solid blue;*/
        }
        .hinh {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            width: 162px;
            height: 180px;
        }
        /*img {
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 5px;
    width: 162px;
}*/
        img:hover {
            box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
            cursor: pointer;
        }
        #dvT:hover {
         box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
            cursor: pointer;
        }
        #dvchart:hover {
         box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
         cursor: pointer;
        }
    </style>
    <script src="Scripts/Include/mainscreen.js"></script>
    <div style="margin-top: 10px;"></div>
    <div class="table-responsive">
    <div style="margin-top: 50px; width: 1120px; margin: 0 auto; border: 4px solid #8f0909; height: 690px">
        <div id="dvT" style="margin-top: 5px; margin-left: 20px; text-align: center; background-color: RGB(89,89,89); width: 300px; font-weight: bold; color: #15a19d; border: 2px solid #13a8bd;float:left">
            T<br />
            ELECTRIC SPARE PART ROOM
        </div>
        <div id="dvchart" style="margin-top: 5px;height:45px; margin-left: 20px; text-align: center; background-color: RGB(89,89,89); width: 300px; font-weight: bold; color: #15a19d; border: 2px solid #13a8bd;float:left"><br />Inventory Cost Chart</div>
       <div style="clear:both"></div>
         <div style="width: 1120px; margin-top: 10px; height: 200px">
            <div id="A" class="dvImg">
                <img src="images/A.jpg" class="hinh" /></div>
            <div id="B" class="dvImg">
                <img src="images/B.jpg" class="hinh" /></div>
            <div id="C" class="dvImg">
                <img src="images/C.jpg" class="hinh" /></div>
            <div id="D" class="dvImg">
                <img src="images/D.jpg" class="hinh" /></div>
            <div id="E" class="dvImg">
                <img src="images/E.jpg" class="hinh" /></div>
            <div id="F" class="dvImg">
             <img src="images/F.jpg" class="hinh" /></div>
        </div>
        <div style="clear: both; width: 1120px; margin-top: 10px; height: 200px">
            <div id="G" class="dvImg">
                <img src="images/G.jpg" class="hinh" /></div>
            <div id="H" class="dvImg">
                <img src="images/H.jpg" class="hinh" /></div>
            <div id="I" class="dvImg">
                <img src="images/I.jpg" class="hinh" /></div>
            <div id="K" class="dvImg">
                <img src="images/K.jpg" class="hinh" /></div>
            <div id="L" class="dvImg">
                <img src="images/L.jpg" class="hinh" /></div>
            <div id="O" class="dvImg">
                <img src="images/O.jpg" class="hinh" /></div>
        </div>
        <div style="clear: both; width: 1120px; margin-top: 10px; height: 200px">
            <div id="J" class="dvImg">
                <img src="images/J.jpg" class="hinh" /></div>
            <div id="P" class="dvImg">
                <img src="images/P.jpg" class="hinh" /></div>
            <div id="Q" class="dvImg">
                <img src="images/Q.jpg" class="hinh" /></div>
            <div id="R" class="dvImg">
                <img src="images/R.jpg" class="hinh" /></div>
            <div id="V" class="dvImg">
                <img src="images/V.jpg" class="hinh" /></div>
            <div id="U" class="dvImg">
                <img src="images/U.jpg" class="hinh" /></div>
        </div>
    </div>
        </div>
    <div style="margin-top: 10px"></div>
</asp:Content>
