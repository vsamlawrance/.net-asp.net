using System;
using System.Web.UI;

namespace Main
{
    public partial class Login : Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (username == "test" && password == "test")
            {
                // Show SweetAlert for success then redirect
                string script = @"
                    Swal.fire({
                        title: 'Login Successful!',
                        text: 'Welcome to the portal.',
                        icon: 'success',
                        confirmButtonText: 'Continue'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location='EmployeeDetails.aspx';
                        }
                    });
                ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LoginSuccess", script, true);
            }
            else
            {
                // Show SweetAlert for error
                string script = @"
                    Swal.fire({
                        title: 'Login Failed!',
                        text: 'Invalid username or password.',
                        icon: 'error',
                        confirmButtonText: 'Try Again'
                    });
                ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LoginError", script, true);
            }
        }
    }
}
