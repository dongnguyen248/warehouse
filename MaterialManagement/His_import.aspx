<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="His_import.aspx.cs" Inherits="MaterialManagement.His_import" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        #tbContent td
        {
            border: 1px solid black;
        }

        #tbHeader th
        {
            border: 1px solid black;
            text-align: center;
            font-weight: bolder;
        }

        #dvContent
        {
            margin-top: 10px;
        }

        .mau
        {
            background-color: pink;
        }
    </style>
    <link href="style/fixedheadertable.css" rel="stylesheet" />
    <link href="style/custom.css" rel="stylesheet" />
    <%--<link href="style/finalschedule.css" rel="stylesheet" />--%>
    <link href="style/His_import.css" rel="stylesheet" />
    <script src="js/jquery.fixedheadertable.js"></script>
    <script src="import_his.js"></script>
    <script>
        $(document).ready(function () {
            //$("#final").addClass("active");
            //$("#monitoring").removeClass("active");
            //$("#register").removeClass("active");
            //$("#domestic").removeClass("active");
            //$("#fExport").removeClass("active");
            //$("#import").removeClass("active");
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
    <form runat="server">
        <div>
            <h2>LỊCH SỬ NHẬP KHO</h2>
        </div>
        <div id="dvFunction">
            <div style="margin-top: 10px; min-width: 1400px;">
                <div style="float: left; margin-left: 10px">
                    <label>From</label></div>
                <div style="float: left; margin-left: 5px; width: 120px">
                    <asp:TextBox runat="server" ID="txtfrom" CssClass="form-control" ClientIDMode="Static" AutoPostBack="true" OnTextChanged="txtfrom_TextChanged"></asp:TextBox></div>
                <div style="float: left; margin-left: 5px">
                    <label>To</label></div>
                <div style="float: left; width: 120px">
                    <asp:TextBox runat="server" ID="txtto" CssClass="form-control" ClientIDMode="Static" AutoPostBack="true" OnTextChanged="txtto_TextChanged"></asp:TextBox></div>
                <div style="float: left; margin-left: 5px">
                    <label>QCode</label></div>
                <div style="float: left; margin-left: 5px; width: 100px">
                    <asp:TextBox runat="server" ID="txtQCode" CssClass="form-control" ClientIDMode="Static"></asp:TextBox></div>
                <div style="float: left; margin-left: 5px">
                    <label>PO</label>
                </div>
                <div style="float: left; margin-left: 5px; width: 100px">
                    <asp:TextBox runat="server" ID="txtPoNumber" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div style="float: left; margin-left: 5px">
                    <label>Đã nhận</label>
                </div>
                <div style="float: left; margin-left: 5px">
                    <asp:CheckBox runat="server" ID="chkdanhan" CssClass="form-control" /></div>
                <div style="float: left; margin-left: 5px; width: 210px;">
                    <div style="float: left; width: 40px;">
                        <label>Line</label></div>
                    <div style="margin-left: 5px; width: 160px; float: left">
                        <asp:DropDownList ID="dropline" runat="server" CssClass="form-control"></asp:DropDownList></div>
                </div>
                <div style="float: left; margin-left: 5px">
                    <div style="float: left">
                        <label>NhàCC</label></div>
                    <div style="float: left; width: 150px">
                        <asp:DropDownList ID="dropNhaCC" runat="server" CssClass="form-control"></asp:DropDownList></div>
                </div>
                <div style="float: left; margin-left: 20px">
                    <asp:LinkButton ID="btnSearch"
                        runat="server"
                        CssClass="btn btn-primary" OnClick="btnSearch_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-search"></span> Search
                    </asp:LinkButton>
                </div>
                <div style="margin-left: 5px; width: 103px; float: left;">
                    <asp:LinkButton ID="lnkExcel"
                        runat="server"
                        CssClass="btn btn-primary" OnClick="lnkExcel_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-export"></span>Xuất Excel
                    </asp:LinkButton>
                </div>
                <div style="margin-left: 5px; float: left; width: 103px">
                    <%if (Session["USERNAME"] == null)
                      { %>
                    <button type="button" id="btnModify" class="btn btn-primary" disabled="disabled">
                        <span class="glyphicon glyphicon-pencil"></span>Chỉnh sửa</button>
                    <%}
                      else
                      { %>
                    <button type="button" id="btnModify" class="btn btn-primary"><span class="glyphicon glyphicon-pencil"></span>Chỉnh sửa</button>
                    <%} %>
                </div>
                <div style="margin-left: 50px">
                    <%if (Session["USERNAME"] == null)
                      { %>
                    <button type="button" id="btnDelete" class="btn btn-danger" disabled="disabled">
                        <span class="glyphicon glyphicon-pencil"></span>Xóa</button>
                    <%}
                      else
                      { %>
                    <button type="button" id="btnDelete" class="btn btn-danger"><span class="glyphicon glyphicon-pencil"></span>Xóa</button>
                    <%} %>
                </div>
            </div>
        </div>
        <div style="clear: both; margin-top: 10px"></div>
        <div id="dvContent">
            <input type="hidden" id="hdSeq" />
            <input type="hidden" id="hdQCode" />
            <input type="hidden" id="hdPur_Date" />
            <div id="wrapper" tabindex="0">
                <div id="head1">
                    <table id="tblhead1">
                        <thead class="thead">
                            <tr>
                                <th style="min-width: 30px">STT</th>
                                <th style="min-width: 75px">Mã</th>
                                <th style="min-width: 190px">Tên</th>
                                <th style="min-width: 156px">Vị trí</th>
                                <th style="min-width: 300px">Thông số kỹ thuật</th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <div id="row-wrapper">
                    <div id="row">
                        <table id="tblhead2">
                            <thead class="thead">
                                <tr>
                                    <th style="min-width: 75px">Ngày Nhập</th>
                                    <th style="min-width: 70px">Số<br />
                                        lượng</th>
                                    <th style="min-width: 60px">Giá<br />
                                        (USD)</th>
                                    <th style="min-width: 75px">Số Po</th>
                                    <th style="min-width: 250px">Nhà Cung cấp</th>
                                    <th style="min-width: 160px">Người mua</th>
                                    <th style="min-width: 210px">Người yêu cầu</th>
                                    <th style="min-width: 240px">Ghi chú</th>
                                    <th style="min-width: 180px">Locator</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
                <div id="col-wrapper">
                    <div id="col" style="font-family: 'Times New Roman';">
                        <table id="tblfinal">
                            <tbody>
                                <%for (int i = 0; i < DTB.Rows.Count; i++)
                                  {
                                      var class1 = "";
                                      if (string.Compare(DTB.Rows[i]["Allocated"].ToString(), "1") == 0)
                                          class1 = "mau";
                                      var Item = DTB.Rows[i]["Item"].ToString().Trim();
                                      string spec = DTB.Rows[i]["spec"].ToString().Trim();
                                      string location = DTB.Rows[i]["LOCATION"].ToString().Trim();
                                      if (location.Length > 20)
                                      {
                                          location = location.Substring(0, 18) + "..";
                                      }
                                      if (spec.Length > 35)
                                      {
                                          spec = spec.Substring(0, 33) + "..";
                                      }
                                      if (Item.Length > 22)
                                      {
                                          Item = Item.Substring(0, 20) + "..";
                                      }
                   
                                %>
                                <tr class="<%=class1 %>">
                                    <td style="min-width: 30px">
                                        <input type="checkbox" class="chk" /><input type="hidden" class="id" value="<%=DTB.Rows[i]["Seq"]%>" /></td>
                                    <td style="min-width: 75px"><%=DTB.Rows[i]["Qcode"]%></td>
                                    <td style="min-width: 190px">
                                        <div class="tooltip-wide" data-toggle="tooltip" title="<%=  DTB.Rows[i]["Item"].ToString().Trim() %>"><%=Item %></div>
                                    </td>
                                    <%--  <td style="min-width:100px"><%=DTB.Rows[i]["LOCATION"].ToString().Trim()%></td>--%>
                                    <td>
                                        <div style="min-width: 155px" data-toggle="tooltip" title="<%= DTB.Rows[i]["LOCATION"].ToString().Trim() %>"><%=location %></div>
                                    </td>
                                    <td style="min-width: 300px; text-align: left; padding-left: 3px">
                                        <div class="tooltip-wide" data-toggle="tooltip" title="<%=  DTB.Rows[i]["spec"].ToString().Trim() %>"><%=spec %></div>
                                    </td>
                                </tr>
                                <%} %>
                                <tr>
                                    <td style="min-width: 30px; background-color: #9dbba5">
                                        <input type="checkbox" class="chk" /></td>
                                    <td colspan="4" style="background-color: #9dbba5"></td>
                                </tr>
                            </tbody>

                        </table>
                    </div>
                </div>
                <div id="table" style="font-family: 'Times New Roman';">
                    <table id="tblfinal2">
                        <tbody>
                            <%if (DTB.Rows.Count > 0)
                              {
                                  for (int i = 0; i < DTB.Rows.Count; i++)
                                  {
                                      var class1 = "";
                                      if (string.Compare(DTB.Rows[i]["Allocated"].ToString(), "1") == 0)
                                          class1 = "mau";
                                      var supplier = DTB.Rows[i]["Supplier"].ToString().Trim();
                                      var qty = Convert.ToDouble(DTB.Rows[i]["Quantity"].ToString().Trim());
                                      SumQty += qty;
                                      if (supplier.Length > 27)
                                      {
                                          supplier = supplier.Substring(0, 25) + "..";
                                      }
                                      string po = DTB.Rows[i]["Po"].ToString().Trim();
                                      if (po.Length > 11)
                                      {
                                          po = po.Substring(0, 10) + "..";
                                      }
                            %>
                            <tr class="<%=class1 %>">
                                <td style="min-width: 75px; text-align: center"><%=DTB.Rows[i]["Pur_Date"]%></td>
                                <td style="min-width: 70px; text-align: center"><%=DTB.Rows[i]["Quantity"]%></td>
                                <td style="min-width: 60px; text-align: center"><%=DTB.Rows[i]["Price"]%></td>
                                <%--<td style="min-width:75px;text-align:center"><%=DTB.Rows[i]["Po"]%></td>--%>
                                <td style="min-width: 75px">
                                    <div class="tooltip-wide" data-toggle="tooltip" title="<%=  DTB.Rows[i]["Po"].ToString().Trim() %>"><%=po %></div>
                                </td>
                                <td style="min-width: 250px">
                                    <div class="tooltip-wide" data-toggle="tooltip" title="<%=  DTB.Rows[i]["Supplier"].ToString().Trim() %>"><%=supplier %></div>
                                </td>
                                <td style="min-width: 160px"><%=DTB.Rows[i]["Buyer"]%></td>
                                <td style="min-width: 210px"><%=DTB.Rows[i]["Receiver"]%></td>
                                <td style="min-width: 240px"><%=DTB.Rows[i]["Remark"] %></td>
                                <td style="min-width: 180px"><%=DTB.Rows[i]["locator"] %></td>
                            </tr>
                            <%}
                  }
                            %>
                            <tr>
                                <td style="min-width: 75px; background-color: #9dbba5">TỔNG</td>
                                <td style="min-width: 60px; text-align: center; background-color: #9dbba5"><%=SumQty%></td>
                                <td style="min-width: 60px; text-align: center; background-color: #9dbba5" colspan="7"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
    <div style="width: 100px; margin: 0 auto; color: red; font-weight: bold; clear: both; margin-top: 750px">
        <label><%=DTB.Rows.Count %> rows</label></div>
    <!-- Modal import  -->
    <div class="modal fade" id="modalImport" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="H3"><span class="glyphicon glyphicon-user"></span>SỬA THÔNG TIN NHẬP KHO </h4>
                    <input type="hidden" id="hdimportdate" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="Form3" role="form">
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                        <label>Mã QCode</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImp_QCode" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ngày nhập</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImpDate" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Số lượng</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtQty" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Giá(USD)</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtPrice" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Số Po</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtPo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Nhà cung cấp</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImp_Supplier" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="tdleft">
                                        <label>Người mua</label></td>
                                    <td>
                                        <%--<input type="text" class="form-control" id="txtImp_Buyer" />--%>
                                        <select id="txtImp_Buyer" class="form-control">
                                            <option></option>
                                            <option>Nguyễn Đình Luân</option>
                                            <option>Đặng Thị Thùy Trang</option>
                                            <option>Huỳnh Trọng Tuấn</option>
                                            <option>Nguyễn Kim Thủy</option>
                                            <option>Nguyễn Thị Thu</option>
                                            <option>Trần Ngọc Bình</option>                                           
                                            <option>Thân thị Hằng</option>
                                            <option>Bùi Thị ThùyTrang</option>
                                            <option>Bùi Trọng Thắng</option>
                                            <option>Trần Dũng</option>
                                            <option>Hồ Thị Thanh Loan</option>
                                            <option>Phạm Thị Thu Hoài</option>
                                            <option>KO MOON JEONG</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Người yêu cầu</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImp_Receiver" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Đã nhận</label></td>
                                    <td>
                                        <input type="checkbox" id="chknhan" class="nhan" name="chknhan" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ghi chú </label>
                                    </td>
                                    <td>
                                        <input type="text" id="txtRemark" class="form-control" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Vị trí(Locator)</label></td>
                                    <td>
                                        <input type="text" id="txtlocator" class="form-control" /></td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnImpSave" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Lưu</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button4" type="reset"><span class="glyphicon glyphicon-remove"></span>Thoát</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
