# Set execution policy for the current process to allow script running
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
# 1. Automatically force the script to run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}
# Load Windows Forms assembly to create the GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the Main Form (Window)
$form = New-Object System.Windows.Forms.Form
$form.Text = "SRP Debloater v1.0"
$form.Size = New-Object System.Drawing.Size(600, 540)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
# Set background color to deep black
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

# Create Label for instructions
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(15, 15)
$label.Size = New-Object System.Drawing.Size(550, 45)
$label.Text = "Select apps manually or click 'Select Bloatware' to auto-check junk apps.`nWARNING: Always review the checked apps before uninstalling!"
$label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
# Set text color to Orange
$label.ForeColor = [System.Drawing.Color]::DarkOrange

# Create CheckedListBox (The list with checkboxes)
$checkedListBox = New-Object System.Windows.Forms.CheckedListBox
$checkedListBox.Location = New-Object System.Drawing.Point(15, 70)
$checkedListBox.Size = New-Object System.Drawing.Size(550, 350)
$checkedListBox.CheckOnClick = $true
$checkedListBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
# Dark gray background for the list, Orange text
$checkedListBox.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 35)
$checkedListBox.ForeColor = [System.Drawing.Color]::Orange
$checkedListBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

# Known Windows Bloatware List
$bloatwareList = @(
    "Microsoft.BingWeather", "Microsoft.BingSports", "Microsoft.BingNews", "Microsoft.BingFinance",
    "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.XboxApp", "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxSpeechToTextOverlay", "Microsoft.XboxIdentityProvider", "Microsoft.YourPhone",
    "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging", "Microsoft.3DBuilder",
    "Microsoft.Microsoft3DViewer", "Microsoft.WindowsMaps", "Microsoft.WindowsFeedbackHub",
    "Microsoft.MixedReality.Portal", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.SkypeApp",
    "Microsoft.People", "Microsoft.Office.OneNote", "Microsoft.WindowsAlarms", "Microsoft.WindowsSoundRecorder",
    "Microsoft.Wallet", "Microsoft.Todos", "Microsoft.MicrosoftOfficeHub", "Microsoft.MSPaint"
)

# Get apps and map names to their hidden PackageFullName
$apps = Get-AppxPackage | Sort-Object Name
$appMap = @{}

foreach ($app in $apps) {
    $name = $app.Name
    # Store the hidden PackageFullName in the hash table
    if (-not $appMap.ContainsKey($name)) {
        $appMap[$name] = $app.PackageFullName
        # Add ONLY the clean Name to the UI
        $checkedListBox.Items.Add($name) | Out-Null
    }
}

# Create "Select Bloatware" Button
$bloatwareButton = New-Object System.Windows.Forms.Button
$bloatwareButton.Location = New-Object System.Drawing.Point(110, 440)
$bloatwareButton.Size = New-Object System.Drawing.Size(170, 45)
$bloatwareButton.Text = "SELECT BLOATWARE"
$bloatwareButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$bloatwareButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$bloatwareButton.ForeColor = [System.Drawing.Color]::DarkOrange
$bloatwareButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$bloatwareButton.FlatAppearance.BorderSize = 1
$bloatwareButton.FlatAppearance.BorderColor = [System.Drawing.Color]::DarkOrange

# Define what happens when Bloatware button is clicked
$bloatwareButton.Add_Click({
    $foundCount = 0
    for ($i = 0; $i -lt $checkedListBox.Items.Count; $i++) {
        $itemName = $checkedListBox.Items[$i]
        if ($bloatwareList -contains $itemName) {
            $checkedListBox.SetItemChecked($i, $true)
            $foundCount++
        }
    }
    
    if ($foundCount -gt 0) {
        [System.Windows.Forms.MessageBox]::Show("$foundCount bloatware app(s) auto-selected. Please review the list before uninstalling.", "Bloatware Selected", 0, 64)
    } else {
        [System.Windows.Forms.MessageBox]::Show("No common bloatware found on this system.", "Clean", 0, 64)
    }
})

# Create Uninstall Button
$uninstallButton = New-Object System.Windows.Forms.Button
$uninstallButton.Location = New-Object System.Drawing.Point(300, 440)
$uninstallButton.Size = New-Object System.Drawing.Size(170, 45)
$uninstallButton.Text = "UNINSTALL"
$uninstallButton.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$uninstallButton.BackColor = [System.Drawing.Color]::DarkOrange
$uninstallButton.ForeColor = [System.Drawing.Color]::Black
$uninstallButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$uninstallButton.FlatAppearance.BorderSize = 0

# Define what happens when Uninstall button is clicked
$uninstallButton.Add_Click({
    $selectedCount = $checkedListBox.CheckedItems.Count

    if ($selectedCount -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select at least one app.", "Error", 0, 48)
        return
    }

    $confirm = [System.Windows.Forms.MessageBox]::Show("Uninstall $selectedCount app(s)?", "Confirm", 4, 48)
    
    if ($confirm -eq 'Yes') {
        $form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
        $success = 0
        $failed = @()

        foreach ($item in $checkedListBox.CheckedItems) {
            # Retrieve the hidden PackageFullName using the App Name
            $fullName = $appMap[$item]

            try {
                Remove-AppxPackage -Package $fullName -ErrorAction Stop
                $success++
            } 
            catch {
                $failed += $item
            }
        }

        $form.Cursor = [System.Windows.Forms.Cursors]::Default
        $msg = "Successfully uninstalled: $success app(s).`n"
        if ($failed.Count -gt 0) {
            $msg += "Failed: $($failed.Count) app(s). (System protected)"
        }

        [System.Windows.Forms.MessageBox]::Show($msg, "Result", 0, 64)
        $form.Close()
    }
})

# Add controls to the form
$form.Controls.Add($label)
$form.Controls.Add($checkedListBox)
$form.Controls.Add($bloatwareButton)
$form.Controls.Add($uninstallButton)

# Bring the form to the front
$form.Topmost = $true
$form.ShowDialog() | Out-Null