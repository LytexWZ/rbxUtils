@echo off
title Rbx Friend utils by LytexWZ
mode con: cols=140 lines=35
color f
:::
::: _______   __                        ________            __                            __                    __      __  __           
:::|       \ |  \                      |        \          |  \                          |  \                  |  \    |  \|  \          
:::| $$$$$$$\| $$____   __    __       | $$$$$$$$  ______   \$$  ______   _______    ____| $$       __    __  _| $$_    \$$| $$  _______ 
:::| $$__| $$| $$    \ |  \  /  \      | $$__     /      \ |  \ /      \ |       \  /      $$      |  \  |  \|   $$ \  |  \| $$ /       \
:::| $$    $$| $$$$$$$\ \$$\/  $$      | $$  \   |  $$$$$$\| $$|  $$$$$$\| $$$$$$$\|  $$$$$$$      | $$  | $$ \$$$$$$  | $$| $$|  $$$$$$$
:::| $$$$$$$\| $$  | $$  >$$  $$       | $$$$$   | $$   \$$| $$| $$    $$| $$  | $$| $$  | $$      | $$  | $$  | $$ __ | $$| $$ \$$    \ 
:::| $$  | $$| $$__/ $$ /  $$$$\       | $$      | $$      | $$| $$$$$$$$| $$  | $$| $$__| $$      | $$__/ $$  | $$|  \| $$| $$ _\$$$$$$\
:::| $$  | $$| $$    $$|  $$ \$$\      | $$      | $$      | $$ \$$     \| $$  | $$ \$$    $$       \$$    $$   \$$  $$| $$| $$|       $$
::: \$$   \$$ \$$$$$$$  \$$   \$$       \$$       \$$       \$$  \$$$$$$$ \$$   \$$  \$$$$$$$        \$$$$$$     \$$$$  \$$ \$$ \$$$$$$$ 
:::
:::
:::
:::                                                                                                                                     
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
)
echo Initializing the virtual environment...
echo.
timeout /t 3 /nobreak > NUL
powershell -Command ^
    "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null;" ^
    "$result = [System.Windows.Forms.MessageBox]::Show('Have the requirements already been installed? Click Yes to skip installation, No to install.', 'Requirements Check', [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question);" ^
    "if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 6 } else { exit 7 }"

if %errorlevel% equ 6 goto :A
python -m pip install --upgrade pip

set requirements=^
requests ^
pandas

for %%p in (%requirements%) do (
    echo Installing %%p...
    pip install %%p
)
echo All packages installed successfully.
:A
timeout /t 3 /nobreak > NUL

cls
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
)
echo Scripted by LytexWZ
echo.
python main.py
echo.
echo.
echo #===============================================================# 
echo #                    Software terminated.                       # 
echo #                                                               # 
echo #   Give me a Star on Github, this would really help me grow!   # 
echo #                 https://github.com/LytexWZ                    # 
echo #                                                               #
echo #                                                               #
echo #                         Thank You!                            #
echo #===============================================================# 
echo.
echo.
pause