<%@ Page Title="" Language="C#" MasterPageFile="~/en/Site1.Master" AutoEventWireup="true" CodeBehind="Default_en.aspx.cs" Inherits="MaterialManagement.en.Default_en" %>

<%@ Register Assembly="KeepAutomation.Barcode.Web" Namespace="KeepAutomation.Barcode.Web" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="Scripts/Default.js"></script>
    <style>
        option
        {
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
    <div style="margin-top: 2px; margin-left: 5px; margin-bottom: 5PX; font-size: larger; text-align: center; background-color: RGB(89,89,89); width: 290px; font-weight: bold; color: #15a19d; border: 2px solid #13a8bd">MRO INVENTORY LIST</div>
    <div class="table-responsive">
        <form id="frmSearch" class="form-inline" role="form" runat="server" defaultbutton="btnSearch">
            <asp:HiddenField ID="hdQuery" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="txtNow" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="hdbarcode" runat="server" ClientIDMode="Static" />
            <div>
                <div style="float: left; width: 740px;">
                    <div class="form-group">
                        <label for="location" style="color: RGB(0,87,137)">Search by</label>
                        <asp:DropDownList ID="drType" runat="server" CssClass="form-control" Width="180px">
                            <asp:ListItem>Item-Tên thiết bị</asp:ListItem>
                            <asp:ListItem>QCode-Mã thiết bị</asp:ListItem>
                            <asp:ListItem>Zone-Khu vực</asp:ListItem>
                            <asp:ListItem>Location-Vị trí</asp:ListItem>
                            <asp:ListItem>Spec-Mô tả</asp:ListItem>
                            <asp:ListItem>All-tất cả</asp:ListItem>
                            <%--<asp:ListItem>Unit</asp:ListItem>--%>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label for="location" style="color: RGB(0,87,137)">Value</label>
                        <asp:TextBox ID="txtQCode" ClientIDMode="Static" runat="server" CssClass="form-control" Width="170px"></asp:TextBox>
                    </div>
                    <asp:LinkButton ID="btnSearch"
                        runat="server"
                        CssClass="btn btn-primary" OnClick="btnSearch_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-search"></span>Search
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnExport"
                        runat="server"
                        CssClass="btn btn-primary" OnClick="btnExport_Click">
            <span aria-hidden="true" class="glyphicon glyphicon-export"></span>Export
                    </asp:LinkButton>
                </div>
                <div style="float: left; width: 540px; float: right;">
                    <div style="float: right;">
                        <%if (Session["USERNAME"] == null)
                          {%>
                        <button type="button" id="btnAdd" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-file"></span>New Import</button>
                        <button type="button" id="Button1" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-pencil"></span>Import - Number</button>
                        <button type="button" id="Button5" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-pencil"></span>Export</button>
                        <button type="button" id="btnModify" class="btn btn-primary" disabled="disabled">
                            <span class="glyphicon glyphicon-pencil"></span>Edit</button>
                        <button type="button" id="btnDelete" class="btn btn-danger" disabled="disabled">
                            <span class="glyphicon glyphicon-trash"></span>Delete</button>

                        <%}
                          else
                          { %>
                        <button type="button" id="btnAdd" class="btn btn-primary">
                            <span class="glyphicon glyphicon-file"></span>New Import</button>
                        <button type="button" id="btnImport" class="btn btn-primary">
                            <span class="glyphicon glyphicon-pencil"></span>Import-Number</button>
                        <button type="button" id="btnallocate" class="btn btn-primary">
                            <span class="glyphicon glyphicon-pencil"></span>Export</button>
                        <button type="button" id="btnModify" class="btn btn-primary">
                            <span class="glyphicon glyphicon-pencil"></span>Edit</button>
                        <button type="button" id="btnDelete" class="btn btn-danger">
                            <span class="glyphicon glyphicon-trash"></span>Delete</button>
                        <%} %>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <hr />

    <div id="tbData" class="table-responsive">
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
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <%--<div style="width: 100px; color: #f00; font-weight: bold; margin: 0 auto"><%=DTB.Rows.Count.ToString() + " dòng" %></div>--%>
    </div>
    <div class="modal fade" id="mdModify" role="dialog">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="padding: 35px 50px;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 id="title"><span class="glyphicon glyphicon-user"></span>Import</h4>
                    <input type="hidden" id="hdId" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="frmModify" role="form">
                        <input type="hidden" id="action" />
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                        <label>QCode</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="QCode" />
                                    </td>
                                    <td class="tdleft">
                                        <label>Khu vực</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="Zone" list="Zones" autocomplete="on" />
                                        <datalist id="Zones">
                                            <!--[if IE 9]><select disabled style="display:none"><![endif]-->
                                            <%if (Zones.Rows.Count > 0) %>
                                            <% for (int i = 0; i < Zones.Rows.Count; i++)
                                               {%>
                                            <option value="<%=Zones.Rows[i]["Zone"].ToString().Trim()%>" />
                                            <%} %>
                                            <!--[if IE 9]></select><![endif]-->
                                        </datalist>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Location</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="Location" list="Locations" autocomplete="on" />
                                        <datalist id="Locations">
                                            <!--[if IE 9]><select disabled style="display:none"><![endif]-->
                                            <%if (Loc.Rows.Count > 0) %>
                                            <% for (int i = 0; i < Loc.Rows.Count; i++)
                                               {%>
                                            <option value="<%=Loc.Rows[i]["Location"].ToString().Trim() %>" />
                                            <%} %>
                                            <!--[if IE 9]></select><![endif]-->
                                        </datalist>
                                    </td>
                                    <td class="tdleft">
                                        <label>Name</label></td>
                                    <td>
                                        <input type="text" id="Item" class="form-control" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Specs</label></td>
                                    <td>
                                        <textarea id="Spec" class="form-control"></textarea>
                                    </td>
                                    <td class="tdleft">
                                        <label>Unit</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="Unit" required="required" list="Units" autocomplete="on" />
                                        <datalist id="Units">
                                            <!--[if IE 9]><select disabled style="display:none"><![endif]-->
                                            <%if (Unit.Rows.Count > 0) %>
                                            <% for (int i = 0; i < Unit.Rows.Count; i++)
                                               {%>
                                            <option value="<%=Unit.Rows[i]["Unit"].ToString().Trim() %>" />
                                            <%} %>
                                            <!--[if IE 9]></select><![endif]-->
                                        </datalist>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>QTY</label></td>
                                    <td>
                                        <input type="number" id="Qty" class="form-control" required="required" />
                                    </td>
                                    <td class="tdleft">
                                        <label>Price (USD)</label>
                                    </td>
                                    <td>
                                        <input id="Price" class="form-control" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Import Date</label></td>
                                    <td>
                                        <input type="text" id="txtPur_Date" class="form-control" required="required" />
                                    </td>

                                    <td class="tdleft">
                                        <label>PO number</label></td>
                                    <td>
                                        <input id="txtPO" type="text" class="form-control" /></td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Supplier</label>
                                    </td>
                                    <td>
                                        <input type="text" id="txtSupplier" class="form-control" />
                                    </td>
                                    <td class="tdleft">
                                        <label>Buyer</label></td>
                                    <td>
                                        <%--<input type="text" id="txtBuyer" class="form-control" />--%>
                                        <select id="txtBuyer" class="form-control">
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
                                            <option>Phạm Thị Thu Hoài</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Reciever</label></td>
                                    <td>
                                        <%--<input type="text" id="txtReceiver" class="form-control" />--%>
                                        <div style="width: 250px;">
                                            <div style="width: 180px; margin-right: 10px;">
                                                <select id="txtReceiver" class="form-control">
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
                                                    <option>PRODUCTION-SCRAP</option>
                                                    <option>PACKING-VHPC</option>
                                                    <option>ODER-VHPC</option>
                                                    <option>QC-LBA</option>
                                                    <option>Others</option>
                                                </select>
                                            </div>
                                            <div style="width: 240px; margin-top: 3px" id="dvLine">
                                                <div style="width: 180px; float: left">
                                                    <input type="text" id="txtnguoinhan" class="form-control" /></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="tdleft">
                                        <label>Note</label>
                                    </td>
                                    <td>
                                        <textarea class="form-control" id="Remark" rows="2"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Bar code</label></td>
                                    <td>
                                        <div id="dvbarcode"></div>
                                    </td>
                                    <td class="tdleft">
                                        <label>Recieved</label></td>
                                    <td>
                                        <input type="checkbox" id="chknhan" class="nhan" name="chknhan" /></td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnSave" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Save</button>
                        <button type="button" id="btnGenerate" class="btn btn-success">Create Barcode</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="btnCancel" type="reset"><span class="glyphicon glyphicon-remove"></span>Close</button>

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
                    <h4 id="H2"><span class="glyphicon glyphicon-user"></span>Export</h4>
                    <input type="hidden" id="hdQuantity" />
                </div>
                <div class="modal-body" style="padding: 40px 50px;">
                    <form id="Form2" role="form">
                        <table class="table table-bordered" style="margin-bottom: 5px;">
                            <tbody>
                                <tr>
                                    <td class="tdleft">
                                        <label>Qcode</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtQcode" />
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
                                        <input type="text" class="form-control" id="txtExportDate" />
                                    </td>
                                </tr>

                                <tr>
                                    <td class="tdleft">
                                        <label>Stock Quantity</label></td>
                                    <td>
                                        <input type="number" class="form-control" id="txtInvenQty" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Export Quantity</label></td>
                                    <td>
                                        <input type="number" class="form-control" id="txtQuantity" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Line</label></td>
                                    <td>
                                        <div style="width: 500px;">
                                            <div style="float: left; width: 180px; margin-right: 10px;">
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
                                                    <option>PRODUCTION-SCRAP</option>
                                                    <option>PACKING-VHPC</option>
                                                    <option>ODER-VHPC</option>
                                                    <option>QC-LBA</option>
                                                </select>
                                            </div>
                                            <div style="width: 240px; float: left" id="dvcode">
                                                <div class="tdleft" style="float: left; width: 80px; font-weight: bold; height: 35px; text-align: center">
                                                    <label>Code Center</label></div>
                                                <div style="width: 150px; float: left">
                                                    <input type="text" id="txtCodeArea" class="form-control" /></div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Code Account</label></td>
                                    <td>
                                        <%--<input type="text" class="form-control" id="txtCostAcount" />--%>
                                        <div style="width: 500px;">
                                            <div style="float: left; width: 130px; margin-right: 10px;">
                                                <select id="txtCostAcount" class="form-control" style="width: 130px">
                                                    <option></option>
                                                    <option>602011-0000</option>
                                                    <option>602021-0000</option>
                                                    <option>602031-0000</option>
                                                    <option>602041-0000</option>
                                                    <option>606191-2802</option>
                                                    <option>Others</option>
                                                </select>
                                            </div>
                                            <div style="width: 200px; float: left" id="dvother">
                                                <div class="tdleft" style="float: left; width: 80px; font-weight: bold; height: 35px; text-align: center">
                                                    <label>Code</label></div>
                                                <div style="width: 120px; float: left">
                                                    <input type="text" id="txtother" class="form-control" /></div>
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
                        <button type="submit" id="btnOut" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Save</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button6" type="reset"><span class="glyphicon glyphicon-remove"></span>Close</button>
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
                    <h4 id="H3"><span class="glyphicon glyphicon-user"></span>Import </h4>
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
                                        <label>Import date</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImpDate" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Quantity</label></td>
                                    <td>
                                        <input type="number" class="form-control" id="txtQty" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Price(USD)</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtPrice" required="required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Po number</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtPo" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Supplier</label></td>
                                    <td>
                                        <input type="text" class="form-control" id="txtImp_Supplier" />
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
                                            <option>Phạm Thị Thu Hoài</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdleft">
                                        <label>Requestor</label></td>
                                    <td>
                                        <div style="width: 250px;">
                                            <div style="width: 180px; margin-right: 10px; float: left">
                                                <select id="txtImp_Receiver" class="form-control">
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
                                                    <option>PRODUCTION-SCRAP</option>
                                                    <option>PACKING-VHPC</option>
                                                    <option>ODER-VHPC</option>
                                                    <option>QC-LBA</option>
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
                                        <label>Recieved</label></td>
                                    <td>
                                        <input type="checkbox" class="nhan" id="chknhan2" name="chknhan2" /></td>
                                </tr>
                            </tbody>
                        </table>
                        <button type="submit" id="btnImpSave" class="btn btn-primary"><span class="glyphicon glyphicon-floppy-disk"></span>Save</button>
                        <button class="btn btn-danger" data-dismiss="modal" id="Button7" type="reset"><span class="glyphicon glyphicon-remove"></span>Exit</button>
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
                        <button class="btn btn-danger" data-dismiss="modal" id="Button8" type="reset"><span class="glyphicon glyphicon-remove"></span>Close</button>
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
    </script>
</asp:Content>
