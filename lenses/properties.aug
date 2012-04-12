(* Augeas module for editing tomcat properties files
 Author: Craig Dunn <craig@craigdunn.org>

 FIXME: Doesn't cover everything that's legal in Java properties yet
        - multiline
        - key:value syntax
*)


module Properties =
  (* Define some basic primitives *)
  let empty        = Util.empty
  let eol          = Util.eol
  let sepch        = del /[ \t]*=/ "="
  let value_to_eol = /[^ \t\n](.*[^ \t\n])?/
  let indent       = Util.indent
  let entry        = /[A-Za-z][A-Za-z0-9._]+/

  (* define comments and properties*)
  let bang_comment = [ label "!comment" . del /[ \t]*![ \t]*/ "! " . store /([^ \t\n].*[^ \t\n]|[^ \t\n])/ . eol ]
  let comment      = ( Util.comment | bang_comment )
  let property     = [ indent . key entry . sepch . (indent . store value_to_eol)? . eol ]

  (* setup our lens and filter*)
  let lns          = ( property | empty | comment  ) *
