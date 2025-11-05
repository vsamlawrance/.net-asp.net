using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace Main
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                // Show an alert if passwords do not match
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "Swal.fire('Error', 'Passwords do not match!', 'error');", true);
                return;
            }

            // Convert password to Base64
            string base64Password = Convert.ToBase64String(Encoding.UTF8.GetBytes(txtPassword.Text));

            // Save into database
            string constr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = "INSERT INTO Users (Username, Email, Password) VALUES (@Username, @Email, @Password)";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", base64Password);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }

            // Success alert
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                "Swal.fire('Success', 'Registration completed!', 'success');", true);

            // Optionally clear fields
            txtUsername.Text = txtEmail.Text = txtPassword.Text = txtConfirmPassword.Text = "";
        }
    }
}
