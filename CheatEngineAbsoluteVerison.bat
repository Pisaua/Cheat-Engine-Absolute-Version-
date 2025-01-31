@echo off
color 0A

:: Checking if users.txt exists
if not exist users.txt (
    echo users.txt file not found. Creating file...
    echo. > users.txt
)

:MENU
cls
echo Welcome!
echo ================================
echo 1. Login
echo 2. Register
echo 3. Forgot Password
echo 4. Exit
set /p choice=Choose an option:

if "%choice%"=="1" goto LOGIN
if "%choice%"=="2" goto REGISTER
if "%choice%"=="3" goto FORGOT_PASSWORD
if "%choice%"=="4" exit

:LOGIN
cls
echo Please enter your username:
set /p username=
echo Please enter your password:
set /p password=

findstr /i "%username%:%password%" users.txt > nul
if %errorlevel% == 0 (
    echo Login successful!
    pause
    goto MAIN_MENU
) else (
    echo Invalid login or password. Please try again.
    pause
    goto MENU
)

:REGISTER
cls
echo Please enter your new username:
set /p new_user=
echo Please enter your new password:
set /p new_pass=

:: Generate a token (7-11 digits)
set /a token=%random%%%10000000000
echo %new_user%:%new_pass%:%token%>>users.txt
echo Registration successful! Your token is: %token%
echo Save this token for recovery purposes.
pause
goto MENU

:FORGOT_PASSWORD
cls
echo Please enter your username to recover your password:
set /p recover_user=

findstr /i "%recover_user%" users.txt > nul
if %errorlevel% == 0 (
    echo Enter the token you received during registration:
    set /p token_input=
    for /f "tokens=1,2,3 delims=:" %%a in ('findstr /i "%recover_user%" users.txt') do (
        if "%%c"=="%token_input%" (
            echo Token verified successfully!
            echo Enter new password:
            set /p new_pass=
            set "line=%recover_user%:%new_pass%:%token_input%"
            setlocal enabledelayedexpansion
            for /f "delims=" %%i in ('findstr /v "%recover_user%" users.txt') do (
                echo %%i>>temp_users.txt
            )
            echo !line!>>temp_users.txt
            move /y temp_users.txt users.txt > nul
            echo Password has been successfully changed!
            pause
            goto MENU
        ) else (
            echo Invalid token. Please try again.
            pause
            goto MENU
        )
    )
) else (
    echo Username not found. Please check and try again.
    pause
    goto MENU
)

:MAIN_MENU
cls
echo Welcome to the main menu, %username%!
echo ================================
echo 1. Play Game
echo 2. Shop
echo 3. News
echo 4. Log Out
set /p choice=Choose an option:

if "%choice%"=="1" goto GAME
if "%choice%"=="2" goto SHOP
if "%choice%"=="3" goto NEWS
if "%choice%"=="4" goto MENU

:GAME
cls
echo Enter the game name to play:
set /p game_name=
echo Searching for game %game_name%...
:: Fake search for the game
echo Game not found or failed to launch due to system error.
pause
goto MAIN_MENU

:SHOP
cls
echo Welcome to the Shop!
echo ========================
echo 1. Portal 1
echo 2. Battlefield 4
echo 3. More Games
set /p choice=Choose a game to view or buy:

if "%choice%"=="1" (
    echo Redirecting to Portal 1 page...
    start https://store.steampowered.com/app/400/Portal/
    pause
    goto MAIN_MENU
)

if "%choice%"=="2" (
    echo Redirecting to Battlefield 4 page...
    start https://store.steampowered.com/app/1238810/Battlefield_V/
    pause
    goto MAIN_MENU
)

if "%choice%"=="3" (
    echo No games found. 404 error.
    pause
    goto MAIN_MENU
)

:NEWS
cls
echo Latest News:
echo 1. Portal: The Ultimate Puzzle Experience - Play Now!
echo 2. Battlefield 4: Epic Battles Await You - Join Now!
pause
goto MAIN_MENU
