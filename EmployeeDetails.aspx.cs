using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Main
{
    public partial class EmployeeDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initially hide compensation section
                viewCompensation.Style["display"] = "none";

                // Optionally, if EmployeeId session exists, show compensation section
                if (Session["EmployeeId"] != null)
                {
                    viewCompensation.Style["display"] = "block";
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Validate Employee Code
                string employeeCode = txtEmployeeCode.Text.Trim();
                if (string.IsNullOrEmpty(employeeCode))
                {
                    ShowError("Employee Code is required.");
                    return;
                }

                // 2. Get other form values
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string grade = txtGrade.Text.Trim();
                string designation = txtDesignation.Text.Trim();

                // 3. Validate Date of Birth
                if (!DateTime.TryParse(txtDateOfBirth.Text.Trim(), out DateTime dateOfBirth))
                {
                    ShowError("Date of Birth must be a valid date.");
                    return;
                }

                int age = CalculateAge(dateOfBirth);

                // 4. Validate Gender
                string gender = ddlGender.SelectedValue;
                if (string.IsNullOrEmpty(gender))
                {
                    ShowError("Please select a gender.");
                    return;
                }

                // 5. Validate Date of Joining
                if (!DateTime.TryParse(txtDateOfJoining.Text.Trim(), out DateTime dateOfJoining))
                {
                    ShowError("Date of Joining must be a valid date.");
                    return;
                }

                // 6. Validate CTC
                if (!decimal.TryParse(txtCTC.Text.Trim(), out decimal ctc))
                {
                    ShowError("CTC must be a valid decimal number.");
                    return;
                }

                string businessUnit = txtBusinessUnit.Text.Trim();

                // 7. Handle uploaded image
                byte[] imageBytes = null;
                if (fuEmployeeImage.HasFile)
                {
                    using (BinaryReader br = new BinaryReader(fuEmployeeImage.PostedFile.InputStream))
                    {
                        imageBytes = br.ReadBytes(fuEmployeeImage.PostedFile.ContentLength);
                    }
                }

                // 8. Insert/Update into database
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("usp_InsertUpdatePersonal_Details", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@EmployeeCode", employeeCode);
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@EmailID", email);
                    cmd.Parameters.AddWithValue("@Grade", grade);
                    cmd.Parameters.AddWithValue("@Designation", designation);
                    cmd.Parameters.AddWithValue("@DateOfBirth", dateOfBirth);
                    cmd.Parameters.AddWithValue("@Age", age);
                    cmd.Parameters.AddWithValue("@Gender", gender);
                    cmd.Parameters.AddWithValue("@DateOfJoining", dateOfJoining);
                    cmd.Parameters.AddWithValue("@CurrentCTC", ctc);
                    cmd.Parameters.AddWithValue("@BusinessUnit", businessUnit);
                    cmd.Parameters.AddWithValue("@EmployeeImage", imageBytes ?? (object)DBNull.Value);

                    // Stored Procedure requires CreatedDate and CreatedTime for INSERT
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now.Date);
                    cmd.Parameters.AddWithValue("@CreatedTime", DateTime.Now.TimeOfDay);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

                // 9. Store EmployeeId in session
                Session["EmployeeId"] = employeeCode;

                // 10. Show success message
                ShowSuccess("Personal details saved successfully.");

                // 11. Show compensation section immediately after save
                string script = @"
            document.getElementById('view-compensation').style.display = 'block';
            document.getElementById('view-compensation').scrollIntoView({ behavior: 'smooth' });
        ";
                ScriptManager.RegisterStartupScript(this, GetType(), "showCompensationSection", script, true);
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        // Helper method to calculate age
        private int CalculateAge(DateTime birthDate)
        {
            var today = DateTime.Today;
            int age = today.Year - birthDate.Year;
            if (birthDate > today.AddYears(-age)) age--;
            return age;
        }

        // Show SweetAlert error message
        private void ShowError(string message)
        {
            string script = $@"
        Swal.fire({{
            icon: 'error',
            title: 'Error',
            text: '{message.Replace("'", "\\'")}',
            confirmButtonColor: '#d33'
        }});
    ";
            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
        }

        // Show SweetAlert success message
        private void ShowSuccess(string message)
        {
            string script = $@"
        Swal.fire({{
            icon: 'success',
            title: 'Success',
            text: '{message.Replace("'", "\\'")}',
            confirmButtonColor: '#3085d6'
        }});
    ";
            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
        }

        // Optional: clear form inputs
        private void ClearForm()
        {
            txtEmployeeCode.Text = "";
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtGrade.Text = "";
            txtDesignation.Text = "";
            txtDateOfBirth.Text = "";
            txtAge.Text = "";
            ddlGender.SelectedIndex = 0;
            txtDateOfJoining.Text = "";
            txtCTC.Text = "";
            txtBusinessUnit.Text = "";
            // FileUpload cannot be cleared programmatically
        }



        protected void btnSaveCompensation_Click(object sender, EventArgs e)
        {
            if (Session["EmployeeId"] == null)
            {
                ShowSweetAlert("Error", "Employee not found in session.", "error");
                return;
            }

            int employeeCode = Convert.ToInt32(Session["EmployeeId"]);

            try
            {
                // === 1. Parse Compensation ===
                string[] years = Request.Form.GetValues("compYear");
                string[] ctcs = Request.Form.GetValues("compCTC");
                string[] increases = Request.Form.GetValues("compIncrease");

                var yearDataDict = new Dictionary<int, EmpYearData>();

                if (years != null && ctcs != null && increases != null)
                {
                    for (int i = 0; i < years.Length; i++)
                    {
                        if (!int.TryParse(years[i], out int year)) continue;
                        if (!decimal.TryParse(ctcs[i], out decimal ctc)) continue;
                        if (!decimal.TryParse(increases[i], out decimal increase)) continue;

                        if (!yearDataDict.ContainsKey(year))
                            yearDataDict[year] = new EmpYearData { Year = year };

                        yearDataDict[year].CTC = ctc;
                        yearDataDict[year].IncreasePercent = increase;
                    }
                }

                // === 2. Parse PMS Ratings ===
                string[] pmsYears = Request.Form.GetValues("pmsYear");
                string[] pmsPercentages = Request.Form.GetValues("pmsPercentage");

                if (pmsYears != null && pmsPercentages != null)
                {
                    for (int i = 0; i < pmsYears.Length; i++)
                    {
                        if (!int.TryParse(pmsYears[i], out int year)) continue;
                        if (!decimal.TryParse(pmsPercentages[i], out decimal percentage)) continue;

                        if (!yearDataDict.ContainsKey(year))
                            yearDataDict[year] = new EmpYearData { Year = year };

                        yearDataDict[year].PMS_Percent = percentage;
                    }
                }

                // === 3. Parse Promotion Data ===
                string[] promotionDates = Request.Form.GetValues("promotionDate");
                string[] promotionGrades = Request.Form.GetValues("promotionGrade");

                if (promotionDates != null && promotionGrades != null)
                {
                    for (int i = 0; i < promotionDates.Length; i++)
                    {
                        if (!DateTime.TryParse(promotionDates[i], out DateTime promoDate)) continue;

                        int year = promoDate.Year;
                        string grade = promotionGrades[i]?.Trim();

                        if (!yearDataDict.ContainsKey(year))
                            yearDataDict[year] = new EmpYearData { Year = year };

                        yearDataDict[year].PromotionDate = promoDate;
                        yearDataDict[year].Grade = grade;
                    }
                }

                // === 4. Save to DB ===
                string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            // Delete old records for this employee
                            using (SqlCommand cmdDelete = new SqlCommand("DELETE FROM Emp_Compensation_Details WHERE EmployeeCode = @EmployeeCode", con, transaction))
                            {
                                cmdDelete.Parameters.AddWithValue("@EmployeeCode", employeeCode);
                                cmdDelete.ExecuteNonQuery();
                            }

                            // Insert updated records
                            foreach (var item in yearDataDict.Values)
                            {
                                using (SqlCommand cmd = new SqlCommand("usp_InsertUpdate_EmpCompensationDetails", con, transaction))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@EmployeeCode", employeeCode);
                                    cmd.Parameters.AddWithValue("@Year", item.Year);
                                    cmd.Parameters.AddWithValue("@CTC", item.CTC ?? (object)DBNull.Value);
                                    cmd.Parameters.AddWithValue("@CTCIncreasePercent", item.IncreasePercent ?? (object)DBNull.Value);
                                    cmd.Parameters.AddWithValue("@PromotionDate", item.PromotionDate ?? (object)DBNull.Value);
                                    cmd.Parameters.AddWithValue("@Grade", string.IsNullOrEmpty(item.Grade) ? (object)DBNull.Value : item.Grade);
                                    cmd.Parameters.AddWithValue("@PMS_Year", item.PMS_Percent.HasValue ? item.Year : (object)DBNull.Value);
                                    cmd.Parameters.AddWithValue("@PMS_Percentage", item.PMS_Percent ?? (object)DBNull.Value);

                                    cmd.ExecuteNonQuery();
                                }
                            }

                            transaction.Commit();
                            ShowSweetAlert("Success", "Compensation, PMS Ratings, and Promotion details saved successfully.", "success");
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            ShowSweetAlert("Error", "Error saving data: " + ex.Message, "error");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowSweetAlert("Error", "Unexpected error: " + ex.Message, "error");
            }
        }

        // Helper to show SweetAlert
        private void ShowSweetAlert(string title, string message, string icon)
        {
            string script = $"Swal.fire({{title: '{title}', text: '{message}', icon: '{icon}'}});";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SweetAlert", script, true);
        }

        // Helper Class
        class EmpYearData
        {
            public int Year { get; set; }
            public decimal? CTC { get; set; }
            public decimal? IncreasePercent { get; set; }
            public decimal? PMS_Percent { get; set; }
            public DateTime? PromotionDate { get; set; }
            public string Grade { get; set; }
        }

        protected void btnSaveCurrentJob_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["EmployeeId"] == null)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "Swal.fire('Error','Employee session expired. Please reload the page.','error');", true);
                    return;
                }

                int employeeId = Convert.ToInt32(Session["EmployeeId"]);

                string position = txtPosition.Text.Trim();
                string jobTitle = txtJobTitle.Text.Trim();
                string grade = txtGrade.Text.Trim();
                string city = txtCity.Text.Trim();

                if (string.IsNullOrEmpty(position) || string.IsNullOrEmpty(jobTitle))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "Swal.fire('Error','Position and Job Title are required.','error');", true);
                    return;
                }

                if (!DateTime.TryParse(txtFromDate.Text, out DateTime fromDate))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "Swal.fire('Error','Please enter a valid From Date.','error');", true);
                    return;
                }

                DateTime toDate = DateTime.Today;
                if (!string.IsNullOrEmpty(txtToDate.Text) && DateTime.TryParse(txtToDate.Text, out DateTime parsedToDate))
                {
                    toDate = parsedToDate;
                }

                decimal workExperience = Math.Round((decimal)((toDate - fromDate).TotalDays / 365), 2);
                txtWorkExperience.Text = workExperience.ToString("0.00");

                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Check if record exists
                    bool exists = false;
                    using (SqlCommand cmdCheck = new SqlCommand("SELECT COUNT(1) FROM CurrentOrganization WHERE EmployeeCode=@EmployeeCode", con))
                    {
                        cmdCheck.Parameters.AddWithValue("@EmployeeCode", employeeId);
                        exists = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0;
                    }

                    if (exists)
                    {
                        // Update existing record
                        using (SqlCommand cmdUpdate = new SqlCommand(
                            @"UPDATE CurrentOrganization 
                      SET Position=@Position, JobTitle=@JobTitle, Grade=@Grade, FromDate=@FromDate, ToDate=@ToDate, City=@City, WorkExperienceYrs=@WorkExperienceYrs
                      WHERE EmployeeCode=@EmployeeCode", con))
                        {
                            cmdUpdate.Parameters.AddWithValue("@EmployeeCode", employeeId);
                            cmdUpdate.Parameters.AddWithValue("@Position", position);
                            cmdUpdate.Parameters.AddWithValue("@JobTitle", jobTitle);
                            cmdUpdate.Parameters.AddWithValue("@Grade", string.IsNullOrEmpty(grade) ? (object)DBNull.Value : grade);
                            cmdUpdate.Parameters.AddWithValue("@FromDate", fromDate);
                            cmdUpdate.Parameters.AddWithValue("@ToDate", toDate);
                            cmdUpdate.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                            cmdUpdate.Parameters.AddWithValue("@WorkExperienceYrs", workExperience);
                            cmdUpdate.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // Insert new record using your existing stored procedure
                        using (SqlCommand cmdInsert = new SqlCommand("usp_Insert_CurrentOrganization", con))
                        {
                            cmdInsert.CommandType = CommandType.StoredProcedure;
                            cmdInsert.Parameters.AddWithValue("@EmployeeCode", employeeId);
                            cmdInsert.Parameters.AddWithValue("@Position", position);
                            cmdInsert.Parameters.AddWithValue("@JobTitle", jobTitle);
                            cmdInsert.Parameters.AddWithValue("@Grade", string.IsNullOrEmpty(grade) ? (object)DBNull.Value : grade);
                            cmdInsert.Parameters.AddWithValue("@FromDate", fromDate);
                            cmdInsert.Parameters.AddWithValue("@ToDate", toDate);
                            cmdInsert.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                            cmdInsert.Parameters.AddWithValue("@WorkExperienceYrs", workExperience);
                            cmdInsert.ExecuteNonQuery();
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    "Swal.fire('Success','Current job details saved successfully!','success');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    $"Swal.fire('Error','Error saving current job details: {ex.Message}','error');", true);
            }
        }


        // ==================== PREVIOUS ORGANIZATION ====================
        protected void btnSavePreviousEmployment_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtPreviousOrganization.Text))
                {
                    ShowSweetAlert("Validation", "Organization is required.", "warning");
                    return;
                }

                if (!DateTime.TryParse(txtPreviousFromDate.Text, out DateTime fromDate))
                {
                    ShowSweetAlert("Validation", "Please enter a valid From Date.", "warning");
                    return;
                }

                if (!DateTime.TryParse(txtPreviousToDate.Text, out DateTime toDate))
                {
                    ShowSweetAlert("Validation", "Please enter a valid To Date.", "warning");
                    return;
                }

                string organization = txtPreviousOrganization.Text.Trim();
                string job = txtPreviousJob.Text.Trim();
                string city = txtPreviousCity.Text.Trim();

                decimal workExperience = Math.Round((decimal)((toDate - fromDate).TotalDays / 365), 2);
                txtPreviousWorkExperience.Text = workExperience.ToString("0.00");

                if (Session["EmployeeId"] == null)
                {
                    ShowSweetAlert("Session Expired", "Please reload the page.", "error");
                    return;
                }

                int employeeId = Convert.ToInt32(Session["EmployeeId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("usp_Insert_PreviousOrganization", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@EmployeeCode", employeeId);
                        cmd.Parameters.AddWithValue("@Organisation", organization);
                        cmd.Parameters.AddWithValue("@JobTitle", string.IsNullOrEmpty(job) ? (object)DBNull.Value : job);
                        cmd.Parameters.AddWithValue("@FromDate", fromDate);
                        cmd.Parameters.AddWithValue("@ToDate", toDate);
                        cmd.Parameters.AddWithValue("@WorkExperienceYrs", workExperience);
                        cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Add to external experience
                decimal existingExternal = 0;
                decimal.TryParse(txtExternalExperience.Text.Trim(), out existingExternal);
                txtExternalExperience.Text = (existingExternal + workExperience).ToString("0.00");

                ShowSweetAlert("Success", "Previous employment details saved successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowSweetAlert("Error", "Error saving previous employment details: " + ex.Message, "error");
            }
        }

        // ==================== JOB DETAILS ====================
        protected void btnSaveJobDetails_Click(object sender, EventArgs e)
        {
            try
            {
                if (!DateTime.TryParse(txtDateOfJoiningJob.Text, out DateTime dateOfJoining))
                {
                    ShowSweetAlert("Validation", "Please enter a valid Date of Joining.", "warning");
                    return;
                }

                decimal internalExp = 0;
                decimal externalExp = 0;
                decimal.TryParse(txtInternalExperience.Text.Trim(), out internalExp);
                decimal.TryParse(txtExternalExperience.Text.Trim(), out externalExp);

                if (Session["EmployeeId"] == null)
                {
                    ShowSweetAlert("Session Expired", "Please reload the page.", "error");
                    return;
                }

                int employeeId = Convert.ToInt32(Session["EmployeeId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("usp_Insert_Job_Details", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@EmployeeCode", employeeId);
                        cmd.Parameters.AddWithValue("@DateOfJoining", dateOfJoining);
                        cmd.Parameters.AddWithValue("@Internal_Experience", internalExp);
                        cmd.Parameters.AddWithValue("@External_Experience", externalExp);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowSweetAlert("Success", "Job details saved successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowSweetAlert("Error", "Error saving job details: " + ex.Message, "error");
            }
        }


        protected void btnSaveEducation_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["EmployeeId"] == null)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "Swal.fire('Error','Employee session expired. Please reload the page.','error');", true);
                    return;
                }

                int employeeId = Convert.ToInt32(Session["EmployeeId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                foreach (Control entry in educationContainer.Controls)
                {
                    if (entry is HtmlGenericControl || entry is Panel)
                    {
                        TextBox txtCategory = entry.FindControl("txtEducationCategory") as TextBox;
                        TextBox txtType = entry.FindControl("txtEducationType") as TextBox;
                        TextBox txtSpec = entry.FindControl("txtSpecialization") as TextBox;
                        TextBox txtInst = entry.FindControl("txtInstitute") as TextBox;
                        TextBox txtUni = entry.FindControl("txtUniversity") as TextBox;
                        DropDownList ddlMode = entry.FindControl("ddlStudyMode") as DropDownList;
                        TextBox txtFrom = entry.FindControl("txtEduFromDate") as TextBox;
                        TextBox txtTo = entry.FindControl("txtEduToDate") as TextBox;
                        DropDownList ddlHighest = entry.FindControl("ddlIsHighestEducation") as DropDownList;

                        if (txtCategory == null || txtType == null || txtInst == null || txtUni == null)
                            continue;

                        if (string.IsNullOrWhiteSpace(txtCategory.Text) ||
                            string.IsNullOrWhiteSpace(txtType.Text) ||
                            string.IsNullOrWhiteSpace(txtInst.Text) ||
                            string.IsNullOrWhiteSpace(txtUni.Text))
                            continue;

                        DateTime fromDate, toDate;
                        if (!DateTime.TryParse(txtFrom.Text, out fromDate) || !DateTime.TryParse(txtTo.Text, out toDate))
                            continue;

                        using (SqlConnection con = new SqlConnection(connectionString))
                        {
                            con.Open();
                            using (SqlCommand cmd = new SqlCommand("usp_Insert_EducationDetails", con))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@EmployeeCode", employeeId);
                                cmd.Parameters.AddWithValue("@EducationCategory", txtCategory.Text.Trim());
                                cmd.Parameters.AddWithValue("@EducationType", txtType.Text.Trim());
                                cmd.Parameters.AddWithValue("@Specialization", string.IsNullOrEmpty(txtSpec.Text) ? (object)DBNull.Value : txtSpec.Text.Trim());
                                cmd.Parameters.AddWithValue("@Institute", txtInst.Text.Trim());
                                cmd.Parameters.AddWithValue("@University", txtUni.Text.Trim());
                                cmd.Parameters.AddWithValue("@StudyMode", ddlMode.SelectedValue);
                                cmd.Parameters.AddWithValue("@FromDate", fromDate);
                                cmd.Parameters.AddWithValue("@ToDate", toDate);
                                cmd.Parameters.AddWithValue("@IsHighestEducation", ddlHighest.SelectedValue);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    "Swal.fire('Success','Educational details saved successfully!','success');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    $"Swal.fire('Error','Error saving educational details: {ex.Message}','error');", true);
            }
        }

        protected void btnSaveFamily_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["EmployeeId"] == null)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "Swal.fire('Error','Employee session expired. Please reload the page.','error');", true);
                    return;
                }

                int employeeId = Convert.ToInt32(Session["EmployeeId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                foreach (Control entry in familyContainer.Controls)
                {
                    if (entry is HtmlGenericControl || entry is Panel)
                    {
                        TextBox txtFirstName = entry.FindControl("family-firstname") as TextBox;
                        TextBox txtLastName = entry.FindControl("family-lastname") as TextBox;
                        TextBox txtRelationship = entry.FindControl("family-relationship") as TextBox;
                        HtmlInputText dobInput = entry.FindControl("family-dob") as HtmlInputText;
                        TextBox txtNationality = entry.FindControl("family-nationality") as TextBox;
                        TextBox txtOccupation = entry.FindControl("family-occupation") as TextBox;
                        DropDownList ddlGender = entry.FindControl("family-gender") as DropDownList;

                        if (txtFirstName == null || txtLastName == null || txtRelationship == null || txtNationality == null)
                            continue;

                        if (string.IsNullOrWhiteSpace(txtFirstName.Text) ||
                            string.IsNullOrWhiteSpace(txtLastName.Text) ||
                            string.IsNullOrWhiteSpace(txtRelationship.Text) ||
                            string.IsNullOrWhiteSpace(txtNationality.Text))
                            continue;

                        DateTime dob;
                        if (!DateTime.TryParse(dobInput?.Value, out dob))
                            continue;

                        using (SqlConnection con = new SqlConnection(connectionString))
                        {
                            con.Open();
                            using (SqlCommand cmd = new SqlCommand("usp_Insert_FamilyDetails", con))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@EmployeeCode", employeeId);
                                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                                cmd.Parameters.AddWithValue("@Relationship", txtRelationship.Text.Trim());
                                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                                cmd.Parameters.AddWithValue("@DateOfBirth", dob);
                                cmd.Parameters.AddWithValue("@Nationality", txtNationality.Text.Trim());
                                cmd.Parameters.AddWithValue("@Occupation", string.IsNullOrEmpty(txtOccupation.Text) ? (object)DBNull.Value : txtOccupation.Text.Trim());
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    "Swal.fire('Success','Family details saved successfully!','success');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    $"Swal.fire('Error','Error saving family details: {ex.Message}','error');", true);
            }
        }



    }
}
