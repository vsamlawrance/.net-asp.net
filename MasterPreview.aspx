<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MasterPreview.aspx.cs" Inherits="Main.MasterPreview" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Master Data Preview</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Added bg-light here -->
        <div class="container mt-5 bg-light p-4 rounded">
            <!-- Centered main title -->
            <h1 class="text-center mb-4">Employee Profile</h1>

            <asp:Label ID="lblMessage" runat="server" CssClass="text-center mb-3 d-block"></asp:Label>

            <h4 class="mb-3 mt-4">Personal Details</h4>
            <asp:GridView ID="gvEmployeeDetails" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>

            <h4 class="mb-3 mt-4">Compensation Details</h4>
            <asp:GridView ID="gvCompensationDetails" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>

            <h4 class="mb-3 mt-4">Current Job</h4>
            <asp:GridView ID="gvCurrentJob" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>

            <h4 class="mb-3 mt-4">Previous Employment</h4>
            <asp:GridView ID="gvPreviousEmployment" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>

            <h4 class="mb-3 mt-4">Job Details</h4>
            <asp:GridView ID="gvJobDetails" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>

            <h4 class="mb-3 mt-4">Education</h4>
            <asp:GridView ID="gvEducation" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>

            <h4 class="mb-3 mt-4">Family</h4>
            <asp:GridView ID="gvFamily" runat="server" AutoGenerateColumns="true" CssClass="table table-bordered mb-4"
                OnDataBound="GridView_OnDataBound"></asp:GridView>
        </div>
    </form>
</body>
</html>
