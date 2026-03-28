$url = 'https://sabino7sanchez-ship-it.github.io/west-capital-quote/'
$pass = 0
$fail = 0

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  WEST CAPITAL -- LIVE SITE STRESS TEST"
Write-Host "  $url" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Fetching live page..." -NoNewline

try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 20
    $html = $response.Content
    $kb = [math]::Round($html.Length / 1024, 1)
    Write-Host " HTTP $($response.StatusCode) - ${kb} KB" -ForegroundColor Green
} catch {
    Write-Host " FAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

function Check-Present($label, $token) {
    if ($html -match [regex]::Escape($token)) {
        Write-Host "  [PASS] $label" -ForegroundColor Green
        $script:pass++
    } else {
        Write-Host "  [FAIL] $label  (missing: '$token')" -ForegroundColor Red
        $script:fail++
    }
}

function Check-Absent($label, $token) {
    if ($html -match [regex]::Escape($token)) {
        Write-Host "  [FAIL] $label  (still present: '$token')" -ForegroundColor Red
        $script:fail++
    } else {
        Write-Host "  [PASS] $label" -ForegroundColor Green
        $script:pass++
    }
}

Write-Host ""
Write-Host "--- FEATURES: MUST BE PRESENT ---" -ForegroundColor Yellow
Check-Present "Page loads correctly"       "West Capital Lending"
Check-Present "Admin access gate"          "gateView"
Check-Present "Quick Fill buttons"         "quickFill"
Check-Present "Standard Refi preset"       "Standard Refi"
Check-Present "Rate Drop preset"           "Rate Drop"
Check-Present "Cash-Out preset"            "Cash-Out"
Check-Present "Amortization chart SVG"     "amortChart"
Check-Present "renderChart function"       "function renderChart"
Check-Present "Investment projector"       "investSection"
Check-Present "compoundFV function"        "function compoundFV"
Check-Present "Power Pay slider"           "powerPaySlider"
Check-Present "renderPowerPay function"    "function renderPowerPay"
Check-Present "3-step form labels"         "form-step-label"
Check-Present "Countdown timer"            "countdownWrap"
Check-Present "Cost of waiting"            "waitingSection"
Check-Present "The Closer card"            "closerSection"
Check-Present "Accel payoff section"       "accelSection"
Check-Present "Sticky bottom bar"          "stickyBar"
Check-Present "Trust bar"                  "trust-bar"
Check-Present "Branding protected"         "Sanchez_ElevationAI"
Check-Present "Access gate function"       "checkGate"
Check-Present "SMS share button"           "shareViaSMS"
Check-Present "WhatsApp share button"      "shareViaWhatsApp"
Check-Present "Daily quota system"         "DAILY_LIMIT"
Check-Present "Auto-calc function"         "autoCalcAll"
Check-Present "Breakeven section"          "breakevenSection"
Check-Present "Agent personal note"        "agentNoteWrap"

Write-Host ""
Write-Host "--- REMOVED CONTENT: MUST BE ABSENT ---" -ForegroundColor Yellow
Check-Absent "Social Media section gone"   "SOCIAL MEDIA LINKS"
Check-Absent "Instagram field gone"        "f_ig"
Check-Absent "Facebook field gone"         "f_fb"
Check-Absent "LinkedIn field gone"         "f_li"
Check-Absent "TikTok field gone"           "f_tt"

$total = $pass + $fail
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
if ($fail -eq 0) {
    Write-Host "  RESULT: $pass/$total PASSED -- Site is clean. Good to send." -ForegroundColor Green
} else {
    Write-Host "  RESULT: $fail FAILED out of $total -- Fix before sending to Manny." -ForegroundColor Red
}
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
