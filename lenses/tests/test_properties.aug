module Test_properties =
    let conf = "
# Test tomcat properties file
#tomcat.commented.value=1
    # config
tomcat.port = 8080
tomcat.application.name=testapp
    tomcat.application.description=my test application
property.with_underscore=works
empty.property=
empty.property.withtrailingspaces=   
! more comments
"
(*

long.description=this is a description that happens to span \
	more than one line with a combination of tabs and \
        spaces \  
or not

overflow.description=\
  just wanted to indent it

=empty_property
key: value
key2:value2
key3 :value3

cheeses

spaces only
multi  spaces
  indented spaces

escaped\:colon=value
escaped\=equals=value
escaped\ space=value
*)

let lns = Properties.lns

test lns get conf =
    { }
    { "#comment" = "Test tomcat properties file" }
    { "#comment" = "tomcat.commented.value=1" }
    { "#comment" = "config" }
    { "tomcat.port" = "8080" }
    { "tomcat.application.name" = "testapp" }
    { "tomcat.application.description" = "my test application" }
    { "property.with_underscore" = "works" }
    { "empty.property" }
    { "empty.property.withtrailingspaces" }
    { "!comment" = "more comments" }

test lns put conf after
    set "tomcat.port" "99";
    set "tomcat.application.host" "foo.network.com"
    = "
# Test tomcat properties file
#tomcat.commented.value=1
    # config
tomcat.port = 99
tomcat.application.name=testapp
    tomcat.application.description=my test application
property.with_underscore=works
empty.property=
empty.property.withtrailingspaces=   
! more comments
tomcat.application.host=foo.network.com
"
(*

long.description=this is a description that happens to span \
	more than one line with a combination of tabs and \
        spaces \  
or not

overflow.description=\
  just wanted to indent it

=empty_property
key: value
key2:value2
key3 :value3

cheeses

spaces only
multi  spaces
  indented spaces

escaped\:colon=value
escaped\=equals=value
escaped\ space=value
*)
