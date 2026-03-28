@echo off
setlocal enabledelayedexpansion
cd /d "C:\Users\sabin\OneDrive\Desktop\CLAUDE WIP\WEST CAPITAL LENDING\AI SYSTEM\SKILLS"

echo.
echo ==========================================
echo   WEST CAPITAL QUOTE — DEPLOY + VERIFY
echo ==========================================
echo.

:: ── STEP 1: Branch check ──
echo [1/5] Checking branch...
for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%b
if not "!BRANCH!"=="main" (
  echo.
  echo [WARN] You are on branch: !BRANCH!
  echo        This should be 'main'. Switching now...
  git checkout main
  if !ERRORLEVEL! NEQ 0 (
    echo [ERROR] Could not switch to main. Aborting.
    pause & exit /b 1
  )
)
echo [OK] On branch: main
echo.

:: ── STEP 2: Stage + commit if needed ──
echo [2/5] Checking for uncommitted changes...
git status --short
for /f "tokens=*" %%s in ('git status --short') do set DIRTY=%%s
git diff --quiet HEAD
if !ERRORLEVEL! NEQ 0 (
  echo [INFO] Uncommitted changes found. Staging index.html...
  git add index.html
  git commit -m "Auto-commit: deploy script"
  echo [OK] Committed.
) else (
  echo [OK] Nothing to commit — working tree clean.
)
echo.

:: ── STEP 3: Push ──
echo [3/5] Pushing to origin/main...
git push origin main
if !ERRORLEVEL! NEQ 0 (
  echo.
  echo [FAIL] Push failed! Check your internet or repo permissions.
  pause & exit /b 1
)
echo [OK] Push successful.
echo.

:: ── STEP 4: Wait for GitHub Pages ──
echo [4/5] Waiting 50 seconds for GitHub Pages to rebuild...
for /l %%i in (1,1,50) do (
  set /p =.< nul
  timeout /t 1 /nobreak >nul
)
echo.
echo [OK] Done waiting.
echo.

:: ── STEP 5: Live site verification ──
echo [5/5] Running live verification on GitHub Pages...
echo.

set URL=https://sabino7sanchez-ship-it.github.io/west-capital-quote/

powershell -NoProfile -Command ^
  "$url = '%URL%';" ^
  "Write-Host 'Fetching: ' $url;" ^
  "try { $html = (Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 20).Content } catch { Write-Host '[ERROR] Could not reach site: ' $_.Exception.Message -ForegroundColor Red; exit 1 };" ^
  "$pass = 0; $fail = 0;" ^
  "$checks = [ordered]@{" ^
  "  'Page loads'           = 'West Capital Lending';" ^
  "  'Quick Fill present'   = 'Quick Fill';" ^
  "  'Amort chart present'  = 'amortChart';" ^
  "  'Invest section'       = 'investSection';" ^
  "  'Power pay slider'     = 'powerPaySlider';" ^
  "  'Access gate'          = 'gateView';" ^
  "  'Branding intact'      = 'Sanchez_ElevationAI';" ^
  "  'Step labels present'  = 'form-step-label'" ^
  "};" ^
  "$bads = @{'Social Media removed' = 'SOCIAL MEDIA LINKS'; 'No old IG field' = 'f_ig'; 'No old FB field' = 'f_fb'};" ^
  "Write-Host '';" ^
  "Write-Host '--- MUST BE PRESENT ---' -ForegroundColor Cyan;" ^
  "foreach ($k in $checks.Keys) {" ^
  "  if ($html -match [regex]::Escape($checks[$k])) {" ^
  "    Write-Host (\" [PASS] $k\") -ForegroundColor Green; $pass++" ^
  "  } else {" ^
  "    Write-Host (\" [FAIL] $k  (looking for: '$($checks[$k])')\") -ForegroundColor Red; $fail++" ^
  "  }" ^
  "};" ^
  "Write-Host '';" ^
  "Write-Host '--- MUST BE ABSENT ---' -ForegroundColor Cyan;" ^
  "foreach ($k in $bads.Keys) {" ^
  "  if ($html -match [regex]::Escape($bads[$k])) {" ^
  "    Write-Host (\" [FAIL] $k  ('$($bads[$k])' still found!)\") -ForegroundColor Red; $fail++" ^
  "  } else {" ^
  "    Write-Host (\" [PASS] $k\") -ForegroundColor Green; $pass++" ^
  "  }" ^
  "};" ^
  "Write-Host '';" ^
  "if ($fail -eq 0) {" ^
  "  Write-Host '  ALL CHECKS PASSED — Site is live and correct.' -ForegroundColor Green" ^
  "} else {" ^
  "  Write-Host \"  $fail CHECK(S) FAILED — Review above before sending to Manny.\" -ForegroundColor Red" ^
  "};" ^
  "Write-Host '';" ^
  "Write-Host \"  Passed: $pass  |  Failed: $fail  |  URL: $url\";"

echo.
echo ==========================================
echo   Done. Live URL:
echo   https://sabino7sanchez-ship-it.github.io/west-capital-quote/
echo ==========================================
echo.
pause
