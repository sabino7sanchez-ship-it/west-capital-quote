@echo off
:: ── WEST CAPITAL — LIVE SITE STRESS TEST ──
:: Run this anytime to verify the GitHub Pages site is correct.
:: No deploy. Just checks.

set URL=https://sabino7sanchez-ship-it.github.io/west-capital-quote/

echo.
echo ==========================================
echo   WEST CAPITAL — LIVE SITE STRESS TEST
echo   %URL%
echo ==========================================
echo.

powershell -NoProfile -Command ^
  "$url = '%URL%';" ^
  "Write-Host 'Fetching live page...';" ^
  "try { $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 20; $html = $r.Content; Write-Host \"HTTP $($r.StatusCode) — $(($html.Length/1024).ToString('F1')) KB received.\" -ForegroundColor Cyan } catch { Write-Host '[ERROR] ' $_.Exception.Message -ForegroundColor Red; pause; exit 1 };" ^
  "$pass=0; $fail=0;" ^
  "$checks = [ordered]@{" ^
  "  'Page title correct'        = 'West Capital Lending - Your Personalized Quote';" ^
  "  'Admin gate present'        = 'gateView';" ^
  "  'Quick fill buttons'        = 'quickFill';" ^
  "  'Standard refi preset'      = 'Standard Refi';" ^
  "  'Rate drop preset'          = 'Rate Drop';" ^
  "  'Cash-out preset'           = 'Cash-Out';" ^
  "  'Amortization chart'        = 'amortChart';" ^
  "  'renderChart function'      = 'function renderChart';" ^
  "  'Investment projector'      = 'investSection';" ^
  "  'compoundFV function'       = 'function compoundFV';" ^
  "  'Power pay slider'          = 'powerPaySlider';" ^
  "  'renderPowerPay function'   = 'function renderPowerPay';" ^
  "  '3-step form labels'        = 'form-step-label';" ^
  "  'Countdown timer'           = 'countdownWrap';" ^
  "  'Cost of waiting section'   = 'waitingSection';" ^
  "  'The Closer card'           = 'closerSection';" ^
  "  'Accel payoff section'      = 'accelSection';" ^
  "  'Sticky bottom bar'         = 'stickyBar';" ^
  "  'Trust bar'                 = 'trust-bar';" ^
  "  'Branding protected'        = 'Sanchez_ElevationAI';" ^
  "  'Access code gate'          = 'checkGate';" ^
  "  'SMS share button'          = 'shareViaSMS';" ^
  "  'WhatsApp share button'     = 'shareViaWhatsApp';" ^
  "  'Daily quota system'        = 'DAILY_LIMIT';" ^
  "  'Auto-calc function'        = 'autoCalcAll'" ^
  "};" ^
  "$bads = [ordered]@{" ^
  "  'No Social Media section'   = 'SOCIAL MEDIA LINKS';" ^
  "  'No Instagram field'        = 'f_ig';" ^
  "  'No Facebook field'         = 'f_fb';" ^
  "  'No LinkedIn field'         = 'f_li';" ^
  "  'No TikTok field'           = 'f_tt'" ^
  "};" ^
  "Write-Host '';" ^
  "Write-Host '--- FEATURES: MUST BE PRESENT ---' -ForegroundColor Cyan;" ^
  "foreach ($k in $checks.Keys) {" ^
  "  if ($html -match [regex]::Escape($checks[$k])) {" ^
  "    Write-Host \"  [PASS] $k\" -ForegroundColor Green; $pass++" ^
  "  } else {" ^
  "    Write-Host \"  [FAIL] $k\" -ForegroundColor Red; $fail++" ^
  "  }" ^
  "};" ^
  "Write-Host '';" ^
  "Write-Host '--- REMOVED SECTIONS: MUST BE ABSENT ---' -ForegroundColor Cyan;" ^
  "foreach ($k in $bads.Keys) {" ^
  "  if ($html -match [regex]::Escape($bads[$k])) {" ^
  "    Write-Host \"  [FAIL] $k — STILL IN THE PAGE\" -ForegroundColor Red; $fail++" ^
  "  } else {" ^
  "    Write-Host \"  [PASS] $k\" -ForegroundColor Green; $pass++" ^
  "  }" ^
  "};" ^
  "Write-Host '';" ^
  "$total = $pass + $fail;" ^
  "if ($fail -eq 0) {" ^
  "  Write-Host \"  RESULT: $pass/$total PASSED — Everything looks correct.\" -ForegroundColor Green" ^
  "} else {" ^
  "  Write-Host \"  RESULT: $fail/$total FAILED — Do NOT send this link to Manny yet.\" -ForegroundColor Red" ^
  "};" ^
  "Write-Host '';"

echo.
pause
