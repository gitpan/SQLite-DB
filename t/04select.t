use strict;
use Test;
BEGIN { plan tests => 8 }
use SQLite::DB;
my $db = SQLite::DB->new("foo");
ok($db);
ok($db->connect);
ok($db->select("SELECT * FROM F",\&select_callback1));
ok($db->select("SELECT f.f1 FROM f WHERE f.f1 LIKE ?",\&select_callback2,'%Luck%'));
ok($db->disconnect);

sub select_callback1 {
    my $sth = (defined $_[0]) ? shift : return;
    my $row = $sth->fetch;
    ok($row);
    ok(@$row, 3);
    print join(", ", @$row), "\n";
}
sub select_callback2 {
    my $sth = (defined $_[0]) ? shift : return;
    my $rec = 0;
    while (my $d = $sth->fetchrow_hashref) {
	$rec++;
	ok($rec);
	print "> Record ".$rec."\n";
	for (keys %$d) {
	    print "  ".$_." : ".$d->{$_}."\n";
	}
    }   
}

