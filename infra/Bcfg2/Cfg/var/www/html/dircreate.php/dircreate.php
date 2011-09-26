<!--# BCFG2-IG $Id: dircreate.php 176 2010-09-21 20:13:40Z dave $ 
# Local modifications WILL be lost -->
<html>
<body>
<?php 
$dir= $_POST["dir"]; 
$cmd= "sudo /usr/local/bin/createsvnrepo $dir";
$last_line = system("$cmd", $retval);
#echo $joe;
// Printing additional info

echo '
</pre>
<hr />Last line of the output: ' . $last_line . '
<hr />Return value: ' . $retval;
$cmd2="sudo /usr/local/bin/gen-svn-group";
system ($cmd2);
?><br />
</body>
</html> 
