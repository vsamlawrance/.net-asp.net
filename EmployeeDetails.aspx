<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeDetails.aspx.cs" Inherits="Main.EmployeeDetails" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Profile</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- jQuery + jQuery UI -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <style>
        #sidebar {
            width: 250px;
            background-color: #f8f9fa;
            position: fixed;
            height: 100%;
            padding: 15px;
            overflow-y: auto;
        }

        #sidebar .sidebar-link {
            display: block;
            padding: 8px 0;
            text-decoration: none;
            color: #333;
            cursor: pointer;
        }

        .view-section {
            margin-left: 270px;
            padding: 30px;
        }
        #sidebar {
    width: 250px;
    background-color: #f8f9fa;
    position: fixed;
    height: 100%;
    padding: 15px;
    overflow-y: auto;

    /* New styles for toggle */
    box-shadow: 2px 0 5px rgba(0,0,0,0.3);  /* subtle shadow on right */
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    transform: translateX(0); /* visible by default */
    z-index: 1000;
}

#sidebar.hidden {
    transform: translateX(-260px); /* move sidebar fully left (hidden) */
    box-shadow: none; /* remove shadow when hidden */
}

.view-section {
    margin-left: 270px;
    padding: 30px;
    transition: margin-left 0.3s ease;
}

/* When sidebar hidden, make main content full width */
.view-section.full-width {
    margin-left: 10px;
}

/* Optional: style for close button inside sidebar */
.close-btn {
    text-align: right;
    margin-bottom: 10px;
}
.close-btn button {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
}
body {
    background-color: #f8f9fa; /* Bootstrap’s light gray background */
}
#sidebar {
  width: 240px;
  background: #f8f9fa; /* Bootstrap bg-light */
  color: #212529;       /* Bootstrap text-dark */
  padding: 15px;
  min-height: 100vh;
  border-right: 1px solid #dee2e6;
}

/* LINKS */
#sidebar .sidebar-link {
  display: block;
  padding: 10px 12px;
  color: #212529;
  text-decoration: none;
  transition: background 0.3s ease, padding-left 0.3s ease;
  position: relative;
}

#sidebar .sidebar-link:hover {
  background: #e9ecef;  /* light gray on hover */
  padding-left: 20px;
}

#sidebar .sidebar-link.active {
  background: #0d6efd;
  color: #fff;
  font-weight: bold;
}

/* SUBMENU COLLAPSE */
.submenu {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
  padding-left: 10px;
}

/* open submenu */
.submenu.open {
  max-height: 500px; /* adjust as needed */
}

/* ARROW ROTATION */
.sidebar-link .arrow {
  float: right;
  transition: transform 0.3s ease;
}

.sidebar-link.rotated .arrow {
  transform: rotate(180deg);
}


    </style>

    <script>
        function toggleSubmenu(event, submenuId) {
            event.preventDefault();
            var submenu = document.getElementById(submenuId);
            submenu.style.display = submenu.style.display === "none" ? "block" : "none";
        }

        function showView(viewId) {
            var views = document.getElementsByClassName("view-section");
            for (var i = 0; i < views.length; i++) {
                views[i].style.display = "none";
            }
            var view = document.getElementById(viewId);
            if (view) {
                view.style.display = "block";
            }
        }

        function calculateAge() {
            var dob = $('#<%= txtDateOfBirth.ClientID %>').val();
            if (dob) {
                var birthDate = new Date(dob);
                var today = new Date();
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                $('#<%= txtAge.ClientID %>').val(age);
            }
        }

        $(function () {
            // jQuery UI Datepickers
            $('#<%= txtDateOfBirth.ClientID %>').datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: "1950:2050",
                dateFormat: "yy-mm-dd",
                onSelect: calculateAge
            });

            $('#<%= txtDateOfJoining.ClientID %>').datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: "2000:2050",
                dateFormat: "yy-mm-dd"
            });

            showView('personal');
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
       <!-- HEADER -->
<nav class="navbar navbar-light bg-light shadow-sm px-3 d-flex justify-content-between align-items-center" style="height: 60px;">
    
    <!-- Sidebar Toggle Button -->
    <button type="button" class="btn btn-outline-secondary" id="sidebarToggle">
        &#9776;
    </button>

    <!-- Title -->
    <span class="navbar-brand mx-auto fw-semibold">
        Employee Profile
    </span>

    <!-- Settings Dropdown -->
    <div class="dropdown">
        <button class="btn btn-outline-secondary dropdown-toggle" 
                type="button" 
                id="settingsDropdown" 
                data-bs-toggle="dropdown" 
                aria-expanded="false">
            <i class="bi bi-gear"></i>
        </button>

        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="settingsDropdown">
            <li>
                <a class="dropdown-item" href="RoleManagement.aspx">Role Management</a>
            </li>
            <li><hr class="dropdown-divider" /></li>
            <li>
                <a class="dropdown-item text-danger" href="login.aspx">Logout</a>
            </li>
        </ul>
    </div>

</nav>


       <!-- SIDEBAR -->
<div id="sidebar">
  <div class="close-btn">
    <button type="button" id="sidebarClose">&times;</button>
  </div>

  <a href="#" class="sidebar-link" onclick="toggleSubmenu(event, 'employeeDetailsSubmenu', this)">
    Employee Details <span class="arrow">&#x25BC;</span>
  </a>
  <div id="employeeDetailsSubmenu" class="submenu">
    <a href="#" class="sidebar-link" onclick="showView('personal'); return false;">Personal Details</a>
    <a href="#" class="sidebar-link" onclick="showView('viewCompensation'); return false;">Compensation Details</a>
  </div>

  <a href="#" class="sidebar-link" onclick="toggleSubmenu(event, 'jobHistorySubmenu', this)">
    Job History Details <span class="arrow">&#x25BC;</span>
  </a>
  <div id="jobHistorySubmenu" class="submenu">
    <a href="#" class="sidebar-link" onclick="showView('job-current'); return false;">Current Organization</a>
    <a href="#" class="sidebar-link" onclick="showView('job-previous'); return false;">Previous Organization</a>
    <a href="#" class="sidebar-link" onclick="showView('job-details'); return false;">Job Details</a>
  </div>

  <a href="#" class="sidebar-link" onclick="showView('educational'); return false;">Educational Details</a>
  <a href="#" class="sidebar-link" onclick="showView('family'); return false;">Family Details</a>
  <a href="BusinessImpactData.aspx" class="sidebar-link">Business Impact Data</a>
</div>

      <script>
          function toggleSubmenu(event, id, linkElement) {
              event.preventDefault();
              const submenu = document.getElementById(id);

              submenu.classList.toggle('open');

              linkElement.classList.toggle('rotated');
          }

          document.querySelectorAll('#sidebar .sidebar-link').forEach(link => {
              link.addEventListener('click', function () {
                  if (this.nextElementSibling && this.nextElementSibling.classList.contains('submenu')) return;

                  document.querySelectorAll('#sidebar .sidebar-link').forEach(l => l.classList.remove('active'));
                  this.classList.add('active');
              });
          });
      </script>


<!-- PERSONAL DETAILS FORM -->
<div id="personal" class="view-section bg-light py-4">
    <div class="card shadow mx-auto" style="max-width: 90%;">
        
        <!-- Header -->
        <div class="card-header bg-primary text-white">
            Personal Details
        </div>

        <!-- Body -->
        <div class="card-body">
            <div class="row g-4">

                <!-- LEFT: Form Fields -->
                <div class="col-lg-8">
                    <div class="row g-3">
                        
                        <div class="col-md-6">
                            <label>First Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Last Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Employee Code <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmployeeCode" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Email <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                        </div>

                        <div class="col-md-6">
                            <label>Grade <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtGrade" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Designation <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Date of Birth <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtDateOfBirth" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Age <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" ReadOnly="true" />
                        </div>

                        <div class="col-md-6">
                            <label>Gender <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Select Gender" Value="" />
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-6">
                            <label>Date of Joining <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtDateOfJoining" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Current CTC <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtCTC" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label>Business Unit <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtBusinessUnit" runat="server" CssClass="form-control" />
                        </div>

                    </div>
                </div>

                <!-- RIGHT: Photo Preview -->
                <div class="col-lg-4 text-center">
                    <img id="imgPreview"
                         src="images/images.png"
                         alt="Employee Image"
                         class="img-thumbnail mb-3"
                         style="width:180px; height:220px; object-fit:cover;" />

                    <asp:FileUpload ID="fuEmployeeImage" 
                                    runat="server" 
                                    CssClass="form-control form-control-sm"
                                    onchange="previewImage(this);" />

                    <small class="text-muted d-block mt-1">
                        Default photo is used. Click to replace.
                    </small>
                </div>

            </div> <!-- End row g-4 -->

            <!-- Message Label -->
            <asp:Label ID="lblMessage" runat="server" 
                       CssClass="d-block text-center fw-bold mb-3">
            </asp:Label>

            <!-- Submit Button -->
            <div class="text-center mt-3">
                <asp:Button ID="btnSubmit" runat="server" 
                            Text="Save"
                            CssClass="btn btn-primary px-5"
                            OnClick="btnSubmit_Click" />
            </div>

        </div> <!-- End card-body -->

    </div> <!-- End card -->
</div> <!-- End view-section -->


<!-- Image preview script -->
<script>
    function previewImage(input) {
        const preview = document.getElementById('imgPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>



<!-- COMPENSATION DETAILS -->
<div id="viewCompensation" runat="server" class="view-section bg-light p-4" style="display:none;">
    <div class="card form-container shadow">
        <div class="card-header bg-primary text-white">Compensation Details</div>
        <div class="card-body">

            <!-- Dynamic Compensation Entries -->
            <div id="compensationContainer">
                <div class="compensation-entry mb-4 border rounded p-3 position-relative">
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">Year</label>
                            <input type="text" class="form-control comp-year" name="compYear" placeholder="Enter year" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">CTC</label>
                            <input type="text" class="form-control comp-ctc" name="compCTC" placeholder="Enter CTC" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">CTC Increase %</label>
                            <input type="text" class="form-control comp-increase" name="compIncrease" placeholder="Enter % increase" />
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <!-- Remove button added dynamically only for cloned entries -->
                        </div>
                    </div>
                </div>
            </div>

            <div class="mb-3 text-end">
                <button type="button" class="btn btn-outline-primary" onclick="addCompensationEntry()">+ Add Another</button>
            </div>

            <hr />

            <!-- PMS Rating Section -->
            <div>
                <h5>PMS Rating</h5>
                <div id="pmsRatingContainer">
                    <div class="pms-entry mb-3 border rounded p-3 position-relative">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">Year</label>
                                <input type="text" class="form-control pms-year" name="pmsYear" placeholder="Enter year" />
                            </div>
                            <div class="col-md-5">
                                <label class="form-label">Percentage %</label>
                                <input type="text" class="form-control pms-percentage" name="pmsPercentage" placeholder="Enter rating %" />
                            </div>
                            <div class="col-md-1 d-flex align-items-end">
                                <!-- Remove button added dynamically only for cloned entries -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-3 text-end">
                    <button type="button" class="btn btn-outline-primary" onclick="addPmsEntry()">+ Add Another</button>
                </div>
            </div>

            <hr />

            <!-- Last Promotion Details -->
            <div>
                <h5>Last Promotion Details</h5>
                <div id="promotionContainer">
                    <div class="promotion-entry mb-3 border rounded p-3 position-relative">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">Promotion Date</label>
                                <input type="date" class="form-control" name="promotionDate" />
                            </div>
                            <div class="col-md-5">
                                <label class="form-label">Grade</label>
                                <input type="text" class="form-control" name="promotionGrade" placeholder="Enter grade" />
                            </div>
                            <div class="col-md-1 d-flex align-items-end">
                                <!-- Remove button added dynamically only for cloned entries -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-3 text-end">
                    <button type="button" class="btn btn-outline-primary" onclick="addPromotionEntry()">+ Add Another</button>
                </div>
            </div>

            <!-- Save Button -->
            <div class="text-center mt-4">
                <asp:Button ID="btnSaveCompensation" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveCompensation_Click" />
            </div>

            <asp:Label ID="lblCompensationMessage" runat="server" CssClass="d-block text-center mt-3 fw-bold"></asp:Label>
        </div>
    </div>
</div>

<script>
    // ===== GENERIC FUNCTION TO CLEAR INPUTS =====
    function clearInputs(entry) {
        const inputs = entry.querySelectorAll("input");
        inputs.forEach(input => input.value = "");
    }

    // ===== GENERIC FUNCTION TO ADD REMOVE BUTTON =====
    function addRemoveButton(entry, entryClass) {
        const removeDiv = entry.querySelector(".col-md-1");
        if (removeDiv) {
            removeDiv.innerHTML = "";
            const btn = document.createElement("button");
            btn.type = "button";
            btn.className = "btn btn-danger btn-sm";
            btn.textContent = "Remove";
            btn.onclick = function () {
                const parent = entry.parentNode;
                if (parent.querySelectorAll(entryClass).length > 1) {
                    entry.remove();
                }
            };
            removeDiv.appendChild(btn);
        }
    }

    // ===== COMPENSATION =====
    function addCompensationEntry() {
        const container = document.getElementById("compensationContainer");
        const firstEntry = container.querySelector(".compensation-entry");
        const clone = firstEntry.cloneNode(true);
        clearInputs(clone);
        addRemoveButton(clone, ".compensation-entry");
        container.appendChild(clone);
    }

    // ===== PMS =====
    function addPmsEntry() {
        const container = document.getElementById("pmsRatingContainer");
        const firstEntry = container.querySelector(".pms-entry");
        const clone = firstEntry.cloneNode(true);
        clearInputs(clone);
        addRemoveButton(clone, ".pms-entry");
        container.appendChild(clone);
    }

    // ===== PROMOTION =====
    function addPromotionEntry() {
        const container = document.getElementById("promotionContainer");
        const firstEntry = container.querySelector(".promotion-entry");
        const clone = firstEntry.cloneNode(true);
        clearInputs(clone);
        addRemoveButton(clone, ".promotion-entry");
        container.appendChild(clone);
    }
</script>
<!-- CURRENT ORGANIZATION -->
<div id="job-current" class="view-section">
    <div class="card form-container">
        <div class="card-header bg-primary text-white">Current Organization</div>
        <div class="card-body">
            <asp:Panel ID="pnlCurrentJob" runat="server">

                <asp:HiddenField ID="hdnCurrentJobId" runat="server" />

                <div class="row g-3">
                    <div class="col-md-6">
                        <asp:Label ID="lblPosition" runat="server" AssociatedControlID="txtPosition" Text="Position" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtPosition" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <asp:Label ID="lblJobTitle" runat="server" AssociatedControlID="txtJobTitle" Text="Job Title" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <asp:Label ID="lblGrade" runat="server" AssociatedControlID="txtGrade" Text="Grade" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <asp:Label ID="lblCity" runat="server" AssociatedControlID="txtCity" Text="City" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <asp:Label ID="lblFromDate" runat="server" AssociatedControlID="txtFromDate" Text="From Date" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" onchange="calculateExperience()" />
                    </div>
                    <div class="col-md-6">
                        <asp:Label ID="lblToDate" runat="server" AssociatedControlID="txtToDate" Text="To Date" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" onchange="calculateExperience()" />
                    </div>
                    <div class="col-md-6">
                        <asp:Label ID="lblWorkExperience" runat="server" AssociatedControlID="txtWorkExperience" Text="Work Experience (yrs)" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtWorkExperience" runat="server" CssClass="form-control" ReadOnly="true" />
                    </div>
                </div>

                <div class="text-center mt-3">
                    <asp:Button ID="btnSaveCurrentJob" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveCurrentJob_Click" />
                </div>

            </asp:Panel>
        </div>
    </div>
</div>

<!-- SweetAlert script -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function calculateExperience() {
        const fromDateInput = document.getElementById('<%= txtFromDate.ClientID %>');
        const toDateInput = document.getElementById('<%= txtToDate.ClientID %>');
        const experienceInput = document.getElementById('<%= txtWorkExperience.ClientID %>');

        const fromDate = new Date(fromDateInput.value);
        const toDate = new Date(toDateInput.value);

        if (!isNaN(fromDate) && !isNaN(toDate) && toDate >= fromDate) {
            const diffTime = toDate - fromDate;
            const diffYears = diffTime / (1000 * 60 * 60 * 24 * 365);
            experienceInput.value = diffYears.toFixed(2);
        } else {
            experienceInput.value = '';
        }
    }
</script>



<script>
    function calculateExperience() {
        const fromDateInput = document.getElementById('<%= txtFromDate.ClientID %>');
        const toDateInput = document.getElementById('<%= txtToDate.ClientID %>');
        const experienceInput = document.getElementById('<%= txtWorkExperience.ClientID %>');

        const fromDate = new Date(fromDateInput.value);
        const toDate = new Date(toDateInput.value);

        if (!isNaN(fromDate) && !isNaN(toDate) && toDate >= fromDate) {
            const diffTime = toDate - fromDate;
            const diffYears = diffTime / (1000 * 60 * 60 * 24 * 365.25);
            experienceInput.value = diffYears.toFixed(2);
        } else {
            experienceInput.value = '';
        }
    }
</script>




<!-- PREVIOUS ORGANIZATION DETAILS -->
<div id="job-previous" class="view-section">
    <div class="card form-container">
        <div class="card-header bg-primary text-white">Previous Organization</div>
        <div class="card-body">
            <div id="previousEmploymentContainer">
                <div class="previous-entry mb-4 border rounded p-3">
                    <div class="text-end mb-2">
                        <button type="button" class="btn btn-danger btn-sm remove-entry" style="display:none;" onclick="removePreviousEntry(this)">
                            Remove
                        </button>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label mb-2">Organization <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtPreviousOrganization" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label mb-2">Job</label>
                            <asp:TextBox ID="txtPreviousJob" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label mb-2">From Date <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtPreviousFromDate" runat="server" CssClass="form-control" TextMode="Date" onchange="calculatePreviousExperience(this)" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label mb-2">To Date <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtPreviousToDate" runat="server" CssClass="form-control" TextMode="Date" onchange="calculatePreviousExperience(this)" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label mb-2">Work Experience (yrs)</label>
                            <asp:TextBox ID="txtPreviousWorkExperience" runat="server" CssClass="form-control" ReadOnly="true" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label mb-2">City</label>
                            <asp:TextBox ID="txtPreviousCity" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-3 text-end">
                <button type="button" class="btn btn-outline-primary" onclick="addPreviousEntry()">+ Add Another</button>
            </div>
            <div class="text-center">
                <asp:Button ID="btnSavePreviousEmployment" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSavePreviousEmployment_Click" />
            </div>
        </div>
    </div>
</div>


<script>
    function calculatePreviousExperience(input) {
        const parent = input.closest('.previous-entry');
        const fromDateInput = parent.querySelector('[id$="txtPreviousFromDate"]');
        const toDateInput = parent.querySelector('[id$="txtPreviousToDate"]');
        const experienceInput = parent.querySelector('[id$="txtPreviousWorkExperience"]');

        const fromDate = new Date(fromDateInput.value);
        const toDate = new Date(toDateInput.value);

        if (!isNaN(fromDate) && !isNaN(toDate) && toDate >= fromDate) {
            const diffTime = toDate - fromDate;
            const diffYears = diffTime / (1000 * 60 * 60 * 24 * 365.25);
            experienceInput.value = diffYears.toFixed(2);
        } else {
            experienceInput.value = '';
        }

        // Update total external experience
        updateExternalExperience();
    }

    function addPreviousEntry() {
        const container = document.getElementById('previousEmploymentContainer');
        const firstEntry = container.querySelector('.previous-entry');
        const newEntry = firstEntry.cloneNode(true);

        newEntry.querySelectorAll('input').forEach(input => input.value = '');
        newEntry.querySelector('.remove-entry').style.display = 'inline-block';

        container.appendChild(newEntry);
    }

    function removePreviousEntry(button) {
        const parent = button.closest('.previous-entry');
        parent.remove();
        updateExternalExperience();
    }

    // Optional: function to sum all previous experiences
    function updateExternalExperience() {
        let total = 0;
        const entries = document.querySelectorAll('.previous-entry');
        entries.forEach(entry => {
            const expInput = entry.querySelector('[id$="txtPreviousWorkExperience"]');
            const val = parseFloat(expInput.value);
            if (!isNaN(val)) total += val;
        });

        const externalExpInput = document.getElementById('<%= txtExternalExperience.ClientID %>');
        if (externalExpInput) externalExpInput.value = total.toFixed(2);
    }

</script>

       <!-- JOB DETAILS -->
<div id="job-details" class="view-section">
    <div class="card form-container">
        <div class="card-header bg-primary text-white">
            Job Details
        </div>
        <div class="card-body">
            <div class="mb-3">
                <label class="form-label">
                    Date of Joining
                </label>
                <asp:TextBox ID="txtDateOfJoiningJob" runat="server" CssClass="form-control" TextMode="Date" />
            </div>

            <div class="mb-3">
                <label class="form-label">Internal Experience (Years)</label>
                <asp:TextBox ID="txtInternalExperience" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">External Experience (Years)</label>
                <asp:TextBox ID="txtExternalExperience" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="text-center">
                <asp:Button ID="btnSaveJobDetails" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveJobDetails_Click" />
            </div>

            <asp:Label ID="lblJobDetailsMessage" runat="server" CssClass="d-block text-center mt-2 fw-bold"></asp:Label>
        </div>
    </div>
</div>
        <script>
            // Calculate years difference between two dates
            function calculateYears(fromDateStr, toDateStr) {
                const fromDate = new Date(fromDateStr);
                const toDate = new Date(toDateStr);
                if (isNaN(fromDate) || isNaN(toDate)) return 0;
                const diff = (toDate - fromDate) / (1000 * 60 * 60 * 24 * 365);
                return parseFloat(diff.toFixed(2));
            }

            // Update Internal Experience from Current Organization
            function updateInternalExperience() {
                const fromDate = document.getElementById('txtFromDate')?.value;
                const toDate = document.getElementById('txtToDate')?.value;
                const internalExpInput = document.getElementById('txtInternalExperience');

                if (internalExpInput) {
                    internalExpInput.value = calculateYears(fromDate, toDate);
                }
            }

            // Update External Experience from Previous Organizations
            function updateExternalExperience() {
                let total = 0;
                const previousEntries = document.querySelectorAll('.previous-entry');

                previousEntries.forEach(entry => {
                    const fromDate = entry.querySelector('[id$="txtPreviousFromDate"]').value;
                    const toDate = entry.querySelector('[id$="txtPreviousToDate"]').value;
                    total += calculateYears(fromDate, toDate);
                });

                const externalExpInput = document.getElementById('txtExternalExperience');
                if (externalExpInput) externalExpInput.value = total.toFixed(2);
            }

            // Attach event listeners
            document.addEventListener('DOMContentLoaded', () => {
                const currentFrom = document.getElementById('txtFromDate');
                const currentTo = document.getElementById('txtToDate');
                if (currentFrom) currentFrom.addEventListener('change', updateInternalExperience);
                if (currentTo) currentTo.addEventListener('change', updateInternalExperience);

                // Update external experience whenever any previous org date changes
                const observer = new MutationObserver(() => {
                    const fromDates = document.querySelectorAll('.previous-entry [id$="txtPreviousFromDate"]');
                    const toDates = document.querySelectorAll('.previous-entry [id$="txtPreviousToDate"]');
                    fromDates.forEach(d => d.addEventListener('change', updateExternalExperience));
                    toDates.forEach(d => d.addEventListener('change', updateExternalExperience));
                    updateExternalExperience(); // Initial calculation
                });

                observer.observe(document.getElementById('previousEmploymentContainer'), { childList: true, subtree: true });
            });
        </script>

<!-- EDUCATIONAL DETAILS -->
<div id="educational" class="view-section">
    <div class="card form-container">
        <div class="card-header bg-primary text-white">Educational Details</div>
        <div class="card-body">
            <asp:Panel ID="educationContainer" runat="server">
                <div class="education-entry mb-4 border rounded p-3" data-index="0">
                    <div class="text-end mb-2">
                        <button type="button" class="btn btn-danger btn-sm remove-education-btn" style="display:none;" onclick="removeEducationEntry(this)">Remove</button>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Education Category <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtEducationCategory" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Education Type <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtEducationType" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label class="form-label">Specialization</label>
                            <asp:TextBox ID="txtSpecialization" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Institute <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtInstitute" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label class="form-label">University <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtUniversity" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Study Mode <span style="color:red;">*</span></label>
                            <asp:DropDownList ID="ddlStudyMode" runat="server" CssClass="form-select">
                                <asp:ListItem Value="" Text="-- Select --" />
                                <asp:ListItem Value="Part Time" Text="Part Time" />
                                <asp:ListItem Value="Full Time" Text="Full Time" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label class="form-label">From <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtEduFromDate" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">To <span style="color:red;">*</span></label>
                            <asp:TextBox ID="txtEduToDate" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label class="form-label">Is Highest Education?</label>
                            <asp:DropDownList ID="ddlIsHighestEducation" runat="server" CssClass="form-select">
                                <asp:ListItem Value="" Text="-- Select --" />
                                <asp:ListItem Value="Yes" Text="Yes" />
                                <asp:ListItem Value="No" Text="No" />
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <div class="mb-3 text-end mt-3">
                <button type="button" class="btn btn-outline-primary" onclick="addEducationEntry()">+ Add Another</button>
            </div>

            <div class="text-center mt-3">
                <asp:Button ID="btnSaveEducation" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSaveEducation_Click" />
            </div>

            <asp:Label ID="lblEducationMessage" runat="server" CssClass="d-block text-center mt-2 fw-bold"></asp:Label>
        </div>
    </div>
</div>

<script>
    let educationIndex = 1; // unique index for cloned entries

    function addEducationEntry() {
        const container = document.getElementById('<%= educationContainer.ClientID %>');
        const firstEntry = container.querySelector('.education-entry');
        const newEntry = firstEntry.cloneNode(true);

        // Update index
        newEntry.setAttribute('data-index', educationIndex);

        // Clear all inputs and selects
        newEntry.querySelectorAll('input, select').forEach(el => el.value = '');

        // Show remove button
        const removeBtn = newEntry.querySelector('.remove-education-btn');
        removeBtn.style.display = 'inline-block';
        removeBtn.setAttribute('onclick', 'removeEducationEntry(this)');

        container.appendChild(newEntry);
        educationIndex++;
    }

    function removeEducationEntry(btn) {
        const container = document.getElementById('<%= educationContainer.ClientID %>');
        if (container.children.length > 1) {
            btn.closest('.education-entry').remove();
        } else {
            alert('At least one entry is required.');
        }
    }
</script>
<!-- FAMILY DETAILS SECTION -->
<div id="family" class="view-section">
    <div class="card form-container mt-4">
        <div class="card-header bg-primary text-white">Family Details</div>
        <div class="card-body">
            <asp:Panel ID="familyContainer" runat="server">
                <div class="family-entry border rounded p-3 mb-3" data-index="0">
                    <div class="text-end mb-2">
                        <button type="button" class="btn btn-danger btn-sm remove-family-btn" style="display:none;" onclick="removeFamilyEntry(this)">Remove</button>
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <label>First Name<span class="text-danger">*</span></label>
                            <input type="text" class="form-control family-firstname" />
                        </div>
                        <div class="col-md-6">
                            <label>Last Name<span class="text-danger">*</span></label>
                            <input type="text" class="form-control family-lastname" />
                        </div>
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-4">
                            <label>Relationship<span class="text-danger">*</span></label>
                            <input type="text" class="form-control family-relationship" />
                        </div>
                        <div class="col-md-4">
                            <label>Gender</label>
                            <select class="form-control family-gender">
                                <option value="">Select</option>
                                <option>Male</option>
                                <option>Female</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label>Date of Birth<span class="text-danger">*</span></label>
                            <input type="date" class="form-control family-dob" />
                        </div>
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <label>Nationality<span class="text-danger">*</span></label>
                            <input type="text" class="form-control family-nationality" />
                        </div>
                        <div class="col-md-6">
                            <label>Occupation</label>
                            <input type="text" class="form-control family-occupation" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <div class="mb-3 text-end mt-3">
                <button type="button" class="btn btn-outline-primary" onclick="addFamilyEntry()">+ Add Another</button>
            </div>

            <div class="text-center mt-3">
                <asp:Button ID="btnSaveFamily" runat="server" CssClass="btn btn-primary" 
                            Text="Save" OnClick="btnSaveFamily_Click" />
            </div>

            <asp:Label ID="lblFamilyMessage" runat="server" CssClass="d-block text-center mt-2 fw-bold"></asp:Label>
        </div>
    </div>
</div>

<script>
    let familyIndex = 1; // unique index for cloned entries

    function addFamilyEntry() {
        const container = document.getElementById('<%= familyContainer.ClientID %>');
        const firstEntry = container.querySelector('.family-entry');
        const newEntry = firstEntry.cloneNode(true);

        // Update index
        newEntry.setAttribute('data-index', familyIndex);

        // Clear all inputs
        newEntry.querySelectorAll('input, select').forEach(el => el.value = '');

        // Show remove button
        const removeBtn = newEntry.querySelector('.remove-family-btn');
        removeBtn.style.display = 'inline-block';
        removeBtn.setAttribute('onclick', 'removeFamilyEntry(this)');

        container.appendChild(newEntry);
        familyIndex++;
    }

    function removeFamilyEntry(btn) {
        const container = document.getElementById('<%= familyContainer.ClientID %>');
        if (container.children.length > 1) {
            btn.closest('.family-entry').remove();
        } else {
            alert('At least one family entry is required.');
        }
    }
</script>


    </form> 
   
    <script>
       // Remove entry handler (delegated event)
        $(document).on('click', '.remove-entry', function () {
            $(this).closest('.compensation-entry').remove();
        });
        $(document).ready(function () {
            // Toggle sidebar when clicking the toggle button
            $('#sidebarToggle').on('click', function () {
                $('#sidebar').toggleClass('hidden');
                $('.view-section').toggleClass('full-width');
            });

            // Close sidebar when clicking the close button inside sidebar
            $('#sidebarClose').on('click', function () {
                $('#sidebar').addClass('hidden');
                $('.view-section').addClass('full-width');
            });
        });
    </script>
   
   



    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
