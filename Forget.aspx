<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Forget.aspx.cs" Inherits="Main.Forget" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100"
    style="background: url('images/banner.jpg') no-repeat center center fixed; background-size: cover;">
    <form id="form1" runat="server">
<div class="login-box shadow-lg p-5 rounded-4 text-dark" style="width:400px; background-color: rgba(255, 255, 255, 0.85);">
            <h2 class="mb-4 text-center fw-bold">Reset Password</h2>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
                <label for="txtUsername">Username</label>
            </div>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="New Password" />
                <label for="txtNewPassword">New Password</label>
            </div>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password" />
                <label for="txtConfirmPassword">Confirm Password</label>
            </div>
 
            <asp:Label ID="lblMessage" runat="server" CssClass="text-danger d-block mb-2"></asp:Label>
 
            <asp:Button ID="btnReset" runat="server" CssClass="btn btn-primary w-100" Text="Reset Password" OnClick="btnReset_Click" />
       <div class="text-center">
   <a href ="Login.aspx" class="text-decoration-none">Back to Login</a>
   </div>
   
        </div>
    </form>
</body>
</html>