<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MaterialManagement.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head id="Head1" runat="server">
    <title>Login</title>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <!-- Bootstrap -->
    <link rel="stylesheet" href="Content/bt/bootstrap.min.css" />
    <link rel="stylesheet" href="Content/login.css" />
    <link href="Content/jquery.form.css" rel="stylesheet" />
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="Scripts/Include/html5shiv.min.js"></script>
      <script src="Scripts/Include/respond.min.js"></script>
        <script src="Scripts/Include/jquery-1.8.3.js"></script>
        <script type='text/javascript' src='//cdnjs.cloudflare.com/ajax/libs/jquery-ajaxtransport-xdomainrequest/1.0.3/jquery.xdomainrequest.min.js'></script>
    <![endif]-->
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="Scripts/Include/jquery-1.11.3.min.js"></script>
    <script src="Scripts/Include/bootstrap.min.js"></script>
    <script src="Scripts/Include/ie10-viewport-bug-workaround.js"></script>
    <script src="Scripts/jquery.xdomainrequest.min.js"></script>
    <script src="Scripts/Include/jquery.backstretch.min.js"></script>
    <script>
        $(document).ready(function () {
            $.backstretch("Content/img/warehouse.jpg");
        });
    </script>
</head>
<body>
    <form id="form1" runat="server" class="form-signin">
        <h2 class="form-signin-heading">Please sign in</h2>
        <label for="inputEmail" class="sr-only">Email address</label>
        <asp:TextBox ID="txtEmID" runat="server" class="form-control" placeholder="Username" autofocus="autofocus" required="required"></asp:TextBox>
        <label for="inputPassword" class="sr-only">Password</label>
        <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" class="form-control" placeholder="Password" required="required"></asp:TextBox>
        <div style="float:left;width:70px;margin-top:10px"><label>Language</label></div><div style="margin-left:5px;width:220px;float:left"><asp:DropDownList runat="server" ID="dropLang" CssClass="form-control"><asp:ListItem>VietNamese</asp:ListItem><asp:ListItem>English</asp:ListItem></asp:DropDownList></div>
        <asp:Button ID="btnLogin" runat="server" Text="Sign In" class="btn btn-lg btn-primary btn-block" OnClick="btnLogin_Click"  />
    </form>
</body>
</html>
