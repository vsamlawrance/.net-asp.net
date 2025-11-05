using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace Main
{
    public class EmployeeImageHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            int employeeId;
            if (!int.TryParse(context.Request.QueryString["EmployeeId"], out employeeId))
            {
                context.Response.StatusCode = 400; // Bad Request
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            byte[] imageBytes = null;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT EmployeeImage FROM Employee_Details WHERE EmployeeId = @EmployeeId";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != DBNull.Value && result != null)
                    {
                        imageBytes = (byte[])result;
                    }
                }
            }

            if (imageBytes != null)
            {
                context.Response.ContentType = "image/jpeg"; // or image/png if applicable
                context.Response.BinaryWrite(imageBytes);
            }
            else
            {
                context.Response.StatusCode = 404; // Not Found
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
