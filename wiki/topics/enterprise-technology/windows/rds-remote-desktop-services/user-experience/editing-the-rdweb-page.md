Eliminate “/RDWeb” from the RDS URL
<img width="787" height="446" alt="image" src="https://github.com/user-attachments/assets/09df11d4-9ced-4993-908c-4849fb6147f1" />

Password Reset Link

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

