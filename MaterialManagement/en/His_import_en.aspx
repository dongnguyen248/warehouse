<%@ Page Title="" Language="C#" MasterPageFile="~/en/Site1.Master" AutoEventWireup="true" CodeBehind="His_import_en.aspx.cs" Inherits="MaterialManagement.en.His_import_en" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                .mau {
                background-color:pink;
                }
        </style>
    <link href="../style/fixedheadertable.css" rel="stylesheet" />
    <link href="../style/custom.css" rel="stylesheet" />
    <%--<link href="style/finalschedule.css" rel="stylesheet" />--%>
    <link href="../style/His_import.css" rel="stylesheet" />
    <script src="../js/jquery.fixedheadertable.js"></script>
    <script src="import_his.js"></script>
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
        <div><h2>IMPORT HISTORY</h2></div>
    <div id="dvFunction">
      <div style="margin-top:10px; width:1250px;">  
          <div style="float:left;margin-left:10px"><label>From</label></div><div style="float:left;margin-left:5px;width:120px"><asp:TextBox runat="server" ID="txtfrom" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
          <div style="float:left;margin-left:5px"><label>To</label></div>
          <div style="float:left;width:120px"><asp:TextBox runat="server" ID="txtto" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
          <div style="float:left;margin-left:5px"><label>QCode</label></div>
          <div style="float:left;margin-left:5px"><asp:TextBox runat="server" ID="txtQCode" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
          <div style="float:left;margin-left:5px">
           <label>Recieved</label>
          </div>
          <div style="float:left;margin-left:5px"> <asp:CheckBox runat="server" ID="chkdanhan" CssClass ="form-control" /></div>
           <div style="float:left;margin-left:5px;width:210px;"><div style="float:left;width:40px;"><label>Line</label></div> <div style="margin-left:5px;width:160px;float:left"><asp:DropDownList ID="dropline" runat="server" CssClass="form-control"></asp:DropDownList></div></div>
         <div style="float:left;margin-left:5px"><div style="float:left"><label>NhàCC</label></div><div style="float:left;width:150px"><asp:DropDownList ID="dropNhaCC" runat="server" CssClass="form-control" OnSelectedIndexChanged="dropNhaCC_SelectedIndexChanged"></asp:DropDownList></div></div>
           <div style="float:left;margin-left:30px">
         <asp:LinkButton ID="btnSearch"
                    runat="server"
                    CssClass="btn btn-primary" OnClick="btnSearch_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-search"></span> Search
                </asp:LinkButton>
              </div>
                  <div style="margin-left:5px;width:90px;float:left;"><asp:LinkButton ID="lnkExcel"
                    runat="server"
                    CssClass="btn btn-primary" OnClick="lnkExcel_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-export"></span>Excel
                </asp:LinkButton>
             </div>
          <div style="margin-left:5px">
              <%if (Session["USERNAME"] == null){ %>
          <button type="button" id="btnModify" class="btn btn-primary" disabled="disabled">
           <span class="glyphicon glyphicon-pencil"></span>Edit</button>
              <%}else{ %>
               <button type="button" id="btnModify" class="btn btn-primary"><span class="glyphicon glyphicon-pencil"></span>Edit</button>
              <%} %>
           </div>
      </div>
   </div>
        <div  style="clear:both;margin-top:10px"></div>
    <div id="dvContent">
         <input type="hidden" id="hdSeq" />
        <input type="hidden" id="hdQCode" />
        <input type="hidden" id="hdPur_Date" />
         <div id="wrapper" tabindex="0">
    <div id="head1">
        <table id="tblhead1">
            <thead class="thead">
               <tr>
                 <th style="min-width:30px">SEQ</th>
                 <th style="min-width:70px">ID</th>
                 <th style="min-width:190px">Name</th>
                 <th style="min-width:300px">Specs</th>
              </tr> 
            </thead>
        </table>
    </div>
           <div id="row-wrapper">
        <div id="row">
        <table id="tblhead2">
            <thead class="thead">
             <tr>
                 <th style="min-width:75px">Import Date</th>
                 <th style="min-width:60px">QTY</th>
                 <th style="min-width:60px">Price<br />(USD)</th>
                 <th style="min-width:60px">Po<br /> Number</th>
                 <th style="min-width:250px">Supplier</th>
                 <th style="min-width:160px">Buyer</th>
                 <th style="min-width:210px">Requestor</th>
                 <th style="min-width:200px">Note</th>
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
                      var class1 = "";
                      if (string.Compare(DTB.Rows[i]["Allocated"].ToString(), "1") == 0)
                          class1 = "mau";
                     var Item = DTB.Rows[i]["Item"].ToString().Trim();
                     string spec = DTB.Rows[i]["spec"].ToString().Trim();
                     if (spec.Length > 35)
                     {
                         spec = spec.Substring(0, 33) + "..";
                     }
                     if (Item.Length > 22)
                     {
                         Item = Item.Substring(0,20)+"..";
                     }
                       %>
                <tr class="<%=class1 %>">
              <td style="min-width:30px"><input type="checkbox" class="chk" /><input type="hidden" class="id" value="<%=DTB.Rows[i]["Seq"]%>" /></td>
              <td style="min-width:70px"><%=DTB.Rows[i]["Qcode"]%></td>
              <td style="min-width:190px"><div  class="tooltip-wide"  data-toggle="tooltip"  title="<%=  DTB.Rows[i]["Item"].ToString().Trim() %>"><%=Item %></div></td>
               <td style="min-width:300px;text-align:left;padding-left:3px"><div  class="tooltip-wide"  data-toggle="tooltip"  title="<%=  DTB.Rows[i]["spec"].ToString().Trim() %>"><%=spec %></div></td>
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
                        var class1 = "";
                        if (string.Compare(DTB.Rows[i]["Allocated"].ToString(), "1") == 0)
                            class1 = "mau";
                        var supplier = DTB.Rows[i]["Supplier"].ToString().Trim();
                        if (supplier.Length > 25)
                        {
                            supplier = supplier.Substring(0,23);
                        }
                      %>
                 <tr class="<%=class1 %>">
              <td style="min-width:75px;text-align:center"><%=DTB.Rows[i]["Pur_Date"]%></td>
              <td style="min-width:60px;text-align:center"><%=DTB.Rows[i]["Quantity"]%></td>
              <td style="min-width:60px;text-align:center"><%=DTB.Rows[i]["Price"]%></td>
              <td style="min-width:60px;text-align:center"><%=DTB.Rows[i]["Po"]%></td>
              <td style="min-width:250px"><div  class="tooltip-wide"  data-toggle="tooltip"  title="<%=  DTB.Rows[i]["Supplier"].ToString().Trim() %>"><%=supplier %></div></td>
              <td style="min-width:160px"><%=DTB.Rows[i]["Buyer"]%></td>
              <td style="min-width:210px"><%=DTB.Rows[i]["Receiver"]%></td>
              <td style="min-width:200px"><%=DTB.Rows[i]["Remark"] %></td>
                </tr>
                <%}
                  }
                 %>
            </tbody>
        </table>
    </div>
</div>  
    </div>
        </form>
    <div style="width:100px;margin:0 auto;color:red;font-weight:bold;clear:both;margin-top:730px"><label><%=DTB.Rows.Count %> rows</label></div>
        <!-- Modal import  -->
    <div class="modal fade" id="modalImport" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="H3"><span class="glyphicon glyphicon-user"></span>Edit Info </h4>
                    <input type="hidden" id="hdimportdate" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="Form3" role="form">
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                      <label>QCode</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtImp_QCode" required="required" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td class="tdleft">
                                      <label>Import Date</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtImpDate" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                      <label>QTY</label></td>
                                    <td>
                                      <input type="number" class="form-control" id="txtQty"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                      <label>Price(USD)</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtPrice" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td class="tdleft">
                                      <label>Po Number</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtPo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                      <label>Supplier</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtImp_Supplier"  />
                                    </td>
                                </tr>
                                   
                                <tr>
                                    <td class="tdleft">
                                      <label>Buyer</label></td>
                                    <td>
                                         <select id="txtImp_Buyer" class="form-control">
                                        <option></option>
                                        <option>Nguyễn Đình Luân</option>
                                        <option>Mai Thanh Bình</option>
                                        <option>Nguyễn Kim Thủy</option>
                                        <option>Nguyễn Thị Thu</option>
                                        <option>Trần Ngọc Bình</option>
                                        <option>Trần thị Kiều Nhung</option>
                                        <option>Thân thị Hằng</option>
                                        <option>Bùi Thị ThùyTrang</option>
                                        <option>Bùi Trọng Thắng</option>
                                        <option>Trần Dũng</option>
                                    </select>
                                    </td>
                                </tr>
                                 <tr>
                                    <td class="tdleft">
                                      <label>Requestor</label></td>
                                    <td>
                                      <input type="text" class="form-control" id="txtImp_Receiver" />
                                    </td>
                                </tr>
                                <tr>
                                   <td class="tdleft"><label>Recieved</label></td><td><input type="checkbox" id="chknhan" class="nhan" name="chknhan"/></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">Note</td>
                                    <td><input type="text" id="txtRemark" class="form-control" /></td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnImpSave" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Save</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button4" type="reset"><span class="glyphicon glyphicon-remove"></span>Close</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
