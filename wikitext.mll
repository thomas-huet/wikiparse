let space = (
  [ ' ' '\t' '\n' '\'' '"' ',' '?' ';' ':' '(' ')' '*' '#' ]
  | "—" | "–"
  | "“" | "”"
  | "&nbsp;"
  | "==" '='+
  | [ '0' - '9' ]+ '%'
)+

rule main = parse
| "{{" { template lexbuf; main lexbuf }
| "<ref>" { reference lexbuf; main lexbuf }
| "<ref " { reference_tag lexbuf; main lexbuf }
| "<gallery>" { gallery lexbuf; main lexbuf }
| "<gallery " { gallery_tag lexbuf; main lexbuf }
| "<code>" { code lexbuf; main lexbuf }
| "<math>" { math lexbuf; main lexbuf }
| "<math " { math_tag lexbuf; main lexbuf }
| "<chem>" { chem lexbuf; main lexbuf }
| "<sub>" { sub lexbuf; main lexbuf }
| "<sup>" { sup lexbuf; main lexbuf }
| "<timeline>" { timeline lexbuf; main lexbuf }
| "<!--" { comment lexbuf; main lexbuf }
| "{|" { box lexbuf; main lexbuf }
| '[' { external_link lexbuf; main lexbuf }
| "[[" { Printf.printf "%s" (link (Buffer.create 5) lexbuf); main lexbuf }
| '.' { main lexbuf }
| space { Printf.printf " "; main lexbuf }
| "==" { title lexbuf; main lexbuf }
| '<' { tag lexbuf; main lexbuf }
| _ as c { Printf.printf "%c" c; main lexbuf }
| eof { Printf.printf "\n" }

and template = parse
| "}}" {}
| "{{" { template lexbuf; template lexbuf }
| _ { template lexbuf }
| eof {}

and reference_tag = parse
| "/>" {}
| ">" { reference lexbuf }
| _ { reference_tag lexbuf }
| eof {}

and reference = parse
| "</ref>" {}
| "<ref>" { reference lexbuf; reference lexbuf }
| "<ref " { reference_tag lexbuf; reference lexbuf }
| _ { reference lexbuf }
| eof {}

and gallery_tag = parse
| "/>" {}
| ">" { gallery lexbuf }
| _ { gallery_tag lexbuf }
| eof {}

and gallery = parse
| "</gallery>" {}
| "<gallery>" { gallery lexbuf; gallery lexbuf }
| "<gallery " { gallery_tag lexbuf; gallery lexbuf }
| _ { gallery lexbuf }
| eof {}

and code = parse
| "</code>" {}
| "<code>" { code lexbuf; code lexbuf }
| _ { code lexbuf }
| eof {}

and math_tag = parse
| "/>" {}
| ">" { math lexbuf }
| _ { math_tag lexbuf }
| eof {}

and math = parse
| "</math>" {}
| "<math>" { math lexbuf; math lexbuf }
| _ { math lexbuf }
| eof {}

and chem = parse
| "</chem>" {}
| "<chem>" { chem lexbuf; chem lexbuf }
| _ { chem lexbuf }
| eof {}

and sub = parse
| "</sub>" {}
| "<sub>" { sub lexbuf; sub lexbuf }
| _ { sub lexbuf }
| eof {}

and sup = parse
| "</sup>" {}
| "<sup>" { sup lexbuf; sup lexbuf }
| _ { sup lexbuf }
| eof {}

and timeline = parse
| "</timeline>" {}
| "<timeline>" { timeline lexbuf; timeline lexbuf }
| _ { timeline lexbuf }
| eof {}

and comment = parse
| "-->" {}
| _ { comment lexbuf }
| eof {}

and box = parse
| "|}" {}
| "{|" { box lexbuf; box lexbuf }
| "[[" { ignore (link (Buffer.create 5) lexbuf); box lexbuf }
| _ { box lexbuf }
| eof {}

and external_link = parse
| ']' {}
| _ { external_link lexbuf }
| eof {}

and link buf = parse
| "{{" { template lexbuf; link buf lexbuf }
| "<ref>" { reference lexbuf; link buf lexbuf }
| "<ref " { reference_tag lexbuf; link buf lexbuf }
| "<gallery>" { gallery lexbuf; link buf lexbuf }
| "<gallery " { gallery_tag lexbuf; link buf lexbuf }
| "<code>" { code lexbuf; link buf lexbuf }
| "<math>" { math lexbuf; link buf lexbuf }
| "<math " { math_tag lexbuf; link buf lexbuf }
| "<chem>" { chem lexbuf; link buf lexbuf }
| "<sub>" { sub lexbuf; link buf lexbuf }
| "<sup>" { sup lexbuf; link buf lexbuf }
| "<timeline>" { timeline lexbuf; link buf lexbuf }
| "<!--" { comment lexbuf; link buf lexbuf }
| "{|" { box lexbuf; link buf lexbuf }
| "]]" { Buffer.contents buf }
| [ '|' ':' ] { Buffer.clear buf; link buf lexbuf }
| "[[" { Buffer.add_string buf (link (Buffer.create 5) lexbuf); link buf lexbuf }
| '.' { link buf lexbuf }
| space { Buffer.add_char buf ' '; link buf lexbuf }
| '<' { tag lexbuf; link buf lexbuf }
| _ as c { Buffer.add_char buf c; link buf lexbuf }
| eof { "" }

and title = parse
| "==" { Printf.printf "\n" }
| _ { title lexbuf }
| eof {}

and tag = parse
| '>' {}
| _ { tag lexbuf }
| eof {}

