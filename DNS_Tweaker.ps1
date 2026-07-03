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
$form.Text = "SRP Network & Smart DNS Tweaker"
$form.Size = New-Object System.Drawing.Size(540, 710)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20) # Deep Black Base
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# --- BRANDING COLORS ---
$OrangeColor = [System.Drawing.Color]::FromArgb(255, 102, 0) # Primary Orange
$WhiteColor  = [System.Drawing.Color]::FromArgb(240, 240, 240) # White Text
$GrayColor   = [System.Drawing.Color]::FromArgb(35, 35, 35) # Container Dark

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "NETWORK ADVANCED TWEAKER"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $OrangeColor
$titleLabel.Size = New-Object System.Drawing.Size(500, 40)
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.TextAlign = "Center"
$form.Controls.Add($titleLabel)

# =========================================================================
# SECTION 1: NETWORK LATENCY CONTROLS (ENABLE / DISABLE OPTIONS)
# =========================================================================
# Panel for Tweak 1 (Nagle's Algorithm)
$pnlNagle = New-Object System.Windows.Forms.Panel
$pnlNagle.Size = New-Object System.Drawing.Size(460, 50)
$pnlNagle.Location = New-Object System.Drawing.Point(30, 65)
$pnlNagle.BackColor = $GrayColor
$form.Controls.Add($pnlNagle)

$lblNagle = New-Object System.Windows.Forms.Label
$lblNagle.Text = "Nagle's Algorithm (TCP Delay):"
$lblNagle.ForeColor = $WhiteColor
$lblNagle.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$lblNagle.Location = New-Object System.Drawing.Point(10, 15)
$lblNagle.Size = New-Object System.Drawing.Size(200, 20)
$pnlNagle.Controls.Add($lblNagle)

$rbNagleDisable = New-Object System.Windows.Forms.RadioButton
$rbNagleDisable.Text = "Disable (Fast)"
$rbNagleDisable.ForeColor = $OrangeColor
$rbNagleDisable.Location = New-Object System.Drawing.Point(220, 13)
$rbNagleDisable.Checked = $true
$pnlNagle.Controls.Add($rbNagleDisable)

$rbNagleEnable = New-Object System.Windows.Forms.RadioButton
$rbNagleEnable.Text = "Enable (Default)"
$rbNagleEnable.ForeColor = $WhiteColor
$rbNagleEnable.Location = New-Object System.Drawing.Point(330, 13)
$pnlNagle.Controls.Add($rbNagleEnable)

# Panel for Tweak 2 (Network Throttling)
$pnlThrottle = New-Object System.Windows.Forms.Panel
$pnlThrottle.Size = New-Object System.Drawing.Size(460, 50)
$pnlThrottle.Location = New-Object System.Drawing.Point(30, 125)
$pnlThrottle.BackColor = $GrayColor
$form.Controls.Add($pnlThrottle)

$lblThrottle = New-Object System.Windows.Forms.Label
$lblThrottle.Text = "Network Throttling Index:"
$lblThrottle.ForeColor = $WhiteColor
$lblThrottle.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$lblThrottle.Location = New-Object System.Drawing.Point(10, 15)
$lblThrottle.Size = New-Object System.Drawing.Size(200, 20)
$pnlThrottle.Controls.Add($lblThrottle)

$rbThrottleDisable = New-Object System.Windows.Forms.RadioButton
$rbThrottleDisable.Text = "Disable (Max Priority)"
$rbThrottleDisable.ForeColor = $OrangeColor
$rbThrottleDisable.Location = New-Object System.Drawing.Point(220, 13)
$rbThrottleDisable.Checked = $true
$pnlThrottle.Controls.Add($rbThrottleDisable)

$rbThrottleEnable = New-Object System.Windows.Forms.RadioButton
$rbThrottleEnable.Text = "Enable (Default)"
$rbThrottleEnable.ForeColor = $WhiteColor
$rbThrottleEnable.Location = New-Object System.Drawing.Point(350, 13)
$pnlThrottle.Controls.Add($rbThrottleEnable)

# =========================================================================
# SECTION 2: LIVE DNS BENCHMARKER (WITH CLICK ACTION)
# =========================================================================
$dnsServers = @(
    @{ Name = "Cloudflare DNS"; Primary = "1.1.1.1"; Secondary = "1.0.0.1"; Ping = "NT" },
    @{ Name = "Google Public DNS"; Primary = "8.8.8.8"; Secondary = "8.8.4.4"; Ping = "NT" },
    @{ Name = "Quad9 Core DNS"; Primary = "9.9.9.9"; Secondary = "149.112.112.112"; Ping = "NT" },
    @{ Name = "AdGuard DNS (Gaming)"; Primary = "94.140.14.14"; Secondary = "94.140.15.15"; Ping = "NT" }
)

$listView = New-Object System.Windows.Forms.ListView
$listView.Size = New-Object System.Drawing.Size(460, 130)
$listView.Location = New-Object System.Drawing.Point(30, 190)
$listView.View = [System.Windows.Forms.View]::Details
$listView.FullRowSelect = $true
$listView.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$listView.ForeColor = $WhiteColor
$listView.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$listView.Columns.Add("DNS Provider (Click to Select)", 220) | Out-Null
$listView.Columns.Add("Primary IP", 130) | Out-Null
$listView.Columns.Add("Ping", 90) | Out-Null

function Update-ListView {
    $listView.Items.Clear()
    foreach ($dns in $dnsServers) {
        $item = New-Object System.Windows.Forms.ListViewItem($dns.Name)
        $item.SubItems.Add($dns.Primary) | Out-Null
        $item.SubItems.Add($dns.Ping) | Out-Null
        $listView.Items.Add($item) | Out-Null
    }
}
Update-ListView
$form.Controls.Add($listView)

# --- CLICK TO SELECT LOGIC ---
$listView.Add_SelectedIndexChanged({
    if ($listView.SelectedItems.Count -gt 0) {
        $selectedName = $listView.SelectedItems[0].Text
        $matchedDNS = $dnsServers | Where-Object { $_.Name -eq $selectedName }
        if ($matchedDNS) {
            $txtPrimary.Text = $matchedDNS.Primary
            $txtSecondary.Text = $matchedDNS.Secondary
            $statusLabel.Text = "Selected: $($matchedDNS.Name)"
            $statusLabel.ForeColor = $OrangeColor
        }
    }
})

# Live Test Button
$btnTest = New-Object System.Windows.Forms.Button
$btnTest.Text = "  RUN LIVE DNS SPEED TEST"
$btnTest.Size = New-Object System.Drawing.Size(460, 40)
$btnTest.Location = New-Object System.Drawing.Point(30, 330)
$btnTest.BackColor = $OrangeColor
$btnTest.ForeColor = [System.Drawing.Color]::Black
$btnTest.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnTest.FlatStyle = "Flat"
$btnTest.FlatAppearance.BorderSize = 0

# Status Label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Status: Ready to test or select from list"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$statusLabel.ForeColor = $WhiteColor
$statusLabel.Location = New-Object System.Drawing.Point(30, 380)
$statusLabel.Size = New-Object System.Drawing.Size(460, 20)
$statusLabel.TextAlign = "Center"
$form.Controls.Add($statusLabel)

$btnTest.Add_Click({
    $statusLabel.Text = "Testing Latency... Please wait..."
    $statusLabel.ForeColor = $OrangeColor
    $form.Refresh()
    $bestPing = 9999
    $bestDNS = $null

    for ($i = 0; $i -lt $dnsServers.Count; $i++) {
        $ip = $dnsServers[$i].Primary
        $pingResult = Test-Connection -ComputerName $ip -Count 2 -ErrorAction SilentlyContinue
        if ($pingResult) {
            $avgPing = [Math]::Round(($pingResult | Measure-Object ResponseTime -Average).Average)
            $dnsServers[$i].Ping = "$avgPing ms"
            if ($avgPing -lt $bestPing) { $bestPing = $avgPing; $bestDNS = $dnsServers[$i] }
        } else { $dnsServers[$i].Ping = "Timeout" }
    }
    Update-ListView
    if ($bestDNS) {
        $statusLabel.Text = "RECOMMENDED: $($bestDNS.Name) ($bestPing ms)"
        $statusLabel.ForeColor = [System.Drawing.Color]::LimeGreen
        $txtPrimary.Text = $bestDNS.Primary
        $txtSecondary.Text = $bestDNS.Secondary
    }
})
$form.Controls.Add($btnTest)

# =========================================================================
# SECTION 3: DNS CONFIGURATION BOXES
# =========================================================================
$lblCustomTitle = New-Object System.Windows.Forms.Label
$lblCustomTitle.Text = "--- CONFIGURATION PANEL (SELECTED / CUSTOM DNS) ---"
$lblCustomTitle.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblCustomTitle.ForeColor = $OrangeColor
$lblCustomTitle.Location = New-Object System.Drawing.Point(30, 415)
$lblCustomTitle.Size = New-Object System.Drawing.Size(460, 20)
$lblCustomTitle.TextAlign = "Center"
$form.Controls.Add($lblCustomTitle)

# Primary DNS Input
$lblPrimary = New-Object System.Windows.Forms.Label
$lblPrimary.Text = "Primary DNS:"
$lblPrimary.ForeColor = $WhiteColor
$lblPrimary.Location = New-Object System.Drawing.Point(40, 445)
$lblPrimary.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblPrimary)

$txtPrimary = New-Object System.Windows.Forms.TextBox
$txtPrimary.Size = New-Object System.Drawing.Size(300, 25)
$txtPrimary.Location = New-Object System.Drawing.Point(150, 442)
$txtPrimary.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$txtPrimary.ForeColor = $WhiteColor
$txtPrimary.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$form.Controls.Add($txtPrimary)

# Secondary DNS Input
$lblSecondary = New-Object System.Windows.Forms.Label
$lblSecondary.Text = "Secondary DNS:"
$lblSecondary.ForeColor = $WhiteColor
$lblSecondary.Location = New-Object System.Drawing.Point(40, 480)
$lblSecondary.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($lblSecondary)

$txtSecondary = New-Object System.Windows.Forms.TextBox
$txtSecondary.Size = New-Object System.Drawing.Size(300, 25)
$txtSecondary.Location = New-Object System.Drawing.Point(150, 477)
$txtSecondary.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$txtSecondary.ForeColor = $WhiteColor
$txtSecondary.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$form.Controls.Add($txtSecondary)

# =========================================================================
# EXECUTION BUTTONS (APPLY / RESTORE)
# =========================================================================
# APPLY BUTTON
$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = "APPLY ALL SETTINGS"
$btnApply.Size = New-Object System.Drawing.Size(220, 50)
$btnApply.Location = New-Object System.Drawing.Point(30, 540)
$btnApply.BackColor = $OrangeColor
$btnApply.ForeColor = [System.Drawing.Color]::Black
$btnApply.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnApply.FlatStyle = "Flat"
$btnApply.FlatAppearance.BorderSize = 0

$btnApply.Add_Click({
    # 1. Apply DNS from Input Boxes
    if ($txtPrimary.Text -ne "") {
        $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
        foreach ($adapter in $adapters) {
            if ($txtSecondary.Text -ne "") {
                Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses ($txtPrimary.Text, $txtSecondary.Text) -ErrorAction SilentlyContinue
            } else {
                Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses ($txtPrimary.Text) -ErrorAction SilentlyContinue
            }
        }
    }
    Clear-DnsClientCache -ErrorAction SilentlyContinue

    # 2. Registry Tweaks: Network Throttling
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (Test-Path $registryPath) {
        if ($rbThrottleDisable.Checked) {
            Set-ItemProperty -Path $registryPath -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $registryPath -Name "SystemResponsiveness" -Value 0 -ErrorAction SilentlyContinue
        } else {
            Set-ItemProperty -Path $registryPath -Name "NetworkThrottlingIndex" -Value 10 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $registryPath -Name "SystemResponsiveness" -Value 20 -ErrorAction SilentlyContinue
        }
    }
    
    # 3. Registry Tweaks: Nagle's Algorithm (TCP Delay)
    $interfacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    if (Test-Path $interfacesPath) {
        $subKeys = Get-ChildItem -Path $interfacesPath
        foreach ($key in $subKeys) {
            if ($rbNagleDisable.Checked) {
                Set-ItemProperty -Path $key.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $key.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -ErrorAction SilentlyContinue
            } else {
                Remove-ItemProperty -Path $key.PSPath -Name "TcpAckFrequency" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $key.PSPath -Name "TCPNoDelay" -ErrorAction SilentlyContinue
            }
        }
    }
    
    [System.Windows.Forms.MessageBox]::Show("Network settings and DNS updated successfully!", "SRP Success", "OK", "Information")
})
$form.Controls.Add($btnApply)

# RESTORE TO DEFAULT BUTTON (DHCP)
$btnRestore = New-Object System.Windows.Forms.Button
$btnRestore.Text = "RESTORE DEFAULT (DHCP)"
$btnRestore.Size = New-Object System.Drawing.Size(220, 50)
$btnRestore.Location = New-Object System.Drawing.Point(270, 540)
$btnRestore.BackColor = $GrayColor
$btnRestore.ForeColor = $WhiteColor
$btnRestore.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRestore.FlatStyle = "Flat"
$btnRestore.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
$btnRestore.FlatAppearance.BorderSize = 1

$btnRestore.Add_Click({
    # Reset DNS to Default
    $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
    foreach ($adapter in $adapters) {
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ResetServerAddresses -ErrorAction SilentlyContinue
    }
    Clear-DnsClientCache -ErrorAction SilentlyContinue
    $txtPrimary.Text = ""
    $txtSecondary.Text = ""
    $statusLabel.Text = "Status: Reverted to DHCP Default"
    $statusLabel.ForeColor = $WhiteColor
    
    # Reset UI Options
    $rbNagleEnable.Checked = $true
    $rbThrottleEnable.Checked = $true
    
    # Reset Network Throttling Registry to Default
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (Test-Path $registryPath) {
        Set-ItemProperty -Path $registryPath -Name "NetworkThrottlingIndex" -Value 10 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $registryPath -Name "SystemResponsiveness" -Value 20 -ErrorAction SilentlyContinue
    }

    # Reset Nagle's Algorithm Registry to Default
    $interfacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    if (Test-Path $interfacesPath) {
        $subKeys = Get-ChildItem -Path $interfacesPath
        foreach ($key in $subKeys) {
            Remove-ItemProperty -Path $key.PSPath -Name "TcpAckFrequency" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $key.PSPath -Name "TCPNoDelay" -ErrorAction SilentlyContinue
        }
    }

    [System.Windows.Forms.MessageBox]::Show("All network configurations reverted to official Windows Default.", "Restored", "OK", "Information")
})
$form.Controls.Add($btnRestore)

# Show Interface
$form.ShowDialog()