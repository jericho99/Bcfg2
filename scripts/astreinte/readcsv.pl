#!/usr/bin/perl
use DBI;

my $DB_TYPE = "mysql";
my $DB_HOST = "127.0.0.1";
my $DB_PORT = "3306";
my $DB_NAME = "astreinte";
my $DB_USER = "root";
my $DB_PASSWORD = "q1w2e3";
$dbh = DBI->connect( "dbi:$DB_TYPE:$DB_NAME:$DB_HOST:$DB_PORT", $DB_USER, $DB_PASSWORD )or die $DBI::errstr;

$sql="truncate user";
$sth = $dbh->prepare($sql);
$sth->execute();

$renephone="4189302424";
$jeffphone="4182080997";
$davephone="4182305566";
$guilphone="4189556304";

$data_filew2="text.csv";
open(DATA, $data_filew2) || die("Could not open file!");
@raw_data=<DATA>;
close(DATA);
#print @raw_data;
my @values = split(' ',$data);


foreach $key (@raw_data){
chop($key);
my @values = split(',',$key);
$date1="$values[0] $values[1] $values[2]";
$user=$values[3];

$date2=`date "+%F" --date="$date1"`;
$sql="truncate user";
$sql1 = "insert into user values ('$user','$date2');";
$sth2 = $dbh->prepare($sql1);
$sth2->execute();
}

