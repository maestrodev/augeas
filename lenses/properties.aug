(* Augeas module for editing Java properties files
 Author: Craig Dunn <craig@craigdunn.org>
*)


module Properties =
  (* Define some basic primitives *)
  let empty            = Util.empty
  let eol              = Util.eol
  let sepch            = del /[ \t]*(=|:)/ "="
  let value_to_eol     = store /([^ \t\n].*)?[^ \t\n\\]/
  let indent           = Util.indent
  let entry            = /[A-Za-z][A-Za-z0-9._]+/
  let backslash        = del /[\\][ ]*/ "\\ "
  let hardeol          = del "\n" "\n"

  (* store any line that begins with ' ' *)
  let multi_line_entry =
    let line = /[^ \t\n][^\n]+/ in
      [ indent . store line . backslash . hardeol ] + .
      [ indent . value_to_eol . eol ] . value " < multi > "

  (* define comments and properties*)
  let bang_comment     = [ label "!comment" . del /[ \t]*![ \t]*/ "! " . store /([^ \t\n].*[^ \t\n]|[^ \t\n])/ . eol ]
  let comment          = ( Util.comment | bang_comment )
  let property         = [ indent . key entry . sepch . ( multi_line_entry | indent . value_to_eol . eol ) ]
  let empty_property   = [ indent . key entry . sepch . eol ]

  (* setup our lens and filter*)
  let lns              = ( property | empty | comment | empty_property  ) *
