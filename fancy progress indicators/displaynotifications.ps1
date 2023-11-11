$wshell = New-Object -ComObject Wscript.Shell
$Output = $wshell.Popup("Information",0,"Information",0+64)

#More options for notifications
#0 — OK button;
#1 — OK and Cancel buttons;
#2 — Stop, Retry and Skip buttons;
#3 — Yes, No and Cancel buttons;
#4 — Yes and No buttons;
#5 — Retry and Cancel buttons;
#16 — Stop icon;
#32 — Question icon;
#48 — Exclamation icon;
#64 — Information icon.

#Help
#Popup(<Text>,<SecondsToWait>,<Title>,<Type>)

#credit @ https://woshub.com/popup-notification-powershell/
