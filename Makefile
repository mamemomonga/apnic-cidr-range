all: var/delegated-apnic-latest var/country

var/delegated-apnic-latest:
	mkdir -p var
	curl -o $@ http://ftp.apnic.net/stats/apnic/delegated-apnic-latest

var/country:
	mkdir -p $@
	cat var/delegated-apnic-latest | bin/delegated2cidr.pl

clean:
	rm -rf var

