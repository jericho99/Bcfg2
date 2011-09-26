#!/usr/bin/perl
   # In your configuration file
#    rootproperty=blah

#    [section]
#    one=twp
#    three= four
#    Foo =Bar
#    empty=

#[ringroups-custom-4]
#exten = s,1,NoOp(Astreinte)
#exten = s,n,Dial(IAX2/4189079524/DDDkkkkkkk,25,i)

$renephone="4189302424";
$jeffphone="4182080997";
$davephone="4182305566";
$guilphone="4189556304";


use Asterisk::config;

my $sip_conf = new Asterisk::config(file=>'file.conf');
$sip_conf->assign_editkey(section=>'ringroups-custom-4',key=>'exten',new_value=>"s,n,Dial(IAX2/4189079524/$davephone,25,i)");  
$sip_conf->save_file(); 

    # In your program
#    use Config::Tiny;
#use Config::Simple;

    # Create a config
#    my $Config = Config::Tiny->new;


  # --- Simple usage. Loads the config. file into a hash:
#  Config::Simple->import_from('file.conf', \%Config);


#  # --- OO interface:
#  $cfg = new Config::Simple('file.conf');

  # accessing values:
#  $user = $cfg->param("ringroups-custom-4.exten");

  # getting the values as a hash:
#  %Config = $cfg->vars();

  # updating value with a string
#  $cfg->param('ringroups-custom-4.exten', 's,1,NoOp(Astreinte)');
#  $cfg->param('ringroups-custom-4.exten', "s,n,Dial(IAX2/4189079524/$davephone,25,i)");

 #$cfg->save();


    # Open the config
#    $Config = Config::Tiny->read( 'file.conf' );

    # Reading properties
#    my $one = $Config->{"ringroups-custom-4"}->{exten};

    # Changing data
#    $Config->{"ringroups-custom-4"}->{exten} = 'exten = s,1,NoOp(Astreinte)';     # Change a value
#    $Config->{"ringroups-custom-4"}->{exten2} = "exten = s,n,Dial(IAX2/4189079524/$davephone,25,i)";     # Change a value

    # Save a config
#    $Config->write( 'file.conf' );

