module Test_bbhosts =

   let conf = "
# A comment

page firstpage My first page

group-compress  A group
1.2.3.4		amachine	# http://url.to/monitor https://another.url/to/monitor cont;http://a.cont.url/to/monitor;wordtofind
1.2.3.5		amachine2	# http://url.to/monitor https://another.url/to/monitor !cont;http://a.cont.url/to/monitor;wordtofind

group-only  dns  VIP DNS
10.50.25.48	mydnsmachine.network #
10.50.25.49     myotherdnsmachine.network #noping noconn !ssh dns;mydnstocheck
# a comment in a group


page anotherpage A new page

# a comment in a page

group-compress My test
192.168.0.2	myhost	# https://myurl.com:1256 noconn pop3 imap2 ssh
192.168.0.3	myhost2 # !imap2 telnet dns
"

   test BBhosts.lns get conf =
      {}
      { "#comment" = "A comment" }
      {}
      { "page" = "firstpage"
         { "title"          = "My first page" }
         {}
	 { "group-compress" = "A group"
	    { "host"
	       { "ip"   = "1.2.3.4" }
	       { "fqdn" = "amachine" }
	       { "probes"
	          { "url" = "http://url.to/monitor" }
		  { "url" = "https://another.url/to/monitor" }
		  { "cont" = ""
		     { "url"     = "http://a.cont.url/to/monitor" }
		     { "keyword" = "wordtofind" } } } }
	    { "host"
	       { "ip"   = "1.2.3.5" }
	       { "fqdn" = "amachine2" }
	       { "probes"
	          { "url" = "http://url.to/monitor" }
		  { "url" = "https://another.url/to/monitor" }
		  { "cont" = "!"
		     { "url"     = "http://a.cont.url/to/monitor" }
		     { "keyword" = "wordtofind" } } } }
            {} }
	  { "group-only" = "VIP DNS"
	     { "col" = "dns" }
	     { "host"
	        { "ip"   = "10.50.25.48" }
		{ "fqdn" = "mydnsmachine.network" }
		{ "probes" } }
             { "host"
	        { "ip"   = "10.50.25.49" }
		{ "fqdn" = "myotherdnsmachine.network" }
		{ "probes"
		   { "noping" = "" }
		   { "noconn" = "" }
		   { "ssh" = "!" }
		   { "dns" = ""
		      { "url" = "mydnstocheck" } } } }
	     { "#comment" = "a comment in a group" }
	     {}
	     {} } }
       { "page" = "anotherpage"
          { "title" = "A new page" }
	  {}
	  { "#comment" = "a comment in a page" }
	  {}
	  { "group-compress" = "My test"
	     { "host"
	        { "ip" = "192.168.0.2" }
		{ "fqdn" = "myhost" }
		{ "probes"
		   { "url" = "https://myurl.com:1256" }
		   { "noconn" = "" }
		   { "pop3" = "" }
		   { "imap2" = "" }
		   { "ssh" = "" } } }
	     { "host"
	        { "ip" = "192.168.0.3" }
		{ "fqdn" = "myhost2" }
		{ "probes"
		   { "imap2" = "!" }
		   { "telnet" = "" }
		   { "dns" = "" } } } } }

