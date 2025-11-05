using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Main
{
    public partial class Forget : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (newPassword != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match!";
                lblMessage.CssClass = "text-danger d-block mb-2";
                return;
            }

            string conStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                // Check if user exists
                SqlCommand checkUser = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Username=@Username", con);
                checkUser.Parameters.AddWithValue("@Username", username);
                int count = (int)checkUser.ExecuteScalar();

                if (count == 0)
                {
                    lblMessage.Text = "User not found!";
                    lblMessage.CssClass = "text-danger d-block mb-2";
                    return;
                }

                // Update password
                SqlCommand cmd = new SqlCommand("UPDATE Users SET Password=@Password WHERE Username=@Username", con);
                cmd.Parameters.AddWithValue("@Password", newPassword); // 🔐 ideally hash before saving
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.ExecuteNonQuery();

                lblMessage.Text = "Password reset successful! Redirecting to Login...";
                lblMessage.CssClass = "text-success d-block mb-2";

                // Redirect after 2 seconds
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
        }
    }
}