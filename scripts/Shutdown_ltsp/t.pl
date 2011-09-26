    use Net::Ping;
@host=("10.10.1.141",
"10.10.1.142",
"10.10.1.143",
"10.10.1.144",
"10.10.1.145",
"10.10.1.146",
"10.10.1.147");

foreach (@host){
    $p = Net::Ping->new();
 print "$_ is alive.\n" if $p->ping($_);

    $p->close();
}
