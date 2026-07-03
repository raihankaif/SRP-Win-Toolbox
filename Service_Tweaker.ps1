# --- AUTOMATIC ADMIN ELEVATION WITH BYPASS POLICY ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}
Set-ExecutionPolicy Bypass -Scope Process -Force;

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- UI WINDOW SETUP ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "SRP Tournament & Gaming Service Tweaker"
$form.Size = New-Object System.Drawing.Size(550, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20) # Black Base
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# --- BRANDING COLORS ---
$OrangeColor = [System.Drawing.Color]::FromArgb(255, 102, 0) # Primary Orange
$WhiteColor  = [System.Drawing.Color]::FromArgb(240, 240, 240) # White Text
$GrayColor   = [System.Drawing.Color]::FromArgb(40, 40, 40) # Secondary Dark

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "SERVICE TWEAKER"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $OrangeColor
$titleLabel.Size = New-Object System.Drawing.Size(500, 40)
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.TextAlign = "Center"
$form.Controls.Add($titleLabel)

# --- SERVICES LIST DATA ---
$services = @(
    # Group 1: Telemetry & Bloat (Recommended to Disable)
    @{ Name = "DiagTrack"; Desc = "Connected User Experiences (Telemetry)"; Group = "Telemetry" },
    @{ Name = "MapsBroker"; Desc = "Downloaded Maps Manager"; Group = "Telemetry" },
    @{ Name = "DusmSvc"; Desc = "Data Usage Monitoring Service"; Group = "Telemetry" },
    
    # Group 2: Optional Performance (The ones you mentioned to keep optional)
    @{ Name = "SysMain"; Desc = "SysMain (Preloads apps, can cause stutter)"; Group = "Optional" },
    @{ Name = "WbioSrvc"; Desc = "Windows Biometric Service (Fingerprint)"; Group = "Optional" },
    @{ Name = "Wsearch"; Desc = "Windows Search (File Indexing)"; Group = "Optional" },

    # Group 3: Utility / Extras
    @{ Name = "Spooler"; Desc = "Print Spooler (Printer Service)"; Group = "Utility" },
    @{ Name = "Fax"; Desc = "Fax Service"; Group = "Utility" }
)

# --- GENERATE CHECKBOXES VIA GUI ---
$yPos = 70
$checkboxes = @()

# Helper function to create section headers
function Add-Header($text, $y) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $lbl.ForeColor = $OrangeColor
    $lbl.Location = New-Object System.Drawing.Point(30, $y)
    $lbl.Size = New-Object System.Drawing.Size(450, 20)
    $form.Controls.Add($lbl)
    return ($y + 25)
}

# 1. Telemetry Section
$yPos = Add-Header "--- RECOMMENDED TO DISABLE (BLOATWARE) ---" $yPos
foreach ($srv in $services | Where-Object {$_.Group -eq "Telemetry"}) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = "$($srv.Desc) [$($srv.Name)]"
    $cb.ForeColor = $WhiteColor
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $cb.Location = New-Object System.Drawing.Point(40, $yPos)
    $cb.Size = New-Object System.Drawing.Size(450, 25)
    $cb.Tag = $srv.Name
    $form.Controls.Add($cb)
    $checkboxes += $cb
    $yPos += 30
}

# 2. Optional Section
$yPos += 10
$yPos = Add-Header "--- OPTIONAL PERFORMANCE (USER CHOICE) ---" $yPos
foreach ($srv in $services | Where-Object {$_.Group -eq "Optional"}) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = "$($srv.Desc) [$($srv.Name)]"
    $cb.ForeColor = $WhiteColor
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $cb.Location = New-Object System.Drawing.Point(40, $yPos)
    $cb.Size = New-Object System.Drawing.Size(450, 25)
    $cb.Tag = $srv.Name
    $form.Controls.Add($cb)
    $checkboxes += $cb
    $yPos += 30
}

# 3. Utility Section
$yPos += 10
$yPos = Add-Header "--- PRINTER & UTILITIES ---" $yPos
foreach ($srv in $services | Where-Object {$_.Group -eq "Utility"}) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = "$($srv.Desc) [$($srv.Name)]"
    $cb.ForeColor = $WhiteColor
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $cb.Location = New-Object System.Drawing.Point(40, $yPos)
    $cb.Size = New-Object System.Drawing.Size(450, 25)
    $cb.Tag = $srv.Name
    $form.Controls.Add($cb)
    $checkboxes += $cb
    $yPos += 30
}

# --- BUTTONS WORK ACTION ---
$btnDisable = New-Object System.Windows.Forms.Button
$btnDisable.Text = "DISABLE SELECTED"
$btnDisable.Size = New-Object System.Drawing.Size(220, 45)
$btnDisable.Location = New-Object System.Drawing.Point(40, 520)
$btnDisable.BackColor = $OrangeColor
$btnDisable.ForeColor = [System.Drawing.Color]::Black
$btnDisable.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnDisable.FlatStyle = "Flat"
$btnDisable.FlatAppearance.BorderSize = 0

$btnDisable.Add_Click({
    $count = 0
    foreach ($cb in $checkboxes) {
        if ($cb.Checked) {
            $sName = $cb.Tag
            Stop-Service -Name $sName -ErrorAction SilentlyContinue
            Set-Service -Name $sName -StartupType Disabled -ErrorAction SilentlyContinue
            $count++
        }
    }
    [System.Windows.Forms.MessageBox]::Show("Successfully disabled $count service(s)!", "Success", "OK", "Information")
})

$btnEnable = New-Object System.Windows.Forms.Button
$btnEnable.Text = "ENABLE SELECTED"
$btnEnable.Size = New-Object System.Drawing.Size(220, 45)
$btnEnable.Location = New-Object System.Drawing.Point(280, 520)
$btnEnable.BackColor = $GrayColor
$btnEnable.ForeColor = $WhiteColor
$btnEnable.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnEnable.FlatStyle = "Flat"
$btnEnable.FlatAppearance.BorderColor = $OrangeColor
$btnEnable.FlatAppearance.BorderSize = 1

$btnEnable.Add_Click({
    $count = 0
    foreach ($cb in $checkboxes) {
        if ($cb.Checked) {
            $sName = $cb.Tag
            Set-Service -Name $sName -StartupType Automatic -ErrorAction SilentlyContinue
            Start-Service -Name $sName -ErrorAction SilentlyContinue
            $count++
        }
    }
    [System.Windows.Forms.MessageBox]::Show("Successfully enabled & started $count service(s)!", "Success", "OK", "Information")
})

$form.Controls.Add($btnDisable)
$form.Controls.Add($btnEnable)

# Show Interface
$form.ShowDialog()