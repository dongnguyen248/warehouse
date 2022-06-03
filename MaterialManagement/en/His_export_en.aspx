<%@ Page Title="" Language="C#" MasterPageFile="~/en/Site1.Master" AutoEventWireup="true" CodeBehind="His_export_en.aspx.cs" Inherits="MaterialManagement.en.His_export_en" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../style/fixedheadertable.css" rel="stylesheet" />
    <link href="../style/custom.css" rel="stylesheet" />
    <link href="../style/finalschedule.css" rel="stylesheet" />
    <script src="../js/jquery.fixedheadertable.js"></script>
 <script src="Scripts/export_his.js"></script>
     <style>
            #tbContent td {
            border:1px solid black;
            }
            #tbHeader th {
            border:1px solid black;
            text-align:center;
            font-weight:bolder;
            }
            #dvContent {
            margin-top:10px;
            }
            div.tooltip-inner {
    max-width: 900px;
}
  </style>
        <script>
            $(document).ready(function () {
                function scrollHandler(e) {
                    $('#row').css('left', -$('#table').get(0).scrollLeft);
                    $('#col').css('top', -$('#table').get(0).scrollTop);
                }
                $('#table').scroll(scrollHandler);
                var animate = false;
                $('#wrapper').keydown(function (event) {
                    if (event.keyCode == 37 && !animate) {
                        animate = true;
                        $('#table').animate({ scrollLeft: "-=200" }, "slow", function () {
                            animate = false;
                        });
                        event.preventDefault();
                    } else if (event.keyCode == 39 && !animate) {
                        animate = true;
                        $('#table').animate({ scrollLeft: "+=200" }, "slow", function () {
                            animate = false;
                        });
                        event.preventDefault();
                    } else if (event.keyCode == 38 && !animate) {
                        animate = true;
                        $('#table').animate({ scrollTop: "-=200" }, "slow", function () {
                            animate = false;
                        });
                        event.preventDefault();
                    } else if (event.keyCode == 40 && !animate) {
                        animate = true;
                        $('#table').animate({ scrollTop: "+=200" }, "slow", function () {
                            animate = false;
                        });
                        event.preventDefault();
                    }
                });
            });
     </script>
   <form id="Form1" runat="server">
    <div id="dvFunction">
      <div style="min-width:700px"><h2>EXPORT HISTORY</h2></div>
      <div style="margin-top:10px;min-width:1500px";>  
          <div style="float:left;margin-left:10px"><label>From</label></div><div style="float:left;margin-left:5px"><asp:TextBox runat="server" ID="txtfrom" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
          <div style="float:left;margin-left:5px"><label>To</label></div>
          <div style="float:left"><asp:TextBox runat="server" ID="txtto" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
          <div style="float:left;margin-left:5px"><label>Qcode</label></div>
          <div style="float:left;margin-left:5px;width:130px"><asp:TextBox runat="server" ID="txtQCode" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
           <div style="float:left;margin-left:5px;width:210px"><div style="float:left;width:40px"><label>Line</label></div> <div style="margin-left:5px;width:160px;float:left"><asp:DropDownList ID="dropline" runat="server" CssClass="form-control"></asp:DropDownList></div></div>
          <div style="float:left;margin-left:5px;margin-left:10px">
         <asp:LinkButton ID="btnSearch"
                    runat="server"
                    CssClass="btn btn-primary" OnClick="btnSearch_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-search"></span>Search
                </asp:LinkButton>
              </div>
          <div style="margin-left:5px;width:90px;float:left"><asp:LinkButton ID="lnkExcel"
                    runat="server"
                    CssClass="btn btn-primary" OnClick="lnkExcel_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-export"></span>Export
                </asp:LinkButton></div>
           <div style="margin-left:5px;float:left;width:70px">
               <%if (Session["USERNAME"] == null){ %>
           <button type="button" id="btnModify" class="btn btn-primary" disabled="disabled">
           <span class="glyphicon glyphicon-pencil"></span>Edit</button>
               <%}else{ %>
               <button type="button" id="btnModify" class="btn btn-primary">
           <span class="glyphicon glyphicon-pencil"></span>Edit</button>
               <%} %>
              </div>
      <div> <asp:LinkButton ID="btnReport" CssClass="btn btn-primary" runat="server" OnClick="btnReport_Click"><span aria-hidden="true" class="glyphicon glyphicon-export">Report</span></asp:LinkButton></div>
      </div>
       
        <div style="clear:both;margin-top:20px"></div>
   </div>
    <div id="dvContent" style="margin-top:100px">
         <div id="wrapper" tabindex="0">
    <div id="head1">
        <table id="tblhead1">
            <thead class="thead">
               <tr>
                 <th style="min-width:30px">Sel</th>
                 <th style="min-width:80px">EXP Date</th>
                 <th style="min-width:80px" >ID</th>
                 <th style="min-width:170px">Name</th>
                 <th><div  style="width:100px">IMP Date</div></th>
              </tr> 
            </thead>
        </table>
    </div>
           <div id="row-wrapper">
        <div id="row">
        <table id="tblhead2">
            <thead class="thead">
             <tr>
                 <th style="min-width:280px">Specs</th>
                 <th style="min-width:70px">Unit</th>
                 <th style="min-width:60px;text-align:center">Price<br />(USD)</th>
                 <th style="min-width:60px;text-align:center">Stock<br />Quantity</th>
                 <th style="min-width:60px">Quantity<br /> Export</th>
                 <th style="min-width:60px">Stock</th>
                 <th style="min-width:60px">Price<br />(USD)</th>
                 <th style="min-width:140px">Line</th>
                 <th style="min-width:240px">Line Code</th>
                 <th style="width:110px">Code Account</th>
                 <th style="min-width:200px">Requestor</th>
                 <th style="min-width:300px">Note</th>
             </tr>
            </thead>
        </table>
    </div>
    </div>
    <div id="col-wrapper">
        <div id="col"  style="font-family:'Times New Roman';">
        <table id="tblfinal">
            <tbody>
                <%for (int i = 0; i < DTB.Rows.Count; i++)
                  {
                      string Item = DTB.Rows[i]["Item"].ToString().Trim();
                      if (Item.Length > 20)
                      {
                          Item = Item.Substring(0, 18)+"..";
                      }
                      %>
                <tr>
              <td style="min-width:30px;text-align:center"><input type="checkbox" class="chk" /><input type="hidden" class="id" value="<%=DTB.Rows[i]["Seq"]%>" /></td>
              <td style="min-width:80px;text-align:center"><%=DTB.Rows[i]["Out_Date"]%></td>
              <td style="min-width:80px;text-align:center"><%=DTB.Rows[i]["Qcode"]%></td>
              <td style="min-width:170px"><div  class="tooltip-wide"  data-toggle="tooltip"  title="<%=  DTB.Rows[i]["Item"].ToString().Trim() %>"><%=Item %></div></td>
              <td><div  style="width:100px"><%=DTB.Rows[i]["Pur_Date"]%></div></td>
                </tr>
                <%} %>
            </tbody>
        </table>
    </div>
    </div>
    <div id="table" style="font-family:'Times New Roman';">
        <table id="tblfinal2" >
            <tbody>
                <%if (DTB.Rows.Count > 0)
                 {
                     for (int i = 0; i < DTB.Rows.Count; i++)
                     {
                         string spec = DTB.Rows[i]["SPEC"].ToString().Trim();
                        // string price = DTB.Rows[i]["PRICE"].ToString();
                         double price = Math.Round(Convert.ToDouble(DTB.Rows[i]["PRICE"].ToString()),2);
                         double amount = Math.Round(Convert.ToDouble(DTB.Rows[i]["amount"].ToString()), 2);
                         if (spec.Length >= 30)
                         {
                            spec  = spec.Substring(0, 30)+".."; 
                         }
                      %>
                 <tr>
                       <td style="min-width:280px"><div  class="tooltip-wide"  data-toggle="tooltip"  title="<%=  DTB.Rows[i]["SPEC"].ToString().Trim() %>"><%=spec %></div></td>
                       <td style="min-width:70px;text-align:center"><%=DTB.Rows[i]["UNIT"]%></td>
                       <td style="min-width:60px;text-align:center"><%=price%></td>
                       <td style="min-width:60px;text-align:center"><%=DTB.Rows[i]["inventory"]%></td>
                       <td style="min-width:60px;text-align:center"><%=DTB.Rows[i]["Quantity"]%></td>
                       <td style="min-width:60px;text-align:center"><%=DTB.Rows[i]["QtyNow"]%></td>
                       <td style="min-width:60px;text-align:center"><%=amount%></td>
                       <td style="min-width:140px;text-align:center"><%=DTB.Rows[i]["Line"]%></td>
                       <td style="min-width:240px;text-align:center"><%=DTB.Rows[i]["CodeCenter"]%></td>
                       <td style="width:100px;text-align:center"><%=DTB.Rows[i]["CostAccount"]%></td>
                       <td style="min-width:200px"><%=DTB.Rows[i]["Requestor"]%></td>
                       <td><div  style="min-width:300px"><%=DTB.Rows[i]["Remark"]%></div></td>
                </tr>
                <%}
                 } %>
            </tbody>
        </table>
    </div>
</div>
    </div>
        </form>
     <div style="width:100px;margin:0 auto;color:red;font-weight:bold;clear:both;margin-top:730px"><label><%=DTB.Rows.Count %> rows</label></div>
     <!-- Modal -->
    <div class="modal fade" id="modalAllocate" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="H2"><span class="glyphicon glyphicon-user"></span>Export</h4>
                    <input type="hidden" id="hdSeq" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="Form2" role="form">
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                      <label>Qcode</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtCode" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td class="tdleft">
                                      <label>Import Date</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtImport_Date" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                      <label>Export Date</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtExportDate"/>
                                    </td>
                                </tr>
                                
                                  <tr>
                                    <td class="tdleft">
                                      <label>Stock</label></td>
                                    <td>
                                      <input type="number" class="form-control" id="txtInvenQty"/>
                                    </td>
                                      </tr>
                                   <tr>
                                    <td class="tdleft">
                                      <label>Export number</label></td>
                                    <td>
                                      <input type="number" class="form-control" id="txtQuantity" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                      <label>Line</label></td>
                                    <td>
                                        <div style="width:500px;">
                                        <div style="float:left;width:180px;margin-right:10px;">
                                      <select id="selLine" class="form-control">
                                          <option>5 S</option>
                                          <option>CAPL LINE</option>
                                          <option>CARPENTER</option>
                                          <option>CBL LINE</option>
                                          <option>CITY WATER</option>
                                          <option>CONSTRUCT</option>
                                          <option>CRANE</option>
                                          <option>CTL #2 LINE</option>
                                          <option>FACTORY #1</option>
                                          <option>FACTORY #2</option>
                                          <option>GARDEN</option>
                                          <option>HBA LINE</option>
                                          <option>P PACKING</option>
                                          <option>PACKING 1</option>
                                          <option>PACKING 2</option>
                                          <option>PDGL LINE</option>
                                          <option>PHBAL LINE</option>
                                          <option>P-QC</option>
                                          <option>PRODUCTION</option>
                                          <option>PSL  LINE</option>
                                          <option>PTLL LINE</option>
                                          <option>PZM LINE</option>
                                          <option>QC  LINE</option>
                                          <option>QSS</option>
                                          <option>RG PZM LINE</option>
                                           <option>RG SPM #2 LINE</option>
                                          <option>RG SPM #3 LINE</option>
                                          <option>RG ZRM LINE</option>
                                          <option>RG ZRM#3 LINE</option>
                                          <option>RS-LINE</option>
                                          <option>SAFETY</option>
                                          <option>SECURITY</option>
                                          <option>SL #2 LINE</option>
                                          <option>SPM #1 LINE</option>
                                          <option>SPM #2 LINE</option>
                                          <option>SPM #3 LINE</option>
                                          <option>STL LINE</option>
                                          <option>TLL LINE</option>
                                          <option>UTILITY LINE</option>
                                          <option>VBA #1 LINE</option>
                                          <option>VBA #2 LINE</option>
                                          <option>WAREHOUSE</option>
                                          <option>WORK-COMMON</option>
                                          <option>WP #1 LINE</option>
                                           <option>WP #2 LINE</option>
                                           <option>WWT LINE</option>
                                           <option>ZRM #1 LINE</option>
                                           <option>ZRM #2 LINE</option>
                                           <option>ZRM #3 LINE</option>
                                      </select>
                                      </div>
                                      <div style="width:240px;float:left" id="dvcode">
                                      <div class="tdleft" style="float:left;width:80px;font-weight:bold;height:35px;text-align:center"><label>Code Center</label></div> <div style="width:150px;float:left;margin-left:5px"><input type="text" id="txtCodeArea" class="form-control" /></div>
                                      </div>
                                      </div>
                                    </td>
                                </tr>
                                    <tr>
                                    <td class="tdleft">
                                      <label>Code Account</label></td>
                                    <td>
                                    <div style="width:500px;">
                                        <div style="float:left;width:180px;margin-right:10px;">
                                        <select id="txtCostAcount" class="form-control" style="width:180px">
                                              <option></option>
                                              <option>602011-0000</option>
                                              <option>602021-0000</option>
                                              <option>602031-0000</option>
                                              <option>602041-0000</option>
                                              <option>606191-2802</option>
                                              <option>Others</option>
                                         </select>
                                            </div>
                                              <div style="width:240px;float:left" id="dvother">
                                      <div class="tdleft" style="float:left;width:80px;font-weight:bold;height:35px;text-align:center"><label>Nhập mã</label></div> <div style="width:150px;float:left"><input type="text" id="txtother" class="form-control" /></div>
                                      </div>
                                     </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                      <label>Requestor</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtRequestor" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td class="tdleft">
                                      <label>Note</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtRemark" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnSave" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Lưu thông tin</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button3" type="reset"><span class="glyphicon glyphicon-remove"></span>Thoát</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
