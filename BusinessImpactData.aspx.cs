using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Main.Models;

namespace Main
{
    public partial class BusinessImpactData : System.Web.UI.Page
    {
        private const string ViewStateKey = "BusinessImpactData";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set Employee Name from session
                var employeeName = Session["EmployeeName"] as string ?? "Unknown Employee";
                lblEmployeeName.Text = employeeName;

                // Populate Year dropdown with last 5 financial years, default selected current year
                PopulateYearDropdown();

                var data = GetInitialData();
                ViewState[ViewStateKey] = data;
                BindGrid();
            }
        }

        private void PopulateYearDropdown()
        {
            ddlYear.Items.Clear();

            int startYear;
            int currentMonth = DateTime.Now.Month;

            // Financial year logic: if current month < April, current FY started last year
            if (currentMonth < 4)
                startYear = DateTime.Now.Year - 1;
            else
                startYear = DateTime.Now.Year;

            for (int i = 0; i < 5; i++)
            {
                int fromYear = startYear - i;
                int toYear = fromYear + 1;
                string fyText = $"{fromYear}-{toYear}";

                ddlYear.Items.Add(new ListItem(fyText, fyText));
            }

            // Select current financial year by default
            ddlYear.SelectedIndex = 0;
        }

        private List<BusinessImpactRow> GetInitialData()
        {
            var data = new List<BusinessImpactRow>
            {
                new BusinessImpactRow { SNo = 1, Particular = "Cost Savings", UoM = "Rs Crs", IsSubItem = false },
                new BusinessImpactRow { SNo = 2, Particular = "Customer Complaints", UoM = "Nos", IsSubItem = false },
                new BusinessImpactRow { SNo = 3, Particular = "Rejections ( average of 12 months )", UoM = "", IsSubItem = false },
                new BusinessImpactRow { Particular = "Plant 1", UoM = "%", IsSubItem = true },
                new BusinessImpactRow { SNo = 4, Particular = "Key Indicators", UoM = "", IsSubItem = false },
                new BusinessImpactRow { Particular = "Sales", UoM = "Rs Crs", IsSubItem = true },
                new BusinessImpactRow { Particular = "CTC", UoM = "Rs", IsSubItem = true },
                new BusinessImpactRow { Particular = "Contribution", UoM = "Rs Crs", IsSubItem = true },
                new BusinessImpactRow { Particular = "Contribution", UoM = "%", IsSubItem = true },
                new BusinessImpactRow { Particular = "PBT", UoM = "Rs Crs", IsSubItem = true },
                new BusinessImpactRow { Particular = "PBT", UoM = "%", IsSubItem = true },
                new BusinessImpactRow { Particular = "ROCE (PBIT)", UoM = "%", IsSubItem = true },
                new BusinessImpactRow { Particular = "Sales per employee", UoM = "Rs L", IsSubItem = true },
                new BusinessImpactRow { SNo = 5, Particular = "Awards", UoM = "", IsSubItem = false },
                new BusinessImpactRow { Particular = "Domestic", UoM = "", IsSubItem = true },
                new BusinessImpactRow { Particular = "Exports", UoM = "", IsSubItem = true },
                new BusinessImpactRow { SNo = 6, Particular = "New Customers", UoM = "", IsSubItem = false },
                new BusinessImpactRow { Particular = "Customer 1", UoM = "Rs Crs", IsSubItem = true },
                new BusinessImpactRow { SNo = 7, Particular = "S & OP", UoM = "", IsSubItem = false },
                new BusinessImpactRow { Particular = "Inventory", UoM = "Turns", IsSubItem = true },
                new BusinessImpactRow { Particular = "Receivables", UoM = "Days", IsSubItem = true },
                new BusinessImpactRow { SNo = 8, Particular = "NPD ( rolling 3 year value )", UoM = "", IsSubItem = false },
                new BusinessImpactRow { Particular = "No of Parts", UoM = "Nos", IsSubItem = true },

                new BusinessImpactRow { SNo = 9, Particular = "New Business", UoM = "", IsSubItem = false }
            };

            RecalculateSNo(data);
            return data;
        }



        private void RecalculateSNo(List<BusinessImpactRow> data)
        {
            int sn = 1;
            foreach (var row in data)
            {
                row.SNo = row.IsSubItem ? 0 : sn++;
            }
        }

        private void BindGrid()
        {
            var data = ViewState[ViewStateKey] as List<BusinessImpactRow>;
            gvBusinessImpact.DataSource = data;
            gvBusinessImpact.DataBind();
        }

        protected void gvBusinessImpact_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var data = (BusinessImpactRow)e.Row.DataItem;

                var placeholder = (PlaceHolder)e.Row.FindControl("phParticularEdit");
                var literal = (Literal)e.Row.FindControl("litParticular");

                if (data.IsSubItem)
                {
                    // Show editable textbox for subitems
                    var txt = new TextBox
                    {
                        ID = "txtParticular",
                        Text = data.Particular,
                        CssClass = "form-control particular-textbox"
                    };
                    placeholder.Controls.Add(txt);
                    literal.Visible = false;
                }
                else
                {
                    // Show plain text for main items
                    literal.Text = data.Particular;
                    literal.Visible = true;
                    placeholder.Visible = false;
                }

                // Show Add Plant button only on first Plant row
                var btnAddPlant = (Button)e.Row.FindControl("btnAddPlantInline");
                if (btnAddPlant != null)
                {
                    btnAddPlant.Visible = data.Particular.StartsWith("Plant 1");
                }

                // Show Add Customer button only on first Customer row
                var btnAddCustomer = (Button)e.Row.FindControl("btnAddCustomerInline");
                if (btnAddCustomer != null)
                {
                    btnAddCustomer.Visible = data.Particular.StartsWith("Customer 1");
                }

                // Title rows to make non-editable and show '-' in cells
                var titleRows = new[] {
            "Rejections ( average of 12 months )",
            "Key Indicators",
            "Awards",
            "New Customers",
            "S & OP",
            "NPD ( rolling 3 year value )"
        };

                if (titleRows.Contains(data.Particular))
                {
                    foreach (TableCell cell in e.Row.Cells)
                    {
                        foreach (Control ctrl in cell.Controls)
                        {
                            if (ctrl is TextBox tb)
                            {
                                tb.Text = "           ------";    // Replace content with dash
                                tb.ReadOnly = true;
                            }
                            else if (ctrl is Button btn)
                            {
                                btn.Enabled = false;
                            }
                        }

                        // If cell has no controls (e.g. literals), set text to dash
                        if (cell.Controls.Count == 0)
                        {
                            cell.Text = "-";
                        }
                    }

                    // Optional styling for title rows
                    e.Row.CssClass = "table-secondary fw-bold";
                }
            }
        }



        protected void gvBusinessImpact_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var data = ViewState[ViewStateKey] as List<BusinessImpactRow>;

            if (e.CommandName == "RemoveRow")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < data.Count && data[index].IsNewlyAdded)
                {
                    data.RemoveAt(index);
                    RecalculateSNo(data);
                    ViewState[ViewStateKey] = data;
                    BindGrid();
                }
            }
            else if (e.CommandName == "AddPlant")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                AddNewSubItemAt(data, "Plant", index);
            }
            else if (e.CommandName == "AddCustomer")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                AddNewSubItemAt(data, "Customer", index);
            }
        }

        private void AddNewSubItemAt(List<BusinessImpactRow> data, string type, int index)
        {
            SaveGridValuesToViewState();

            // Find last existing Plant or Customer after the clicked index
            int insertIndex = index;
            for (int i = index + 1; i < data.Count; i++)
            {
                if (!data[i].Particular.StartsWith(type))
                {
                    insertIndex = i - 1;
                    break;
                }
                insertIndex = i;
            }

            int countExisting = data.Count(d => d.Particular.StartsWith(type));
            string newParticular = $"{type} {countExisting + 1}";

            var newRow = new BusinessImpactRow
            {
                SNo = 0,
                Particular = newParticular,
                UoM = type == "Plant" ? "%" : "Rs Crs",
                IsSubItem = true,
                IsNewlyAdded = true
            };

            data.Insert(insertIndex + 1, newRow);
            RecalculateSNo(data);
            ViewState[ViewStateKey] = data;
            BindGrid();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveGridValuesToViewState();

            var data = ViewState[ViewStateKey] as List<BusinessImpactRow>;
            pnlPreview.Visible = true;
            gvPreview.DataSource = data;
            gvPreview.DataBind();
        }

        private void SaveGridValuesToViewState()
        {
            var data = ViewState[ViewStateKey] as List<BusinessImpactRow>;

            for (int i = 0; i < gvBusinessImpact.Rows.Count; i++)
            {
                var row = gvBusinessImpact.Rows[i];
                var model = data[i];

                if (model.IsSubItem)
                {
                    var tbParticular = (TextBox)row.FindControl("txtParticular");
                    if (tbParticular != null)
                        model.Particular = tbParticular.Text.Trim();
                }

                var txtUoM = (TextBox)row.FindControl("txtUoM");
                if (txtUoM != null)
                    model.UoM = txtUoM.Text.Trim();

                var txtBPlan = (TextBox)row.FindControl("txtBPlan");
                if (txtBPlan != null)
                    model.BPlan = txtBPlan.Text.Trim();

                var txtActual = (TextBox)row.FindControl("txtActual");
                if (txtActual != null)
                    model.Actual = txtActual.Text.Trim();

                var txtOtherDetails = (TextBox)row.FindControl("txtOtherDetails");
                if (txtOtherDetails != null)
                    model.OtherDetails = txtOtherDetails.Text.Trim();

                var txtAchievement = (TextBox)row.FindControl("txtAchievement");
                if (txtAchievement != null)
                    model.Achievement = txtAchievement.Text.Trim();
            }

            ViewState[ViewStateKey] = data;
        }

        // Register event validation for dynamic commands
        protected override void Render(HtmlTextWriter writer)
        {
            var data = ViewState[ViewStateKey] as List<BusinessImpactRow>;

            if (data != null)
            {
                for (int i = 0; i < gvBusinessImpact.Rows.Count; i++)
                {
                    Page.ClientScript.RegisterForEventValidation(gvBusinessImpact.UniqueID, $"RemoveRow${i}");
                    Page.ClientScript.RegisterForEventValidation(gvBusinessImpact.UniqueID, $"AddPlant${i}");
                    Page.ClientScript.RegisterForEventValidation(gvBusinessImpact.UniqueID, $"AddCustomer${i}");
                }
            }

            base.Render(writer);
        }
    }
}
