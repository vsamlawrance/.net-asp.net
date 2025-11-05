<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Main.Register" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
 
<body class="bg-light text-white d-flex align-items-center justify-content-center vh-100"
      style="background: url('images/banner.jpg') no-repeat center center fixed; background-size: cover;">
    <form id="form1" runat="server">
        <div class="login-box shadow-lg p-5 rounded-4 text-dark"
             style="width:400px; background-color: rgba(255, 255, 255, 0.85);">
            <h2 class="mb-4 text-center fw-bold">Register</h2>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
                <label for="txtUsername">Username</label>
            </div>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Email" />
                <label for="txtEmail">Email</label>
            </div>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" />
                <label for="txtPassword">Password</label>
            </div>
 
            <div class="form-floating mb-3">
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password" />
                <label for="txtConfirmPassword">Confirm Password</label>
            </div>
 
            <asp:Button ID="btnRegister" runat="server" CssClass="btn btn-primary w-100" Text="Register" OnClick="btnRegister_Click" />
             <div class="text-center">
     <a href ="Login.aspx" class="text-decoration-none">Back to Login</a>
     </div>
        </div>
    </form>
</body>
</html>
 