# nov/13/2018 11:16:12 by RouterOS 6.42.9
# software id = ZNMWTNZM
#
# model = 2011UiAS2HnD
# serial number = 7A660770DE17

# email config
:global smtpserver ""
:global from ""
:global pass ""
:global port "587"
:global tls "yes"
:global user ""
:global maillist ""
:global backfilename "emailbak.backup"

# job creation config
:global jobname "schedbackupmail"
:global baktime "01:30:00"
:global bakinterval "7d"


# mail conf
/tool email set address=$smtpserver from=$from password=$pass port=$port starttls=$tls user=$user

# script create
/system script
add dont-require-permissions=yes name=backupmail owner=root policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/s\
    ystem backup save name=\"emailbak\"\r\
    \n:delay 10s\r\
    \n/tool e-mail send file=\"$backfilename\" to=\"$maillist\" body=\"See attached f\
    ile for System Backup\" subject=([/system identity get\
    \_name].\" \".[/system clock get date])"

	
# sched task create
/system scheduler
add name=$jobname on-event="backupmail" start-date=jan/01/1970 start-time=$baktime interval=$bakinterval comment="send backup to email" disabled=no	

# run task
/system script run backupmail

