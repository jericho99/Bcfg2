#!/usr/bin/perl
use DBI;
use Asterisk::config;
use Mail::Sender;

$date=`date "+%F"`;
$dateM=`date "+%A"`;
#$date="2011-02-28";
my $DB_TYPE = "mysql";
my $DB_HOST = "127.0.0.1";
my $DB_PORT = "3306";
my $DB_NAME = "astreinte";
my $DB_USER = "root";
my $DB_PASSWORD = "q1w2e3";
$dbh = DBI->connect( "dbi:$DB_TYPE:$DB_NAME:$DB_HOST:$DB_PORT", $DB_USER, $DB_PASSWORD )or die $DBI::errstr;

$renephone="4189302424";
$renemail="rpurcell\@infglobe.ca";
$jeffphone="4182080997";
$jeffmail="jfsaucier\@infglobe.ca";
$davephone="4182305566";
$davemail="ddoyon\@infglobe.ca";
$guilphone="4189556304";
$guilmail="gvachon\@infglobe.ca";
$nonphone="4182222222";
$nonmail="ddoyon\@infglobe.ca";

$query="select user from user where date='$date'";
$sth = $dbh->prepare($query);
$sth->execute();

while (@result = $sth->fetchrow_array) {
##############33### set var to result ##################
$user=$result[0];

if ($result[0]  =~ m/Jeff/){
$phone=$jeffphone;
$mail=$jeffmail;
}
elsif ($result[0] =~ m/Rene/){
$phone=$renephone;
$mail=$renemail;
}
elsif ($result[0] =~ m/Guillaume/){
$phone=$guilphone;
$mail=$guilmail;

}
elsif ($result[0] =~ m/David D/){
$phone=$davephone;
$mail=$davemail;
}else{
$phone=$nonphone;
$phone=$nonmail;
}

####################### MODIF CONFIG ASTERISK #################################
#modifie first value exten
open EXTEN , 'extensions.conf' or die;
        my @exten = <EXTEN>;
        open EXTEN, '>extensions.conf' or die;
                foreach (@exten) {
                s/exten = s,1,NoOp\(Astreinte\)/exten2 = s,1,NoOp\(Astreinte\)/;
                print EXTEN $_;
        }
        close EXTEN;


##change phone via week

my $sip_conf = new Asterisk::config(file=>'extensions.conf');
$sip_conf->assign_editkey(section=>'ringroups-custom-4',key=>'exten',new_value=>"s,n,Dial(IAX2/4189079524/$phone,25,i)");
$sip_conf->save_file();


#change first value to before
open EXTEN, 'extensions.conf' or die;
        my @exten = <EXTEN>;
        open EXTEN, '>extensions.conf' or die;
                foreach (@exten) {
                s/exten2 = s,1,NoOp\(Astreinte\)/exten = s,1,NoOp\(Astreinte\)/;
                print EXTEN $_;
        }
        close EXTEN;
#print "$user $phone\n";

}


#if ($dateM =~ m/Monday/){

$sender = new Mail::Sender
        {smtp => '10.10.200.11', from => 'astreinte@infoglobe.ca'};
        $sender->MailMsg({to => "ddoyon\@infoglobe.ca",
        subject => "Astreinte",
        msg => "tu est en astreinte cette semaine $user",});
#}
