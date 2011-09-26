#!/usr/bin/perl
use Config::Tiny;
use Asterisk::config;

$renephone="4189302424";
$jeffphone="4182080997";
$davephone="4182305566";
$guilphone="4189556304";


open CSV , 'text.csv' or die;
        my @csv = <CSV>;
        open CSV, '>text.csv' or die;
                foreach (@csv) {
		s/,,,,,,,//;
		s/,,"Congés et Vacances ",,,,,//;
		s/,,"congé tentatif",,,,,//;
		s/,,,,,,,//;
		s/,"24\/7","Guillaume","René","David T","Jeff","David D","Philippe"//;
		s/,,,,,,//g;
		s/"//g;
		s/René/Rene/g;
		s/^[\ \t]*\n//g;
                print CSV $_;
        }
        close CSV;

#$data_filew2="text.csv";
#open(DATA, $data_filew2) || die("Could not open file!");
#@raw_data=<DATA>;
#foreach (@csv) 







####################### MODIF CONFIG ASTERISK #################################
##modifie first value exten
#open EXTEN , 'extensions.conf' or die;
#        my @exten = <EXTEN>;
#        open EXTEN, '>extensions.conf' or die;
#                foreach (@exten) {
#                s/exten = s,1,NoOp\(Astreinte\)/exten2 = s,1,NoOp\(Astreinte\)/;
#                print EXTEN $_;
#        }
#        close EXTEN;


##change phone via week

#my $sip_conf = new Asterisk::config(file=>'extensions.conf');
#$sip_conf->assign_editkey(section=>'ringroups-custom-4',key=>'exten',new_value=>"s,n,Dial(IAX2/4189079524/$davephone,25,i)");
#$sip_conf->save_file();


##change first value to before
#open EXTEN, 'extensions.conf' or die;
#        my @exten = <EXTEN>;
#        open EXTEN, '>extensions.conf' or die;
#                foreach (@exten) {
#                s/exten2 = s,1,NoOp\(Astreinte\)/exten = s,1,NoOp\(Astreinte\)/;
#                print EXTEN $_;
#        }
#        close EXTEN;

