<%@ Page Title="" Language="C#" MasterPageFile="~/en/Site1.Master" AutoEventWireup="true" CodeBehind="EditUser_en.aspx.cs" Inherits="MaterialManagement.en.EditUser_en" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {

            $('#btnAdd').click(function () {

                var Username = $.trim($('#Username').val());
                var Role = $('#ddlRole').val();
                if (Username.length > 0) {
                    $.ajax({
                        url: '../Services/DefaultService.asmx/AddUser',
                        data: JSON.stringify({
                            Username: Username, Role: Role, Password: "123456"
                        }),
                        type: 'POST',
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        crossBrowser: true,
                        success: function (data, status) {
                            var rs = data.d;
                            if (rs > 0) {
                                bootbox.alert(status);
                                $('#frmAdd')[0].reset();
                            }
                            if (rs == -1) {
                                bootbox.alert("Username alredy exists!");
                                $('#frmAdd')[0].reset();
                            }
                            return false;
                        },
                        error: function (xhr, status, error) {
                            bootbox.alert("Error!" + xhr.status);
                        },
                    });
                }
                else {
                    bootbox.alert('Please enter username');
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div style="margin-top:100px">
        <h2>Edit Users</h2>
        <div class="panel panel-primary">
            <div class="panel-heading">Add New User</div>

            <div class="panel-body">
                <form class="form-horizontal" role="form" id="frmAdd" method="post">
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="id">New Username:</label>
                        <div class="col-sm-10">
                            <input type="text" id="Username" class="form-control" placeholder="Username" required="required" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="id">Role:</label>
                        <div class="col-sm-10">
                            <select id="ddlRole" class="form-control">
                                <option value="0">User</option>
                                <option value="1">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <button type="button" id="btnAdd" class="btn btn-primary">Add</button>
                            <button type="reset" class="btn btn-default">Cancel</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="panel-footer">The user password is 123456</div>
        </div>
        <hr />
        <div class="panel panel-primary">
            <div class="panel-heading">Reset Password</div>
            <div class="panel-body">
                <form runat="server" class="form-horizontal" role="form" id="Form1" method="post">
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="id">Username:</label>
                        <div class="col-sm-10">
                            <asp:DropDownList ID="ddlUsername" ClientIDMode="Static" runat="server" class="form-control"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <asp:Button ID="btnResetPassword" runat="server" Text="Reset" class="btn btn-primary" OnClick="btnResetPassword_Click" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="panel-footer">The password after reset is 123456</div>
        </div>
        </div>
    </div>
</asp:Content>
