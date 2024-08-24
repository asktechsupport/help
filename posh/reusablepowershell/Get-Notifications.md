![image](https://github.com/user-attachments/assets/3eafc80d-f5ff-4126-8fca-24ba9021fbd7)


### Heading 1
### Heading 1
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
$wshell = New-Object -ComObject Wscript.Shell
$notificationText = "Write your text here"
$Output = $wshell.Popup($notificationText,0,"Information",0+64)
```
#More options for notifications
* #0 — OK button;
* #1 — OK and Cancel buttons;
* #2 — Stop, Retry and Skip buttons;
* #3 — Yes, No and Cancel buttons;
* #4 — Yes and No buttons;
* #5 — Retry and Cancel buttons;
* #16 — Stop icon;
* #32 — Question icon;
* #48 — Exclamation icon;
* #64 — Information icon.

> [!NOTE]
> Help: `#Popup(<Text>,<SecondsToWait>,<Title>,<Type>)`


#credit @ https://woshub.com/popup-notification-powershell/
#>
