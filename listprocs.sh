netstat -lp | perl -e 'print "\nPort  \t\tProcess\n\n"; while(<>){ print "$1  \t\t$2\n" if($_ =~ /\:(\w+).+LISTEN\s*(.+$)/); }'
