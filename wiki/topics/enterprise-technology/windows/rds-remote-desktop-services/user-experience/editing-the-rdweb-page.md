

## Login Page
### Eliminate “/RDWeb” from the RDS URL
<img width="787" height="446" alt="image" src="https://github.com/user-attachments/assets/09df11d4-9ced-4993-908c-4849fb6147f1" />

### Password Reset Link

make a backup of pages

Go to this 📁
```
%windir%\Web\RDWeb\Pages\en-US\login.aspx
```
Find "userpass"
<img width="630" height="306" alt="image" src="https://github.com/user-attachments/assets/3a4aa478-98bc-4a16-a366-cde474df60c8" />

add
```
<tr>
<td align="right">
Click <a href="password.aspx" target="_blank">here</a> to reset your password.
</td>
</tr>
```
<img width="643" height="266" alt="image" src="https://github.com/user-attachments/assets/7eeb57f8-128f-422c-8f54-a07ec59b5169" />

### Edit Login Page Text
```
Set-RDWorkspace -Name "<YourBrandingHere>"
```

### Login page branding
```
%windir%\Web\RDWeb\Pages\images\
```
> [!TIP]
> 
>  logo_01.png – 16pixels x 16pixels, logo_02.png – 48pixels x 48pixels

* The “logo_01.png” file will replace the icon in the upper right corner.
  <img width="180" height="68" alt="image" src="https://github.com/user-attachments/assets/2bf4c9f7-412d-4926-97e4-1bbf36f66e11" />


* The “logo_02.png” file will replace the icon in the upper left corner.
<img width="406" height="158" alt="image" src="https://github.com/user-attachments/assets/9624ca33-ece2-4a9a-830f-5fa1051093a5" />

### Login Page Text: RDWAStrings.xml
<img width="960" height="331" alt="image" src="https://github.com/user-attachments/assets/b53b4065-f714-4e45-a86b-9ac310df984a" />

```
%windir%\Web\RDWeb\Pages\en-US\RDWAStrings.xml
```
Make changes as desired to reflect what you want displayed;
* PageTitle, line 3
* HeadingRDWA, line 10
* HeadingApplicationName, line 11
* Help, line 12

### Change the Microsoft Logo on Login Page
```
%windir%\web\rdweb\pages\images\mslogo_black.png
```
