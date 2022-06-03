<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UploadData.aspx.cs" Inherits="MaterialManagement.UploadData" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <script src="Scripts/Default.js"></script>
    <script>
        $(document).ready(function () {
            
            $('#imgUpload').addClass("Addimg");
        });
    </script>
    <form runat="server">
    <div style="width:650px;margin-left:200px;">
         <div style="width:300px;margin:0 auto;color:#0e348e"><h2>Update List Data</h2></div>
        <table class="table table-bordered" style="margin-bottom: 10px;width:600px">
            <tbody>
                <tr>
                    <td class="tdleft">
                        <label>File Excel</label></td>
                    <td>
                     <asp:FileUpload runat="server" id="fupload"/>
                    </td>
                </tr>
                <tr><td></td><td><asp:Button runat="server" ID="btnUpDateList" Text="Update List" OnClick="btnUpDateList_Click" CssClass="btn btn-primary" /></td></tr>
            </tbody>
        </table>
    </div>
        <div style="width:650px;margin-left:200px;margin-top:50px">
             <div style="width:300px;margin:0 auto;color:#0e348e"><h2>Upload List Images  </h2></div>
            <table class="table table-bordered" style="margin-bottom: 10px;width:600px">
            <tbody>
                <tr>
                    <td class="tdleft">
                        <label>Image List</label></td>
                    <td>
                     <asp:FileUpload ID="image_upload" runat="server" AllowMultiple="true" />
                    </td>
                </tr>
                <tr><td></td><td><asp:Button ID="btnFileUpload" runat="server" Text="Upload" OnClick="btnFileUpload_Click" CssClass="btn btn-primary" /></td></tr>
            </tbody>
        </table>
    </div>
        </form>
</asp:Content>
