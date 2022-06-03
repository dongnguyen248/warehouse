<%@ Page Title="" Language="C#" MasterPageFile="~/en/Site1.Master" AutoEventWireup="true" CodeBehind="Costchart_en.aspx.cs" Inherits="MaterialManagement.en.Costchart_en" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../Scripts/Chart.js"></script>
    <script src="../Scripts/Chart.min.js"></script>
    <script src="../Scripts/excanvas.js"></script>
    <script src="../Scripts/html5.js"></script>
   <style>
       .dvt1 {
           float:left;width:113px;
           text-align:center;
           color:#764949;
           font-style:italic;
       }
        .dvt2 {
             float:left;width:113px;
             text-align:center;
             border-left:2px solid #8a2121;
             color:#764949;
             font-style:italic;
             height:30px;
       }
       .ctext {
           color:#3a9753;font-family:Garamond;
           margin-left:5px;
       }
   </style>
    <script>
        $(document).ready(function () {
            $('#imgHome').addClass("Addimg");
        });
    </script>
    <form id="Form1" runat="server">
     <div style="width:300px;margin-left:100px"><div style="width:80px;float:left;font-weight:bold;color:#0e32bb;margin-top:10px">Select Year</div>
         <div style="float:left;margin-left:5px"><asp:DropDownList ID="dropYear" runat="server" CssClass="form-control"><asp:ListItem>2017</asp:ListItem><asp:ListItem>2016</asp:ListItem></asp:DropDownList></div>
         <div style="float:left;margin-left:5px"><asp:LinkButton ID="lnkdrawing" runat="server" OnClick="lnkdrawing_Click" CssClass="btn btn-default" Text="Drawing"><span aria-hidden="true" class="glyphicon glyphicon-wrench"></span>Drawing</asp:LinkButton>
         </div>
     </div>
         <asp:HiddenField ID="hdname" runat="server" ClientIDMode="Static" />
         <asp:HiddenField ID="hdwgt" runat="server" ClientIDMode="Static" />
    </form>
    <div style="height:880px;">
      <div style="width:1400px;height:600px;">
         <canvas id="canvas1"></canvas>
     </div>
      <div id="dvtime" style="margin-left:32px;margin-top:110px;width:1400px; ">
            <div id="dvt1" class="dvt2"></div>
             <div id="dvt2" class="dvt2"></div>
             <div id="dvt3" class="dvt2"></div>
             <div id="dvt4" class="dvt2"></div>
             <div id="dvt5" class="dvt2"></div>
             <div id="dvt6" class="dvt2"></div>
             <div id="dvt7" class="dvt2"></div>
             <div id="dvt8" class="dvt2"></div>
             <div id="dvt9" class="dvt2"></div>
             <div id="dvt10" class="dvt2"></div>
             <div id="dvt11" class="dvt2"></div>
             <div id="Div1" class="dvt2" style="border-right:2px solid #8a2121;"></div>
        </div> 
        <div style="clear:both;height:1px"></div>
         <div id="Div2" style="margin-left:32px;margin-top:0px;width:1400px;">
            <div id="Div3" class="dvt1"><asp:Label ID="lbl01" runat="server" Text=""></asp:Label></div>
             <div id="Div4" class="dvt1"><asp:Label ID="lbl02" runat="server" Text=""></asp:Label></div>
             <div id="Div5" class="dvt1"><asp:Label ID="lbl03" runat="server" Text=""></asp:Label></div>
             <div id="Div6" class="dvt1"><asp:Label ID="lbl04" runat="server" Text=""></asp:Label></div>
             <div id="Div7" class="dvt1"><asp:Label ID="lbl05" runat="server" Text=""></asp:Label></div>
             <div id="Div8" class="dvt1"><asp:Label ID="lbl06" runat="server" Text=""></asp:Label></div>
             <div id="Div9" class="dvt1"><asp:Label ID="lbl07" runat="server" Text=""></asp:Label></div>
             <div id="Div10" class="dvt1"><asp:Label ID="lbl08" runat="server" Text=""></asp:Label></div>
             <div id="Div11" class="dvt1"><asp:Label ID="lbl09" runat="server" Text=""></asp:Label></div>
             <div id="Div12" class="dvt1"><asp:Label ID="lbl10" runat="server" Text=""></asp:Label></div>
             <div id="Div13" class="dvt1"><asp:Label ID="lbl11" runat="server" Text=""></asp:Label></div>
             <div id="Div14" class="dvt1"><asp:Label ID="lbl12" runat="server" Text=""></asp:Label></div>
        </div> 
 <div style="clear: left; width: 200px; height: 120px; border: 2px solid #5e1212; margin-left: 50px;margin-top:10px">
        <div style="width: 100px; margin: 0 auto; color: #eb2814;font-weight:bolder;margin-left:20px">
            <asp:Label ID="Label2" Text="Explaination" runat="server"></asp:Label>
        </div>
        <div class="ctext">
          A : Packing cost
        </div>
        <div class="ctext">
          B : Mainternain cost
        </div>
        <div class="ctext">
         C : Product cost
        </div>
        <div class="ctext">
         D : N2,NH3,CNG
        </div>
       <div style="margin-left:5px"> <asp:Label ID="lblunit" Text="Unit: 1000'USD" runat="server" ForeColor="Red"></asp:Label></div>
    </div>
        </div>
    <script>
        $(document).ready(function () {
            var jname = $("#hdname").val();
            var jwgt = $("#hdwgt").val();

            var barChartData = {
                labels: $.parseJSON(jname),
                datasets: [
                    {
                        //fillColor: "rgba(220,220,220,0.5)",
                        //strokeColor: "rgba(255,0,0,0.3)",
                        //highlightFill: "rgba(255,0,0,0.3)",
                        //highlightStroke: "rgb(255,0,255)",
                        //data: $.parseJSON(jwgt)
                        fillColor: "rgb(90,183,214)",
                        strokeColor: "rgb(43,68,135)",
                        highlightFill: "rgba(255,0,0,0.3)",
                        highlightStroke: "rgb(255,0,255)",
                        data: $.parseJSON(jwgt)
                    }
                ]
            }
            window.onload = function () {
                //var ctx = document.getElementById("canvas").getContext("2d");
                //window.myLine = new Chart(ctx).Line(lineChartData, {
                //    responsive: true
                //});
                var ctx2 = document.getElementById("canvas1").getContext("2d");
                window.myBar = new Chart(ctx2).Bar(barChartData, {
                    responsive: true
                });
            }
        });
    </script>
</asp:Content>
