<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Main.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>

<!--Background  -->
<body class="bg-light text-white d-flex align-items-center justify-content-center vh-100"
      style="background: url('images/banner.jpg') no-repeat center center fixed; background-size: cover;">
      
    <form id="form1" runat="server">
<div class="login-box shadow-lg p-5 rounded-4 text-dark" style="width:400px; background-color: rgba(255, 255, 255, 0.85);">
            <h2 class="mb-4 text-center fw-bold">Log In</h2>

            <div class="form-floating mb-3">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
                <label for="txtUsername">Username</label>
            </div>

            <div class="form-floating mb-3 position-relative">
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" />
                <label for="txtPassword">Password</label>
                <span class="password-toggle" onclick="togglePassword()"></span>
            </div>
    <div class="text-center">
        <a href="Forget.aspx" class =" text-decoration-none">Forget Password?</a>
    </div>

        

            <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-primary w-100" Text="Login" OnClick="btnLogin_Click" />
    <div class="text-center">
        <span> New User?</span>
        <a href ="Register.aspx" class="text-decoration-none">Register Here</a>
        </div>

        </div>
    </form>

   
</body>
</html>
