#!/bin/sh
 
#Configure User
SERVER1=10.10.200.11
UNAME1=rlaberge
PWORD1=q1w2e3
UNAME2=rlaberge@tc2l.ca
PWORD2=q1w2e3
 
#Blank this out if you want to see folder sizes
HIDE="--nofoldersizes --skipsize"
 
imapsync --syncinternaldates --useheader 'Message-Id' \
--host1 ${SERVER1} --user1 ${UNAME1} \
--password1 ${PWORD1} --ssl1 \
--host2 imap.googlemail.com \
--port2 993 --user2 ${UNAME2} \
--password2 ${PWORD2} --ssl2 \
--authmech1 LOGIN --authmech2 LOGIN --split1 200 --split2 200 ${HIDE} \
--exclude 'Drafts|Spam'
 
#TO Sync Special Folders to Gmail
imapsync --syncinternaldates --useheader 'Message-Id' \
--host1 ${SERVER1} --user1 ${UNAME1} \
--password1 ${PWORD1} --ssl1 \
--host2 imap.googlemail.com \
--port2 993 --user2 ${UNAME2} \
--password2 ${PWORD2} --ssl2 \
--ssl2 --noauthmd5 --split1 200 --split2 200 ${HIDE} \
--folder "Inbox/sent-mail" --prefix2 '[Gmail]/' --regextrans2 's/Inbox\/Sent/Sent Mail/' \
--folder "Inbox/Courrier Envoy&AOk-" --prefix2 '[Gmail]/' --regextrans2 's/Inbox\/Sent/Sent Mail/' \
--folder "Inbox/Spam" --prefix2 '[Gmail]/' --regextrans2 's/Inbox\/Spam/Spam/' \
--folder "Inbox/Trash" --prefix2 '[Gmail]/' --regextrans2 's/Inbox\/Trash/Trash/' \
--folder "Inbox/Drafts" --prefix2 '[Gmail]/' --regextrans2 's/Inbox\/Drafts/Drafts/' \

