<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MaterialManagement.Default" %>

<%@ Register Assembly="KeepAutomation.Barcode.Web" Namespace="KeepAutomation.Barcode.Web" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/bootstrap3-typeahead.min.js"></script>
    <script src="Scripts/moment.js"></script>
    <script src="Scripts/bootstrap-datetimepicker.min.js"></script>
    <script src="Scripts/Default.js"></script>
    <style>
        option {
            padding: 10px 0;
            font-weight: bold;
            margin-left: 5px;
        }
    </style>
    <script>
        $(document).ready(function () {
            $('#imgLocation').addClass("Addimg");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="margin-top: 2px; margin-left: 5px; margin-bottom: 5PX; font-size: larger; text-align: center; background-color: RGB(89,89,89); width: 290px; font-weight: bold; color: #15a19d; border: 2px solid #13a8bd" id="dvInventory">MRO INVENTORY LIST</div>
    <div class="table-responsive">
        <form id="frmSearch" class="form-inline" role="form" runat="server" defaultbutton="btnSearch">
            <asp:HiddenField ID="hdQuery" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="txtNow" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="hdbarcode" runat="server" ClientIDMode="Static" />
            <input type="hidden" id="hdprice" />
            <div>
                <div style="float: left;">
                    <div class="form-group">
                        <div class="form-group" style="margin-left: 10px">
                            <label for="Zone" style="color: RGB(0,87,137)">Zone</label>
                            <asp:TextBox ID="TextZone" ClientIDMode="Static" runat="server" CssClass="form-control" Width="160px"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="location" style="color: RGB(0,87,137)">Location</label>
                            <asp:TextBox ID="TextLocation" ClientIDMode="Static" runat="server" CssClass="form-control" Width="160px"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="qcode" style="color: RGB(0,87,137)">Qcode</label>
                            <asp:TextBox ID="TextQcode" ClientIDMode="Static" runat="server" CssClass="form-control" Width="160px"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="namedevice" style="color: RGB(0,87,137)">Item</label>
                            <asp:TextBox ID="TextNameDevice" ClientIDMode="Static" runat="server" CssClass="form-control" Width="160px"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="spec" style="color: RGB(0,87,137)">Specification</label>
                            <asp:TextBox ID="TextSpec" ClientIDMode="Static" runat="server" CssClass="form-control" Width="160px"></asp:TextBox>
                        </div>

                    </div>
                  
                    <asp:LinkButton ID="btnSearch"
                        runat="server"
                        CssClass="btn btn-primary" OnClick="btnSearch_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-search"></span> Tìm Kiếm
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnExport"
                        runat="server"
                        CssClass="btn btn-primary" OnClick="btnExport_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-export"></span> Xuất Excel
                    </asp:LinkButton>
                </div>
                <div style="float: left; width: 540px; float: right;">
                    <div style="float: right;">
                        <%if (Session["USERNAME"] == null)
                            {%>
                        <button type="button" id="btnAdd" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-file"></span>Nhập kho mới</button>
                        <button type="button" id="btnImport" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-pencil"></span>Nhập kho-số lượng</button>
                        <button type="button" id="btnallocate" class="btn btn-primary" disabled="disabled">
                            Xuất kho</button>
                        <button type="button" id="btnModify" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-pencil"></span>Chỉnh sửa</button>
                        <button type="button" id="btnDelete" class="btn btn-danger" disabled="disabled">
                            <span class="glyphicon glyphicon-trash"></span>Xóa</button>
                        <%--<button type="button" id="btnEditlist" class="btn btn-primary" disabled="disabled">
                        <span class="glyphicon glyphicon-trash"></span>Edit List</button>--%>
                        <%}
                            else
                            { %>
                        <button type="button" id="btnAdd" class="btn btn-primary">
                            <span class="glyphicon glyphicon-file"></span>Nhập kho mới</button>
                        <button type="button" id="btnImport" class="btn btn-primary">
                            <span class="glyphicon glyphicon-pencil"></span>Nhập kho-số lượng</button>
                        <button type="button" id="btnallocate" class="btn btn-primary">
                            Xuất kho</button>
                        <button type="button" id="btnModify" class="btn btn-primary">
                            <span class="glyphicon glyphicon-pencil"></span>Chỉnh sửa</button>
                        <button type="button" id="btnDelete" class="btn btn-danger">
                            <span class="glyphicon glyphicon-trash"></span>Xóa</button>
                        <%-- <button type="button" id="btnEditlist" class="btn btn-primary">
                     <span class="glyphicon glyphicon-trash"></span>Edit List</button>--%>
                        <%} %>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <hr />
    <%-- <div style="display:block;border:1PX solid BLUE;height:400PX">
   <div id="blockA" class="rotate">FILTER ELEMENT MANUAL VALVE</div><div style="border:2PX solid BLACK;height:60PX">A</div></div>--%>
    <div id="tbData" class="table-responsive">
        <input type="hidden" id="hdqcode" />
        <table id="tbMainDefault" class="table table-striped table-bordered table-hover">
            <thead>
                <tr class="tbheader">
                    <th style="width: 5px; padding: 3px">SEL<br />
                        <br />
                    </th>
                    <th style="min-width: 100PX; text-align: center; padding: 3px">Zone
                        <br />
                        (Khu vực)</th>
                    <th style="text-align: center; padding: 3px">Location
                        <br />
                        (Vị trí)</th>
                    <th style="text-align: center; padding: 3px">QCode
                        <br />
                        (Mã)</th>
                    <th style="text-align: center; padding: 3px">Item
                        <br />
                        (Tên)</th>
                    <th style="text-align: center; padding: 3px; min-width: 600px">Specification
                        <br />
                        (Mô tả)</th>
                    <th style="text-align: center; min-width: 55px; padding: 3px">
                        <div style="text-align: center;">
                            Unit
                        <br />
                            (Đơn vị)
                        </div>
                    </th>
                    <th style="text-align: center; min-width: 80px; padding: 3px">Quantity
                        <br />
                        (Số lượng)</th>
                    <th style="text-align: center; min-width: 80px; padding: 3px">Price
                        <br />
                        (Giá USD)</th>
                    <th style="text-align: center; padding: 3px; min-width: 80px">Date
                        <br />
                        (Ngày nhập)
                    </th>
                    <th style="text-align: center; min-width: 100px; padding: 3px">Remark
                        <br />
                        (Ghi chú)</th>
                    <th style="text-align: center; min-width: 100px; padding: 3px">new Remark
                        <br />
                        (Ghi chú mới)</th>
                    <th style="text-align: center; min-width: 100px; padding: 3px">Vị trí<br />
                        Locator</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="7" style="text-align: right">Total:</th>
                    <th></th>
                    <th colspan="5"></th>



                </tr>
            </tfoot>
        </table>
        <%--<div style="width: 100px; color: #f00; font-weight: bold; margin: 0 auto"><%=DTB.Rows.Count.ToString() + " dòng" %></div>--%>
    </div>
    <div class="modal fade" id="mdModify" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="title"><span class="glyphicon glyphicon-user"></span>NHẬP KHO</h4>
                    <input type="hidden" id="hdId" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="frmModify" role="form">
                        <input type="hidden" id="action" />
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                        <label>Mã QCode</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="QCode" />
                                    </td>
                                    <td class="tdleft">
                                        <label>Khu vực</label></td>
                                    <td>
                                        <%--<input type="text" class="form-control" id="Zone" />--%>
                                        <%--<datalist id="Zones">
                                            <!--[if IE 9]><select disabled style="display:none"><![endif]-->
                                            <%if(Zones.Rows.Count>0) %>
                                            <% for (int i = 0; i < Zones.Rows.Count; i++)
                                               {%>
                                            <option value="<%=Zones.Rows[i]["Zone"].ToString().Trim()%>" />
                                            <%} %>
                                            <!--[if IE 9]></select><![endif]-->
                                        </datalist>--%>
                                        <select id="Zone" class="form-control">
                                            <option value="-1"></option>
                                            <option value="WH1">MAIN WAREHOUSE</option>
                                            <option value="WH2">MECHANICAL WAREHOUSE</option>
                                            <option value="WH3">ELECTRIC WAREHOUSE</option>
                                            <option value="WH4">HUGE MATERIALS ZONE</option>
                                            <option value="WH5">EVERY MONTHS ISSUE</option>
                                            <option value="WH6">INSIDE FACTORY</option>
                                        </select>

                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Vị trí</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="Location" />
                                        <%--<datalist id="Locations">
                                            <!--[if IE 9]><select disabled style="display:none"><![endif]-->
                                             <%if (Loc.Rows.Count > 0) %>
                                            <% for (int i = 0; i < Loc.Rows.Count; i++)
                                               {%>
                                            <option value="<%=Loc.Rows[i]["Location"].ToString().Trim() %>" />
                                            <%} %>
                                            <!--[if IE 9]></select><![endif]-->
                                        </datalist>--%>
                                    </td>
                                    <td class="tdleft">
                                        <label>Tên hàng</label></td>
                                    <td>
                                        <input type="text" id="Item" class="form-control" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Thông tin mô tả</label></td>
                                    <td>
                                        <textarea id="Spec" class="form-control"></textarea>
                                    </td>
                                    <td class="tdleft">
                                        <label>Đơn vị</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="Unit" required="required" />
                                        <%-- <datalist id="Units">
                                            <!--[if IE 9]><select disabled style="display:none"><![endif]-->
                                             <%if (Unit.Rows.Count > 0) %>
                                            <% for (int i = 0; i < Unit.Rows.Count; i++)
                                               {%>
                                            <option value="<%=Unit.Rows[i]["Unit"].ToString().Trim() %>" />
                                            <%} %>
                                            <!--[if IE 9]></select><![endif]-->
                                        </datalist>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Số lượng</label></td>
                                    <td>
                                        <input type="text" id="Qty" class="form-control" required="required" />
                                    </td>
                                    <td class="tdleft">
                                        <label>Giá (USD)</label>
                                    </td>
                                    <td>
                                        <input type="text" id="Price" class="form-control" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ngày nhập</label></td>
                                    <td>
                                        <input type="text" id="txtPur_Date" class="form-control" required="required" />
                                    </td>
                                    <td class="tdleft">
                                        <label>Số PO</label></td>
                                    <td>
                                        <input id="txtPO" type="text" class="form-control" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Nhà cung cấp</label>
                                    </td>
                                    <td>
                                        <input type="text" id="txtSupplier" class="form-control" />

                                    </td>
                                    <td class="tdleft">
                                        <label>Người mua</label></td>
                                    <td>
                                        <%--<input type="text" id="txtBuyer" class="form-control" />--%>
                                        <select id="txtBuyer" class="form-control">
                                            <option></option>
                                            <option>Nguyễn Ngọc Lãm </option>
                                            <option>Đặng Thị Thùy Trang</option>
                                            <option>Huỳnh Trọng Tuấn</option>
                                            <option>Nguyễn Thị Thu</option>
                                            <option>Trần Ngọc Bình</option>
                                            <option>Thân thị Hằng</option>
                                            <option>Bùi Thị ThùyTrang</option>
                                            <option>Trần Dũng</option>
                                            <option>Hồ Thị Thanh Loan</option>
                                            <option>Phạm Thị Thu Hoài</option>
                                            <option>KO MOON JEONG</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Người nhận</label></td>
                                    <td>
                                        <%--<input type="text" id="txtReceiver" class="form-control" />--%>
                                        <div style="width: 250px;">
                                            <div style="width: 180px; margin-right: 10px;">
                                                <select id="txtReceiver" class="form-control">
                                                    <option>5 S</option>
                                                    <option>LSC</option>
                                                    <option>CAPL LINE</option>
                                                    <option>CARPENTER</option>
                                                    <option>CBL LINE</option>
                                                    <option>CITY WATER</option>
                                                    <option>CONSTRUCT</option>
                                                    <option>CRANE-FACTORY1</option>
                                                    <option>CRANE-FACTORY2</option>
                                                    <option>CTL #2 LINE</option>
                                                    <option>CPL LINE</option>
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
                                                    <option>PRODUCTION-SCRAP</option>
                                                    <option>PACKING-VHPC</option>
                                                    <option>ODER-VHPC</option>
                                                    <option>QC-LAB</option>
                                                    <option>Main (ME 1)</option>
                                                    <option>Main (ME 2)</option>
                                                    <option>Main (UTI 2 ME)</option>
                                                    <option>Main (CONS)</option>
                                                    <option>Main (EL 2)</option>
                                                    <option>Main (UTI 1 ME)</option>
                                                    <option>Main (EL 1)</option>
                                                    <option>Main (UTI 2 EL)</option>
                                                    <option>Others</option>
                                                </select>
                                            </div>
                                            <div style="width: 240px; margin-top: 3px" id="dvLine">
                                                <div style="width: 180px; float: left">
                                                    <input type="text" id="txtnguoinhan" class="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="tdleft">
                                        <label>Ghi chú</label>
                                    </td>
                                    <td>
                                        <textarea class="form-control" id="Remark" rows="2"></textarea>
                                    </td>
                                </tr>
                                <%----------thanh edit 02/05/2019----%>
                                <tr>
                                    <td class="tdleft">
                                        <label>Đã Kiểm</label></td>
                                    <td>
                                        <input type="checkbox" class="nhan" id="chkinpection" name="chkinpection" />

                                    </td>
                                    <%--------%>
                                    <td class="tdleft">
                                        <label>Ngày Kiểm</label></td>
                                    <td>
                                        <input type="text" id="InpectionDate" class="form-control" />

                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Người Kiểm</label></td>
                                    <td>
                                        <input id="Inpector" type="text" class="form-control" />
                                    </td>
                                    <%----------%>
                                    <td class="tdleft">
                                        <label>Kết quả Kiểm</label></td>
                                    <td>

                                        <input list="usage" id="InpectionResult" class="form-control" />
                                        <datalist id="usage">
                                            <option>ACCEPT</option>
                                            <option>RETURN</option>
                                        </datalist>
                                    </td>
                                    <%--  <td class="tdleft">
                                        <label>Kết quả Kiểm</label></td>
                                    <td>
                                         <input id="InpectionResult" type="text" class="form-control" />
                                    </td>--%>
                                </tr>
                                <%-------------------end thanh edit--%>
                                <tr>
                                    <%--<td class="tdleft"><label>Mã vạch</label></td><td><div id="dvbarcode"></div></td>--%>
                                    <td class="tdleft">
                                        <label>Vị trí(Locator)</label></td>
                                    <td>
                                        <input type="text" id="txtLocator" class="form-control" /></td>
                                    <td class="tdleft">
                                        <label>Đã nhận</label></td>
                                    <td>
                                        <input type="checkbox" id="chknhan" class="nhan" name="chknhan" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Mã vạch</label></td>
                                    <td colspan="3">
                                        <div id="dvbarcode"></div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnSave" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Lưu</button>
                        <button type="button" id="btnGenerate" class="btn btn-success">Tạo mã vạch</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="btnCancel" type="reset"><span class="glyphicon glyphicon-remove"></span>Đóng</button>
                        <%-- <button type="button" id="btnUpload" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Upload</button>--%>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!--modal edit list-->
    <!-- Modal -->
    <div class="modal fade" id="modalAllocate" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="H2"><span class="glyphicon glyphicon-user"></span>XUẤT KHO</h4>
                    <input type="hidden" id="hdQuantity" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="Form2" role="form">
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                        <label>Mã Qcode</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtQcode" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ngày nhập</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImport_Date" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ngày xuất</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtExportDate" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Số lượng trong kho</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtInvenQty" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Số lượng xuất</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtQuantity" autocomplete="off" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Tên Line</label></td>
                                    <td>
                                        <div style="width: 500px;">
                                            <div style="float: left; width: 180px; margin-right: 10px;">
                                                <select id="selLine" class="form-control">
                                                    <option>5 S</option>
                                                    <option>LSC</option>
                                                    <option>CAPL LINE</option>
                                                    <option>CARPENTER</option>
                                                    <option>CBL LINE</option>
                                                    <option>CITY WATER</option>
                                                    <option>CONSTRUCT</option>
                                                    <option>CRANE-FACTORY1</option>
                                                    <option>CRANE-FACTORY2</option>
                                                    <option>CTL #2 LINE</option>
                                                    <option>CPL LINE</option>
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
                                                    <option>PRODUCTION-SCRAP</option>
                                                    <option>PACKING-VHPC</option>
                                                    <option>ODER-VHPC</option>
                                                    <option>POSCO VHPC</option>
                                                    <option>QC-LAB</option>
                                                </select>
                                            </div>
                                            <div style="width: 240px; float: left" id="dvcode">
                                                <div class="tdleft" style="float: left; width: 80px; font-weight: bold; height: 35px; text-align: center">
                                                    <label>Code Center</label>
                                                </div>
                                                <div style="width: 150px; float: left">
                                                    <input type="text" id="txtCodeArea" class="form-control" />
                                                </div>
                                            </div>
                                            <div style="width: 240px; float: left" id="dvwork_common">
                                                <div class="tdleft" style="float: left; width: 80px; font-weight: bold; height: 35px; text-align: center">
                                                    <label>Code Center</label>
                                                </div>
                                                <div style="width: 150px; float: left; margin-left: 10px">
                                                    <select id="selCommon">
                                                        <option value=""></option>
                                                        <option value="VVH99-SUPPORT WORK COMMON">Main (CONS)</option>
                                                        <option value="VUA14-MAINTENANCE MECHANIC">Main (ME)</option>
                                                        <option value="VTA99-UTILITY COMMON">Main (UTI)</option>
                                                        <option value="VUA11-MAINTAINANCE EQUIPMENT ">Main (EL)</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Mã kế toán</label></td>
                                    <td>
                                        <%--<input type="text" class="form-control" id="txtCostAcount" />--%>
                                        <div style="width: 650px;">
                                            <div style="float: left; width: 180px; margin-right: 10px;">
                                                <select id="txtCostAcount" class="form-control" style="width: 180px">
                                                    <option></option>
                                                    <option>602011-0000</option>
                                                    <option>602021-0000</option>
                                                    <option>602031-0000</option>
                                                    <option>602041-0000</option>
                                                    <option>606191-2802</option>
                                                    <option>Others</option>
                                                </select>
                                            </div>
                                            <div style="width: 420px; float: left;" id="dvother">
                                                <div class="tdleft" style="float: left; width: 80px; font-weight: bold; height: 35px; text-align: center">
                                                    <label>Nhập mã</label>
                                                </div>
                                                <div style="width: 120px; float: left">
                                                    <input type="text" id="txtother" class="form-control" />
                                                </div>
                                                <div style="width: 50px; float: left; margin-left: 5px; font-weight: bold; height: 35px; text-align: center" class="tdleft">Note</div>
                                                <div style="width: 120px; margin-left: 5px">
                                                    <input type="text" id="txtNote1" class="form-control" />
                                                </div>
                                            </div>
                                            <div style="width: 300px; float: left;" id="dvNote">
                                                <div class="tdleft" style="float: left; width: 80px; font-weight: bold; height: 35px; text-align: center">
                                                    <label>Note</label>
                                                </div>
                                                <div style="float: left; width: 150px; margin-right: 10px;">
                                                    <select id="SelNote" class="form-control" style="width: 150px">
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Người yêu cầu</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtRequestor" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ghi chú</label></td>
                                    <td>
                                        <%--<input type="text" class="form-control" id="txtRemark" />--%>
                                        <div style="width: 500px;">
                                            <div style="float: left; width: 180px; margin-right: 10px;">
                                                <select id="txtRemark" class="form-control">
                                                    <option></option>
                                                    <option>Main (ME 1)</option>
                                                    <option>Main (ME 2)</option>
                                                    <option>Main (UTI 2 ME)</option>
                                                    <option>Main (CONS)</option>
                                                    <option>Main (EL 2)</option>
                                                    <option>Main (UTI 1 ME)</option>
                                                    <option>Main (EL 1)</option>
                                                    <option>Main (UTI 1 EL)</option>
                                                    <option>Main (UTI 2 EL)</option>
                                                    <option>Other</option>
                                                </select>
                                            </div>
                                            <div style="width: 300px; float: left;" id="dvRemark">
                                                <div style="width: 200px; margin-left: 5px">
                                                    <input type="text" id="txtRemark2" class="form-control" />
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Vị trí(locator)</label></td>
                                    <td>
                                        <input type="text" id="txtlocator" class="form-control" /></td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnOut" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Lưu thông tin</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button3" type="reset"><span class="glyphicon glyphicon-remove"></span>Thoát</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal import  -->
    <div class="modal fade" id="modalImport" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="H3"><span class="glyphicon glyphicon-user"></span>NHẬP KHO </h4>
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
                                        <input type="text" class="form-control" id="txtQty" required="required" autocomplete="off" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Giá(USD)</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtPrice" required="required" autocomplete="off" />
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
                                            <option>Nguyễn Ngọc Lãm</option>
                                            <option>Đặng Thị Thùy Trang</option>
                                            <option>Huỳnh Trọng Tuấn</option>
                                            <option>Nguyễn Thị Thu</option>
                                            <option>Trần Ngọc Bình</option>
                                            <option>Thân thị Hằng</option>
                                            <option>Bùi Thị ThùyTrang</option>
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
                                        <%--<input type="text" class="form-control" id="txtImp_Receiver" />--%>
                                        <div style="width: 250px;">
                                            <div style="width: 180px; margin-right: 10px; float: left">
                                                <select id="txtImp_Receiver" class="form-control">
                                                    <option>5 S</option>
                                                    <option>LSC</option>
                                                    <option>CAPL LINE</option>
                                                    <option>CARPENTER</option>
                                                    <option>CBL LINE</option>
                                                    <option>CITY WATER</option>
                                                    <option>CONSTRUCT</option>
                                                    <option>CRANE</option>
                                                    <option>CTL #2 LINE</option>
                                                    <option>CPL LINE</option>
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
                                                    <option>PRODUCTION-SCRAP</option>
                                                    <option>PACKING-VHPC</option>
                                                    <option>ODER-VHPC</option>
                                                    <option>QC-LAB</option>
                                                    <option>Main (ME 1)</option>
                                                    <option>Main (ME 2)</option>
                                                    <option>Main (UTI 2 ME)</option>
                                                    <option>Main (CONS)</option>
                                                    <option>Main (EL 2)</option>
                                                    <option>Main (UTI 1 ME)</option>
                                                    <option>Main (EL 1)</option>
                                                    <option>Main (UTI 2 EL)</option>
                                                    <option>Others</option>
                                                </select>
                                            </div>
                                            <div style="width: 180px; margin-top: 3px" id="dvImpLine">
                                                <input type="text" id="txtImpNhan" class="form-control" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Đã nhận</label></td>
                                    <td>
                                        <input type="checkbox" class="nhan" id="chknhan2" name="chknhan2" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Vị trí(Locator)</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtLocator2" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Đã Kiểm</label></td>
                                    <td>
                                        <input id="chkInsp" type="checkbox" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Ngày Kiểm</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtInspDt" style="width: 200px" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Người Kiểm</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtInspector" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Kết quả Kiểm</label></td>
                                    <td>
                                        <input list="result" class="form-control" id="InspectRes" />
                                        <datalist id="result">
                                            <option>ACCEPT</option>
                                            <option>RETURN</option>
                                        </datalist>
                                    </td>
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
    <!-- Modal -->
    <div class="modal fade" id="modalEditlist" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="H1"><span class="glyphicon glyphicon-user"></span>Update List Data</h4>
                    <input type="hidden" id="Hidden1" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="Form1" role="form">

                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                        <label>File Excel</label></td>
                                    <td>
                                        <input type="file" class="form-control" id="txtFile" required="required" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnEditList" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Save</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button2" type="reset"><span class="glyphicon glyphicon-remove"></span>Close</button>
                        <%-- <button type="button" id="btnUpload" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Upload</button>--%>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <%--  </form>--%>
    <script>
        (function (window, document, undefined) {
            "use strict";
            var myAutocomplete = new Autocomplete("Zone", {
                useNativeInterface: false,
                srcType: "dom"
            });
            var myAutocomplete = new Autocomplete("Location", {
                useNativeInterface: false,
                srcType: "dom"
            });
            var myAutocomplete = new Autocomplete("Unit", {
                useNativeInterface: false,
                srcType: "dom"
            });
        })(this, this.document);

        //$(function () {
        //    $('#txtPur_Date').datetimepicker({
        //        format: 'YYYY-MM-DD HH:mm'
        //    });
        //    $('#txtExportDate').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
        //    $('#txtImpDate,#txtInspDt').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
        //    $('#InpectionDate').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
        //});
    </script>
</asp:Content>
