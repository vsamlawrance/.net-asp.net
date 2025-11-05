<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BusinessImpactData.aspx.cs" Inherits="Main.BusinessImpactData" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Business Impact Data Unit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .table td, .table th {
            vertical-align: middle;
            text-align: center;
        }
        .sub-item .particular-textbox {
            padding-left: 25px;
            font-style: normal;
        }
        .sno-cell {
            width: 50px;
        }
        .action-buttons {
            width: 180px;
        }
        .remove-btn {
            margin-left: 5px;
        }
        .add-btn-inline {
            margin-left: 5px;
            min-width: 100px;
        }
        .table-secondary {
            background-color: #f8f9fa !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="container mt-5">
        <h3 class="mb-4 text-center">Business Impact Data Unit</h3>

        <!-- Employee Name and Year Selection -->
        <div class="row mb-4">
            <div class="col-md-6">
                <label for="lblEmployeeName" class="form-label">Employee Name</label>
                <asp:Label ID="lblEmployeeName" runat="server" CssClass="form-control-plaintext"></asp:Label>
            </div>
            <div class="col-md-6">
                <label for="ddlYear" class="form-label">Select Year</label>
                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select"></asp:DropDownList>
            </div>
        </div>

        <asp:GridView ID="gvBusinessImpact" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered"
            OnRowCommand="gvBusinessImpact_RowCommand" OnRowDataBound="gvBusinessImpact_RowDataBound">
            <Columns>
                <asp:TemplateField HeaderText="S.No" ItemStyle-CssClass="sno-cell">
                    <ItemTemplate>
                        <%# Convert.ToInt32(Eval("SNo")) == 0 ? "" : Eval("SNo") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Particulars" ItemStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phParticularEdit" runat="server" />
                        <asp:Literal ID="litParticular" runat="server" Visible="false"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="UoM" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:TextBox ID="txtUoM" runat="server" CssClass="form-control"
                            Text='<%# Bind("UoM") %>' ReadOnly='<%# !(bool)Eval("IsSubItem") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="B Plan (Original)">
                    <ItemTemplate>
                        <asp:TextBox ID="txtBPlan" runat="server" CssClass="form-control" Text='<%# Bind("BPlan") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actual">
                    <ItemTemplate>
                        <asp:TextBox ID="txtActual" runat="server" CssClass="form-control" Text='<%# Bind("Actual") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Other Details">
                    <ItemTemplate>
                        <asp:TextBox ID="txtOtherDetails" runat="server" CssClass="form-control" Text='<%# Bind("OtherDetails") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Achievement %">
                    <ItemTemplate>
                        <asp:TextBox ID="txtAchievement" runat="server" CssClass="form-control" Text='<%# Bind("Achievement") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="action-buttons">
                    <ItemTemplate>
                        <asp:Button ID="btnAddPlantInline" runat="server" Text="Add Plant" CssClass="btn btn-sm btn-outline-primary add-btn-inline"
                            CommandName="AddPlant" CommandArgument='<%# Container.DataItemIndex %>' Visible="false" />

                        <asp:Button ID="btnAddCustomerInline" runat="server" Text="Add Customer" CssClass="btn btn-sm btn-outline-primary add-btn-inline"
                            CommandName="AddCustomer" CommandArgument='<%# Container.DataItemIndex %>' Visible="false" />

                        <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn btn-sm btn-danger remove-btn"
                            CommandName="RemoveRow" CommandArgument='<%# Container.DataItemIndex %>' Visible='<%# (bool)Eval("IsNewlyAdded") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <div class="text-center mt-4">
            <asp:Button ID="btnSubmit" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
        </div>

        <asp:Panel ID="pnlPreview" runat="server" CssClass="mt-5" Visible="false">
            <h4 class="text-center mb-3">Preview of Entered Data</h4>
            <asp:GridView ID="gvPreview" runat="server" CssClass="table table-bordered" AutoGenerateColumns="true" />
        </asp:Panel>
    </form>
</body>
</html>
