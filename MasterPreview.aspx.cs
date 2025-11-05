using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace Main
{
    public partial class MasterPreview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["EmployeeId"] == null)
                {
                    lblMessage.Text = "Session expired. Please login again.";
                    lblMessage.CssClass = "text-danger fw-bold";
                    return;
                }

                int employeeId = Convert.ToInt32(Session["EmployeeId"]);
                LoadMasterData(employeeId);

                // Attach GridView OnDataBound handlers
                AttachGridViewDataBoundHandlers();
            }
        }

        private void AttachGridViewDataBoundHandlers()
        {
            gvEmployeeDetails.DataBound += GridView_OnDataBound;
            gvCompensationDetails.DataBound += GridView_OnDataBound;
            gvCurrentJob.DataBound += GridView_OnDataBound;
            gvPreviousEmployment.DataBound += GridView_OnDataBound;
            gvJobDetails.DataBound += GridView_OnDataBound;
            gvEducation.DataBound += GridView_OnDataBound;
            gvFamily.DataBound += GridView_OnDataBound;
        }

        private void LoadMasterData(int employeeId)
        {
            try
            {
                gvEmployeeDetails.DataSource = GetEmployeeDetails(employeeId);  // Shows everything
                gvEmployeeDetails.DataBind();

                gvCompensationDetails.DataSource = GetCompensationDetails(employeeId); // Hides EmployeeCode and CreatedDate
                gvCompensationDetails.DataBind();

                gvCurrentJob.DataSource = GetCurrentJobDetails(employeeId);
                gvCurrentJob.DataBind();

                gvPreviousEmployment.DataSource = GetPreviousEmploymentDetails(employeeId);
                gvPreviousEmployment.DataBind();

                gvJobDetails.DataSource = GetJobDetails(employeeId);
                gvJobDetails.DataBind();

                gvEducation.DataSource = GetEducationalDetails(employeeId);
                gvEducation.DataBind();

                gvFamily.DataSource = GetFamilyDetails(employeeId);
                gvFamily.DataBind();

                //lblMessage.Text = "Employee Profile";
                //lblMessage.CssClass = "text-success fw-bold";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading master data: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }

        // Your existing data fetching methods here...

        private DataTable GetEmployeeDetails(int employeeId)
        {
            string query = "SELECT EmployeeCode, FullName, Grade, Designation, DateOfBirth, Age, Gender, DateOfJoining, CTC, BusinessUnit FROM Employee_Details WHERE EmployeeCode = @Id"; // include all
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetCompensationDetails(int employeeId)
        {
            string query = "SELECT Year, CTCIncreasePercent, PMS_Year, PMS_Percentage, PromotionDate, Grade FROM Emp_Compensation_Details WHERE EmployeeCode = @Id";
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetCurrentJobDetails(int employeeId)
        {
            string query = "SELECT Position, Job, Grade, City, WorkExperience  FROM CurrentJobDetails WHERE EmployeeCode = @Id";
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetPreviousEmploymentDetails(int employeeId)
        {
            string query = "SELECT Organization, Job, FromDate, ToDate, WorkExperience, City FROM PreviousEmploymentDetails WHERE EmployeeCode = @Id";
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetJobDetails(int employeeId)
        {
            string query = "SELECT DateOfJoining, InternalExperience, ExternalExperience FROM JobDetails WHERE EmployeeCode = @Id";
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetEducationalDetails(int employeeId)
        {
            string query = "SELECT EducationCategory, EducationType, Specialization, Institute, University, StudyMode, FromDate, ToDate, IsHighestEducation FROM EducationalDetails WHERE EmployeeCode = @Id";
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetFamilyDetails(int employeeId)
        {
            string query = "SELECT FirstName, LastName, Relationship, Gender, DateOfBirth, Nationality, Occupation FROM FamilyDetails WHERE EmployeeId = @Id";
            return GetDataTable(employeeId, query, "@Id");
        }

        private DataTable GetDataTable(int employeeId, string query, string paramName)
        {
            DataTable dt = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue(paramName, employeeId);
                    con.Open();

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        private string SplitCamelCase(string input)
        {
            if (string.IsNullOrEmpty(input)) return input;
            return Regex.Replace(input, "(?<!^)(?=[A-Z][a-z])", " ");
        }

        protected void GridView_OnDataBound(object sender, EventArgs e)
        {
            GridView gv = sender as GridView;
            if (gv?.HeaderRow != null)
            {
                // Add spaces in header names
                for (int i = 0; i < gv.HeaderRow.Cells.Count; i++)
                {
                    string originalText = gv.HeaderRow.Cells[i].Text;
                    gv.HeaderRow.Cells[i].Text = SplitCamelCase(originalText);
                }
            }

            if (gv?.Rows != null)
            {
                // List of date column names to format without time
                string[] dateColumns = { "DateOfJoining", "FromDate", "ToDate", "DateOfBirth", "PromotionDate" };

                // Find indexes of columns with those names in header
                var dateColumnIndexes = new System.Collections.Generic.List<int>();

                for (int i = 0; i < gv.HeaderRow.Cells.Count; i++)
                {
                    string headerText = gv.HeaderRow.Cells[i].Text.Replace(" ", ""); // Remove spaces for matching
                    foreach (var dc in dateColumns)
                    {
                        if (headerText.Equals(dc, StringComparison.OrdinalIgnoreCase))
                        {
                            dateColumnIndexes.Add(i);
                            break;
                        }
                    }
                }

                // Format each cell in those columns for every row
                foreach (GridViewRow row in gv.Rows)
                {
                    foreach (int colIndex in dateColumnIndexes)
                    {
                        if (DateTime.TryParse(row.Cells[colIndex].Text, out DateTime dtValue))
                        {
                            row.Cells[colIndex].Text = dtValue.ToString("yyyy-MM-dd");
                        }
                    }
                }
            }
        }
    }
}
