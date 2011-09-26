#!/usr/bin/perl

$|=1;
use Device::SerialPort;
use Net::LDAP;
use Sys::Syslog;
use Switch;
$DoorID = 2;
$PORT = "";
$DOOR = "";


$argc = @ARGV;
if (@ARGV!=3) {
  usage();
  exit();
}

foreach $argnum (0 .. $#ARGV+1) {
	($switch,$value) = split("=",$ARGV[$argnum]);
	switch ($switch) {
		case "--door" { $PORT = $value }
		case "--lock" { $DOOR = $value }
		case "--id"   { $DoorID = $value }
	}
}

openlog("CardManager", 'ndelay', 'user');
syslog('info', 'Starting');

my $PORT = $PORT;
my $DOOR = $DOOR;

my $Serial = Device::SerialPort->new ($PORT) || die "Can't Open $PORT: $!";
$Serial->baudrate(9600);
$Serial->parity("none");
$Serial->databits(8);
$Serial->handshake("none");
$Serial->write_settings;

my $timer = 0;
my $pin = "";

open(DEV, "<$PORT") || die "Cannot open $PORT: $_";

while ($_ = <DEV>) {
  chomp();
  $key = $_;
  if (length($key) == 2 && (time() - $timer < 6)) {
    $key = substr($key,0,1);
    if ($key == "B") {
      $pin = "";
      $timer = time();
    } else {
      $pin .= $key;
    }
    if (length($pin) == 4) {
      print "$facility-$cardnumber $pin\n";
      $pin = "";
      $cardnumber = "";
      $facility = "";
    }
  } elsif (length($key) == 15) {
    $timer = time();
    $pin = "";
    my $hex_string = substr($key, -11,8);
    my $binary_string = sprintf "%032b", hex( $hex_string );
    my $binary_card = substr($binary_string,-17,16);
    my $binary_facility = substr($binary_string,-25,8);
    $facility = sprintf("%03d",unpack("N", pack("B32","000000000000000000000000".$binary_facility)));
    $cardnumber = sprintf("%05d",unpack("N", pack("B32","0000000000000000".$binary_card)));
    syslog('info', "$facility-$cardnumber check");
    ($cardid,$carddoor,$cardpin,$uid) = &VerLDAP("$facility-$cardnumber");
    syslog('info', "$cardid,$carddoor,$uid");
    $cardtmp = "$facility-$cardnumber";

    if (($cardtmp == $cardid && substr($carddoor,$DoorID-1,1) == 1) || ($cardtmp =~ "183-41103|183-41102|183-41104|183-41117|183-41112")) {
       syslog('info', "$facility-$cardnumber ($uid) open door $DoorID");
       my $Serial = Device::SerialPort->new ($DOOR) || die "Can't Open $DOOR: $!";
       $Serial->baudrate(9600);
       $Serial->parity("none");
       $Serial->databits(8);
       $Serial->handshake("none");
       $Serial->write_settings;
       $Serial->pulse_dtr_on(3000);
    } else {
       syslog('info', "$facility-$cardnumber ($uid) refuse at door $DoorID");
    }
  }
}

sub VerLDAP() {
	$cardid = @_[0];
	$ldap = Net::LDAP->new( '10.10.200.11' ) or die "$@";

	$mesg = $ldap->bind ("cn=marcel,dc=marcel",
                       password => "sPEilZ5S",
                       version => 3);

	$mesg = $ldap->search( # perform a search
                        base   => "ou=Users,dc=marcel",
                        filter => "(cardid=$cardid)",
                        attrs => ['carddoor','cardpin','uid']);

	$mesg->code && die $mesg->error;
		$carddoor="";
		$cardpin="";
		$uid="";
	foreach my $entry ($mesg->entries) {
		$carddoor1 = ${$entry->get('carddoor')}[0];
		$cardpin1 = ${$entry->get('cardpin')}[0];
		$uid1 = ${$entry->get('uid')}[0];
		$carddoor=$carddoor1;
		$cardpin=$cardpin1;
		$uid=$uid1;
	}
	$mesg = $ldap->search( # perform a search
                        base   => "ou=Groups,dc=marcel",
                        filter => "(&(cn=service_idcard) (memberUid=$uid))",
                        attrs => ['memberUid']);

	$mesg->code && die $mesg->error;
	foreach my $entry ($mesg->entries) {
		@members = $entry->get_value('memberUid');
	}

	foreach $members(@members) {
                if (index($members,"$uid") ge 0) {
                	$ismember="1";
		}else{
			$ismember="2";
        	}
	}
	return ($cardid,$carddoor,$cardpin,$uid);
}

sub usage() {
	print "\n";
	print "Usage : CardManager.pl -d /dev/tty81a -l /dev/tty81e\n";
	print "        -d pour le device du lecteur de la porte\n";
	print "        -l pour le device du latch electrique de la porte\n";
	print "\n";
}

