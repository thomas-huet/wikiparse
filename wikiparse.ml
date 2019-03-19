exception Unexpected of Xmlm.signal * string

let process_text s =
  let lexbuf = Lexing.from_string s in
  Wikitext.main lexbuf

let rec input tags =
  let rec find key = function
  | [] -> input []
  | (k, v) :: t ->
    if k = key then
      v
    else
      find key t
  in
  let rec input i = match Xmlm.input i with
  | `El_end -> 0
  | `El_start((_, tag), _) ->
    let n = (find tag tags) i in
    if n > 0 then
      n - 1
    else
      input i
  | _ -> input i
  in
  input

let rec string s i = match Xmlm.input i with
| `El_end -> s
| `Data(s) -> string s i
| u -> raise (Unexpected(u, "string"))

let close i = ignore (input [] i)

let input_doc =
  input [
    "mediawiki", input [
      "page", input [
        "ns", (fun i -> if string "" i = "0" then 0 else (close i; 1));
        "redirect", (fun i -> close i; close i; 1);
        "revision", input [
          "text", (fun i -> process_text (string "" i); 0)
        ]
      ]
    ]
  ]

let stdin = Xmlm.make_input (`Channel stdin)

let _ = input_doc stdin
