#!/usr/bin/perl
# BCFG2-IG
# $Id: backup.pl 489 2011-02-08 14:39:33Z dave $
# Local modifications WILL be lost

use Mail::Sender;
use POSIX;

my @mysrv = ("vmprod1",
	"vmprod2",
	"vmdev1",
	"vmdev2",
	"vmdmz",
	"vmsrv",
	"srvdns",
	"srvweb",
	"hades", 
	"websrv",
#	"patty", machine not up
	"selma",
	"hercule",
	"sshsrv",
	"quimby",
#	"srvdev", machine to be gone
	"webdev",
	"zeus",
	"srv-backup");

$time=strftime('%Y-%m-%d %T',localtime);
$to="sys\@infoglobe.ca";
$from="bkpsrv\@infoglobe.ca";
$rdiff="/usr/bin/rdiff-backup";
$logdir="/home/gestion/backup/log/";


foreach (@mysrv) {
@args="-v5 --print-statistics --no-acls --no-eas --include-globbing-filelist  /home/gestion/backup/conf/$_.conf $_:\:/ /backup/$_ 2>&1";
my $bdata = `$rdiff @args`;
my $backup = $?;


if ($backup == 0) {
open LOG, ">>$logdir/$_.log" or die "Cannot create logfile: $!";
print LOG "Remote backup completed on $time, Output:\n\n $bdata\n\n\n";
close LOG;
}else{

$sender = new Mail::Sender
        {smtp => '127.0.0.1', from => "$from"};
        $sender->Open({to => "$to",
        #$sender->MailFile({to => "ddoyon\@infoglobe.ca",
        subject => "Backup failled on host $_",
        });
        $sender->SendLineEnc("Backup failled on host $_"),
        $sender->SendLineEnc("$bdata"),
        $sender->Close()

}
}

