
type aggreg_syntax = [`A | `The] * string * string option (* quantifier, noun, adj_opt : adjective form is preferred *)

type func_syntax =
[ `Noun of string
| `Prefix of string
| `Infix of string
| `Brackets of string * string
| `Pattern of [`Kwd of string | `Func of string | `Arg of int] list ]

class virtual grammar =
object
  method virtual adjective_before_noun : bool

  method virtual thing : string
  method virtual relation : string
  method virtual value_ : string
  method virtual result : string
  method virtual is : string
  method virtual has : string
  method virtual has_as_a : string
  method virtual relative_that : string
  method virtual whose : string

  method virtual and_ : string
  method virtual or_ : string
  method virtual not_ : string
  method virtual optionally : string
  method virtual optional : string
  method virtual choice : string
  method virtual between : string

  method virtual of_ : string
  method virtual genetive_suffix : string option
  method virtual rel_to : string
  method virtual rel_from : string

  method virtual a_an : following:string -> string
  method virtual the : string
  method virtual every : string
  method virtual each : string
  method virtual all : string
  method virtual no : string
  method virtual any : string
  method virtual quantif_one : string
  method virtual quantif_of : string
  method virtual something : string
  method virtual anything : string
  method virtual everything : string
  method virtual nothing : string
  method virtual for_ : string

  method virtual n_th : int -> string

  method virtual string : string
  method virtual integer : string
  method virtual number : string
  method virtual date : string
  method virtual time : string
  method virtual date_and_time : string
  method virtual uri : string

  method virtual aggreg_syntax : Lisql.aggreg -> aggreg_syntax
  method virtual func_syntax : Lisql.func -> func_syntax
      
  method virtual order_highest : string
  method virtual order_lowest : string

  method virtual matches : string
  method virtual after : string
  method virtual before : string
  method virtual interval_from : string
  method virtual interval_to : string
  method virtual higher_or_equal_to : string
  method virtual lower_or_equal_to : string
  method virtual interval_between : string
  method virtual interval_and : string
  method virtual language : string
  method virtual datatype : string
  method virtual matching : string

  method virtual give_me : string
  method virtual there_is : string
  method virtual it_is_true_that : string
  method virtual where : string
  method virtual undefined : string

  method virtual tooltip_open_resource : string
  method virtual tooltip_delete_current_focus : string
  method virtual tooltip_remove_element_at_focus : string
  method virtual tooltip_focus_on_property : string
  method virtual tooltip_duplicate_focus : string
  method virtual tooltip_or : string
  method virtual tooltip_optionally : string
  method virtual tooltip_not : string
  method virtual tooltip_any : string
  method virtual tooltip_sample : string
  method virtual tooltip_aggreg : string
  method virtual tooltip_func : string
  method virtual tooltip_input_name : string
  method virtual tooltip_foreach_result : string
  method virtual tooltip_foreach : string
  method virtual tooltip_aggreg_id : string
  method virtual tooltip_highest : string
  method virtual tooltip_lowest : string
  method virtual tooltip_header_hide_focus : string
  method virtual tooltip_header_set_focus : string

  method virtual msg_permalink : string
  method virtual result_results : string * string
  method virtual entity_entities : string * string
  method virtual concept_concepts : string * string
  method virtual modifier_modifiers : string * string
end

let english =
object
  inherit grammar

  method adjective_before_noun = true

  method thing = "thing"
  method relation = "relation"
  method value_ = "value"
  method result = "result"
  method is = "is"
  method has = "has"
  method has_as_a = "has as a"
  method relative_that = "that"
  method whose = "whose"

  method and_ = "and"
  method or_ = "or"
  method not_ = "not"
  method optionally = "optionally"
  method optional = "optional"

  method of_ = "of"
  method genetive_suffix = Some "'s"
  method rel_to = "to"
  method rel_from = "from"

  method a_an ~following =
    let starts_with_vowel =
      try
	let c = Char.lowercase following.[0] in
	c = 'a' || c = 'e' || c = 'i' || c = 'o' (* || c = 'u' : 'u' is more often pronounced [y] *)
      with _ -> false in
    if starts_with_vowel
    then "an"
    else "a"
  method the = "the"
  method every = "every"
  method each = "each"
  method all = "all"
  method no = "no"
  method any = "any"
  method quantif_one = "one"
  method quantif_of = "of"
  method something = "something"
  method anything = "anything"
  method everything = "everything"
  method nothing = "nothing"
  method for_ = "for"
  method choice = "choice"
  method between = "between"

  method n_th n =
    let suffix =
      if n mod 10 = 1 && not (n mod 100 = 11) then "st"
      else if n mod 10 = 2 && not (n mod 100 = 12) then "nd"
      else if n mod 10 = 3 && not (n mod 100 = 13) then "rd"
      else "th" in
    string_of_int n ^ suffix

  method string = "string"
  method integer = "integer"
  method number = "number"
  method date = "date"
  method time = "time"
  method date_and_time = "date and time"
  method uri = "URI"

  method aggreg_syntax = function
  | Lisql.NumberOf -> `The, "number", None
  | Lisql.ListOf -> `The, "list", None
  | Lisql.Sample -> `A, "sample", None
  | Lisql.Total _ -> `The, "sum", Some "total"
  | Lisql.Average _ -> `The, "average", Some "average"
  | Lisql.Maximum _ -> `The, "maximum", Some "maximal"
  | Lisql.Minimum _ -> `The, "minimum", Some "minimal"

  method func_syntax = function
  | `Str -> `Noun "string"
  | `Lang -> `Noun "language"
  | `Datatype -> `Noun "datatype"
  | `IRI -> `Pattern [`Kwd "the"; `Func "IRI"; `Arg 1]
  | `STRDT -> `Pattern [`Kwd "the"; `Func "literal"; `Arg 1; `Kwd "with"; `Func "datatype"; `Arg 2]
  | `STRLANG -> `Pattern [`Kwd "the"; `Func "literal"; `Arg 1; `Kwd "with";  `Func "language tag"; `Arg 2]
  | `Strlen -> `Noun "length"
  | `Substr2 -> `Pattern [`Kwd "the"; `Func "substring"; `Kwd "of"; `Arg 1; `Kwd "from position"; `Arg 2]
  | `Substr3 -> `Pattern [`Kwd "the"; `Func "substring"; `Kwd "of"; `Arg 1; `Kwd "from position"; `Arg 2; `Kwd "having length"; `Arg 3]
  | `Strbefore -> `Pattern [`Kwd "the"; `Func "substring"; `Kwd "of"; `Arg 1; `Func "before"; `Arg 2]
  | `Strafter -> `Pattern [`Kwd "the"; `Func "substring"; `Kwd "of"; `Arg 1; `Func "after"; `Arg 2]
  | `Concat -> `Infix " ++ "
  | `UCase -> `Noun "uppercase"
  | `LCase -> `Noun "lowercase"
  | `Encode_for_URI -> `Noun "URI encoding"
  | `Replace -> `Pattern [`Kwd "the"; `Func "replacement"; `Kwd "in"; `Arg 1; `Kwd "of"; `Arg 2; `Kwd "by"; `Arg 3]
  | `Integer -> `Pattern [`Arg 1; `Kwd "as"; `Func "integer"]
  | `Decimal -> `Pattern [`Arg 1; `Kwd "as"; `Func "decimal"]
  | `Double -> `Pattern [`Arg 1; `Kwd "as"; `Func "float"]
  | `Indicator -> `Pattern [`Kwd "1 or 0"; `Kwd "whether"; `Arg 1]
  | `Add -> `Infix " + "
  | `Sub -> `Infix " - "
  | `Mul -> `Infix " * "
  | `Div -> `Infix " / "
  | `Neg -> `Prefix "- "
  | `Abs -> `Brackets ("|","|")
  | `Round -> `Noun "rounding"
  | `Ceil -> `Noun "ceiling"
  | `Floor -> `Noun "floor"
  | `Random2 -> `Pattern [`Kwd "a"; `Func "random number"; `Kwd "between"; `Arg 1; `Kwd "and"; `Arg 2]
  | `Date -> `Noun "date"
  | `Time -> `Noun "time"
  | `Year -> `Noun "year"
  | `Month -> `Noun "month"
  | `Day -> `Noun "day"
  | `Hours -> `Noun "hours"
  | `Minutes -> `Noun "minutes"
  | `Seconds -> `Noun "seconds"
  | `TODAY -> `Pattern [`Func "today"]
  | `NOW -> `Pattern [`Func "now"]
  | `And -> `Infix " and "
  | `Or -> `Infix " or "
  | `Not -> `Prefix "it is not true that "
  | `EQ -> `Infix " = "
  | `NEQ -> `Infix " ≠ "
  | `GT -> `Infix " > "
  | `GEQ -> `Infix " ≥ "
  | `LT -> `Infix " < "
  | `LEQ -> `Infix " ≤ "
  | `BOUND -> `Pattern [`Arg 1; `Kwd "is"; `Func "bound"]
  | `IF -> `Pattern [`Arg 2; `Func "if"; `Arg 1; `Func "else"; `Arg 3]
  | `IsIRI -> `Pattern [`Arg 1; `Kwd "is"; `Kwd "a"; `Func "IRI"]
  | `IsBlank -> `Pattern [`Arg 1; `Kwd "is"; `Kwd "a"; `Func "blank node"]
  | `IsLiteral -> `Pattern [`Arg 1; `Kwd "is"; `Kwd "a"; `Func "literal"]
  | `IsNumeric -> `Pattern [`Arg 1; `Kwd "is"; `Kwd "a"; `Func "number"]
  | `StrStarts -> `Pattern [`Arg 1; `Func "starts with"; `Arg 2]
  | `StrEnds -> `Pattern [`Arg 1; `Func "ends with"; `Arg 2]
  | `Contains -> `Pattern [`Arg 1; `Func "contains"; `Arg 2]
  | `REGEX -> `Pattern [`Arg 1; `Func "matches as regexp"; `Arg 2]
  | `LangMatches -> `Pattern [`Arg 1; `Kwd "has"; `Kwd "a"; `Func "language"; `Kwd "that"; `Func "matches"; `Arg 2]
 
  method order_highest = "highest-to-lowest"
  method order_lowest = "lowest-to-highest"

  method matches = "matches"
  method after = "after"
  method before = "before"
  method interval_from = "from"
  method interval_to = "to"
  method higher_or_equal_to = "higher or equal to"
  method lower_or_equal_to = "lower or equal to"
  method interval_between = "between"
  method interval_and = "and"
  method language = "language"
  method datatype = "datatype"
  method matching = "matching"

  method give_me = "give me"
  method there_is = "there is"
  method it_is_true_that = "it is true that"
  method where = "where"
  method undefined = "undefined"

  method tooltip_open_resource = "Open resource in new window"
  method tooltip_delete_current_focus = "Click on this red cross to delete the current focus"
  method tooltip_remove_element_at_focus = "Remove this query element at the query focus"
  method tooltip_focus_on_property = "Adds a focus on the property to refine it"
  method tooltip_duplicate_focus = "Insert a copy of the current focus"
  method tooltip_or = "Insert an alternative to the current focus"
  method tooltip_optionally = "Make the current focus optional"
  method tooltip_not = "Apply negation to the current focus"
  method tooltip_any = "Hide the focus column in the table of results"
  method tooltip_sample = "Replace the aggregation by a sample in order to select another aggregation operator"
  method tooltip_aggreg = "Aggregate the focus column in the table of results" (*, for each solution on other columns *)
  method tooltip_func = "Apply the function to the current focus"
  method tooltip_input_name = "Input a (new) name for the expression result"
  method tooltip_foreach_result = "Compute the aggregation for each result of the related query"
  method tooltip_foreach = "Compute the aggregation for each value of this entity"
  method tooltip_aggreg_id = "Insert a new aggregation column for this entity"
  method tooltip_highest = "Sort the focus column in decreasing order"
  method tooltip_lowest = "Sort the focus column in increasing order"
  method tooltip_header_hide_focus = "Click on this column header to hide the focus"
  method tooltip_header_set_focus = "Click on this column header to set the focus on it"

  method msg_permalink = "The following URL points to the current endpoint and query (Ctrl+C, Enter to copy to clipboard)."
  method result_results = "result", "results"
  method entity_entities = "entity", "entities"
  method concept_concepts = "concept", "concepts"
  method modifier_modifiers = "modifier", "modifiers"
end

let french =
object
  inherit grammar

  method adjective_before_noun = false

  method thing = "chose"
  method relation = "relation"
  method value_ = "valeur"
  method result = "résultat"
  method is = "est"
  method has = "a"
  method has_as_a = "a pour"
  method relative_that = "qui"
  method whose = "dont l'"

  method and_ = "et"
  method or_ = "ou"
  method not_ = "pas"
  method optionally = "optionellement"
  method optional = "optionel(le)"

  method of_ = "de"
  method genetive_suffix = None
  method rel_from = "de"
  method rel_to = "à"

  method a_an ~following = "un(e)"
  method the = "l'"
  method every = "chaque"
  method each = "chaque"
  method no = "aucun(e)"
  method any = "n'importe quel(le)"
  method all = "tous"
  method quantif_one = "un(e)"
  method quantif_of = "parmi"
  method something = "quelque chose"
  method anything = "n'importe quoi"
  method everything = "tout"
  method nothing = "rien"
  method for_ = "pour"
  method choice = "choix"
  method between = "entre"

  method n_th n =
    let suffix =
      if n = 1 then "er"
      else "ième" in
    string_of_int n ^ suffix

  method string = "chaine"
  method integer = "entier"
  method number = "nombre"
  method date = "date"
  method time = "heure"
  method date_and_time = "date et heure"
  method uri = "URI"

  method aggreg_syntax = function
  | Lisql.NumberOf -> `The, "nombre", None
  | Lisql.ListOf -> `The, "liste", None
  | Lisql.Sample -> `A, "échantillon", None
  | Lisql.Total _ -> `The, "somme", Some "total(e)"
  | Lisql.Average _ -> `The, "moyenne", Some "moyen(ne)"
  | Lisql.Maximum _ -> `The, "maximum", Some "maximal(e)"
  | Lisql.Minimum _ -> `The, "minimum", Some "minimal(e)"

  method func_syntax = function
  | `Str -> `Pattern [`Kwd "la"; `Func "chaine"; `Kwd "de"; `Arg 1]
  | `Lang -> `Pattern [`Kwd "la"; `Func "langue"; `Kwd "de"; `Arg 1]
  | `Datatype -> `Pattern [`Kwd "le"; `Func "type"; `Kwd "de"; `Arg 1]
  | `IRI -> `Pattern [`Kwd "l'"; `Func "IRI"; `Arg 1]
  | `STRDT -> `Pattern [`Kwd "le"; `Func "littéral"; `Arg 1; `Kwd "de";  `Func "type"; `Arg 2]
  | `STRLANG -> `Pattern [`Kwd "le"; `Func "littéral"; `Arg 1; `Kwd "de"; `Func "langue"; `Arg 2]
  | `Strlen -> `Pattern [`Kwd "la"; `Func "longueur"; `Kwd "de"; `Arg 1]
  | `Substr2 -> `Pattern [`Kwd "la"; `Func "sous-chaine"; `Kwd "de"; `Arg 1; `Kwd "partant de la position"; `Arg 2]
  | `Substr3 -> `Pattern [`Kwd "la"; `Func "sous-chaine"; `Kwd "de"; `Arg 1; `Kwd "partant de la position"; `Arg 2; `Kwd "et de longueur"; `Arg 3]
  | `Strbefore -> `Pattern [`Kwd "la"; `Func "sous-chaine"; `Kwd "de"; `Arg 1; `Func "avant"; `Arg 2]
  | `Strafter -> `Pattern [`Kwd "la"; `Func "sous-chaine"; `Kwd "de"; `Arg 1; `Func "après"; `Arg 2]
  | `Concat -> `Infix " ++ "
  | `UCase -> `Pattern [`Arg 1; `Kwd "en"; `Func "majuscules"]
  | `LCase -> `Pattern [`Arg 1; `Kwd "en"; `Func "minuscules"]
  | `Encode_for_URI -> `Pattern [`Kwd "l'"; `Func "encodage URI"; `Kwd "de"; `Arg 1]
  | `Replace -> `Pattern [`Kwd "le"; `Func "remplacement"; `Kwd "dans"; `Arg 1; `Kwd "de"; `Arg 2; `Kwd "par"; `Arg 3]
  | `Integer -> `Pattern [`Arg 1; `Kwd "comme"; `Func "entier"]
  | `Decimal -> `Pattern [`Arg 1; `Kwd "comme"; `Func "décimal"]
  | `Double -> `Pattern [`Arg 1; `Kwd "comme"; `Func "flottant"]
  | `Indicator -> `Pattern [`Kwd "1 ou 0"; `Kwd "selon"; `Kwd "que"; `Arg 1]
  | `Add -> `Infix " + "
  | `Sub -> `Infix " - "
  | `Mul -> `Infix " * "
  | `Div -> `Infix " / "
  | `Neg -> `Prefix "- "
  | `Abs -> `Brackets ("|","|")
  | `Round -> `Pattern [`Kwd "l'"; `Func "arrondi"; `Kwd "de"; `Arg 1]
  | `Ceil -> `Pattern [`Kwd "la"; `Func "partie entière par excès"; `Kwd "de"; `Arg 1]
  | `Floor -> `Pattern [`Kwd "la"; `Func "partie entière par défaut"; `Kwd "de"; `Arg 1]
  | `Random2 -> `Pattern [`Kwd "un"; `Func "nombre aléatoire"; `Kwd "entre"; `Arg 1; `Kwd "et"; `Arg 2]
  | `Date -> `Pattern [`Kwd "la"; `Func "date"; `Kwd "de"; `Arg 1]
  | `Time -> `Pattern [`Kwd "l'"; `Func "heure"; `Kwd "de"; `Arg 1]
  | `Year -> `Pattern [`Kwd "l'"; `Func "année"; `Kwd "de"; `Arg 1]
  | `Month -> `Pattern [`Kwd "le"; `Func "mois"; `Kwd "de"; `Arg 1]
  | `Day -> `Pattern [`Kwd "le"; `Func "jour"; `Kwd "de"; `Arg 1]
  | `Hours -> `Pattern [`Kwd "les"; `Func "heures"; `Kwd "de"; `Arg 1]
  | `Minutes -> `Pattern [`Kwd "les"; `Func "minutes"; `Kwd "de"; `Arg 1]
  | `Seconds -> `Pattern [`Kwd "les"; `Func "secondes"; `Kwd "de"; `Arg 1]
  | `TODAY -> `Pattern [`Func "aujourd'hui"]
  | `NOW -> `Pattern [`Func "maintenant"]
  | `And -> `Infix " et "
  | `Or -> `Infix " ou "
  | `Not -> `Prefix "il n'est pas vrai que "
  | `EQ -> `Infix " = "
  | `NEQ -> `Infix " ≠ "
  | `GT -> `Infix " > "
  | `GEQ -> `Infix " ≥ "
  | `LT -> `Infix " < "
  | `LEQ -> `Infix " ≤ "
  | `BOUND -> `Pattern [`Arg 1; `Kwd "a"; `Kwd "une"; `Func "valeur"]
  | `IF -> `Pattern [`Arg 2; `Func "si"; `Arg 1; `Func "sinon"; `Arg 3]
  | `IsIRI -> `Pattern [`Arg 1; `Kwd "est"; `Kwd "une"; `Func "IRI"]
  | `IsBlank -> `Pattern [`Arg 1; `Kwd "est"; `Kwd "un"; `Func "noeud anonyme"]
  | `IsLiteral -> `Pattern [`Arg 1; `Kwd "est"; `Kwd "un"; `Func "litéral"]
  | `IsNumeric -> `Pattern [`Arg 1; `Kwd "est"; `Kwd "un"; `Func "nombre"]
  | `StrStarts -> `Pattern [`Arg 1; `Func "commence par"; `Arg 2]
  | `StrEnds -> `Pattern [`Arg 1; `Func "finit par"; `Arg 2]
  | `Contains -> `Pattern [`Arg 1; `Func "contient"; `Arg 2]
  | `REGEX -> `Pattern [`Arg 1; `Func "matche la regexp"; `Arg 2]
  | `LangMatches -> `Pattern [`Arg 1; `Kwd "a"; `Kwd "une"; `Func "langue"; `Kwd "qui"; `Func "matche"; `Arg 2]
 
  method order_highest = "en ordre décroissant"
  method order_lowest = "en ordre croissant"

  method matches = "contient"
  method after = "après"
  method before = "avant"
  method interval_from = "de"
  method interval_to = "à"
  method higher_or_equal_to = "supérieur(e) ou égal à"
  method lower_or_equal_to = "inférieur(e) ou égal à"
  method interval_between = "entre"
  method interval_and = "et"
  method language = "langage"
  method datatype = "type de donnée"
  method matching = "contenant"

  method give_me = "donne moi"
  method there_is = "il y a"
  method it_is_true_that = "il est vrai que"
  method where = "où"
  method undefined = "indéfini"

  method tooltip_open_resource = "Ouvrir la ressource dans une nouvelle fenêtre"
  method tooltip_delete_current_focus = "Cliquer sur la croix rouge pour supprimer le focus actuel"
  method tooltip_remove_element_at_focus = "Supprimer cet élément de requête au focus actuel"
  method tooltip_focus_on_property = "Insérer un focus sur la propriété pour la raffiner"
  method tooltip_or = "Insérer une alternative au focus actuel"
  method tooltip_duplicate_focus = "Insérer une copie du focus actuel"
  method tooltip_optionally = "Rendre le focus actuel optionnel"
  method tooltip_not = "Appliquer une négation au focus actuel"
  method tooltip_any = "Cacher la colonne du focus actuel dans la table des résultats"
  method tooltip_sample = "Remplacer l'agrégation par un échantillon afin de pouvoir sélectionner un autre opérateur d'agrégation"
  method tooltip_aggreg = "Agréger la colonne du focus actuel dans la table des résultats" (* pour chaque valuation des autres colonnes *)
  method tooltip_func = "Appliquer cette fonction au focus actuel"
  method tooltip_input_name = "Entrer un (nouveau) nom pour le résultat de l'expression"
  method tooltip_foreach_result = "Calculer l'agrégation pour chaque résultat de la requête associée"
  method tooltip_foreach = "Calculer l'agrégation pour chaque valeur de cette entité"
  method tooltip_aggreg_id = "Insérer une nouvelle colonne d'agrégation pour cette entité"
  method tooltip_highest = "Trier la colonne du focus actuel en ordre décroissant"
  method tooltip_lowest = "Trier la colonne du focus actuel en ordre croissant"
  method tooltip_header_hide_focus = "Cliquer sur cet entête de colonne pour cacher le focus"
  method tooltip_header_set_focus = "Cliquer sur cet entête de colonne pour mettre le focus dessus"

  method msg_permalink = "L'URL suivante pointe sur le point d'accès et la requête actuelles (Ctrl+C, Entrée pour copier)."
  method result_results = "résultat", "résultats"
  method entity_entities = "entité", "entités"
  method concept_concepts = "concept", "concepts"
  method modifier_modifiers = "modifieur", "modifieurs"
end


let spanish =
object
  inherit grammar

  method adjective_before_noun = false

  method thing = "cosa"
  method relation = "relación"
  method value_ = "valor"
  method result = "resultado"
  method is = "es"
  method has = "tiene"
  method has_as_a = "tiene como"
  method relative_that = "que"
  method whose = "cuyo"

  method and_ = "y"
  method or_ = "o"
  method not_ = "no"
  method optionally = "opcionalmente"
  method optional = "opcional"

  method of_ = "de"
  method genetive_suffix = None
  method rel_from = "de"
  method rel_to = "a"

  method a_an ~following = "un(a)"
  method the = "la"
  method every = "cada"
  method each = "cada"
  method no = "no"
  method any = "cualquier"
  method all = "todos"
  method quantif_one = "un(a)"
  method quantif_of = "de"
  method something = "algo"
  method anything = "cualquier cosa"
  method everything = "todo"
  method nothing = "nada"
  method for_ = "para"
  method choice = "elección"
  method between = "entre"

  method n_th n =
    let suffix =
      if n = 1 then "o/a"
      else "o" in
    string_of_int n ^ suffix

  method string = "cadena"
  method integer = "entero"
  method number = "número"
  method date = "fecha"
  method time = "hora"
  method date_and_time = "fecha y hora"
  method uri = "URI"

  method aggreg_syntax = function
  | Lisql.NumberOf -> `The, "número", None
  | Lisql.ListOf -> `The, "lista", None
  | Lisql.Sample -> `A, "muestra", None
  | Lisql.Total _ -> `The, "suma", Some "total"
  | Lisql.Average _ -> `The, "promedio", Some "promedio"
  | Lisql.Maximum _ -> `The, "máximo", Some "máximo"
  | Lisql.Minimum _ -> `The, "mínimo", Some "mínimo"

  method func_syntax = function
  | `Str -> `Pattern [`Kwd "la"; `Func "cadena"; `Kwd "de"; `Arg 1]
  | `Lang -> `Pattern [`Kwd "el"; `Func "idioma"; `Kwd "de"; `Arg 1]
  | `Datatype -> `Pattern [`Kwd "el"; `Func "tipo"; `Kwd "de"; `Arg 1]
  | `IRI -> `Pattern [`Kwd "la"; `Func "IRI"; `Arg 1]
  | `STRDT -> `Pattern [`Kwd "el"; `Func "literal"; `Arg 1; `Kwd "con";  `Func "tipo"; `Arg 2]
  | `STRLANG -> `Pattern [`Kwd "el"; `Func "literal"; `Arg 1; `Kwd "con"; `Func "idioma"; `Arg 2]
  | `Strlen -> `Pattern [`Kwd "la"; `Func "longitud"; `Kwd "de"; `Arg 1]
  | `Substr2 -> `Pattern [`Kwd "la"; `Func "subcadena"; `Kwd "de"; `Arg 1; `Kwd "partiendo de la posición"; `Arg 2]
  | `Substr3 -> `Pattern [`Kwd "la"; `Func "subcadena"; `Kwd "de"; `Arg 1; `Kwd "partiendo de la posición"; `Arg 2; `Kwd "y de longitud"; `Arg 3]
  | `Strbefore -> `Pattern [`Kwd "la"; `Func "subcadena"; `Kwd "de"; `Arg 1; `Func "antes"; `Arg 2]
  | `Strafter -> `Pattern [`Kwd "la"; `Func "subcadena"; `Kwd "de"; `Arg 1; `Func "depués"; `Arg 2]
  | `Concat -> `Infix " ++ "
  | `UCase -> `Pattern [`Arg 1; `Kwd "en"; `Func "mayúscula"]
  | `LCase -> `Pattern [`Arg 1; `Kwd "en"; `Func "minúscula"]
  | `Encode_for_URI -> `Pattern [`Kwd "la"; `Func "codificación de la URL"; `Kwd "de"; `Arg 1]
  | `Replace -> `Pattern [`Kwd "el"; `Func "reemplazo"; `Kwd "en"; `Arg 1; `Kwd "de"; `Arg 2; `Kwd "por"; `Arg 3]
  | `Integer -> `Pattern [`Arg 1; `Kwd "como"; `Func "entero"]
  | `Decimal -> `Pattern [`Arg 1; `Kwd "como"; `Func "decimal"]
  | `Double -> `Pattern [`Arg 1; `Kwd "como"; `Func "flotante"]
  | `Indicator -> `Pattern [`Kwd "1 o 0"; `Kwd "dependiendo"; `Kwd "si"; `Arg 1]
  | `Add -> `Infix " + "
  | `Sub -> `Infix " - "
  | `Mul -> `Infix " * "
  | `Div -> `Infix " / "
  | `Neg -> `Prefix "- "
  | `Abs -> `Brackets ("|","|")
  | `Round -> `Pattern [`Kwd "el"; `Func "redondeo"; `Kwd "de"; `Arg 1]
  | `Ceil -> `Pattern [`Kwd "la"; `Func "parte entera por exceso"; `Kwd "de"; `Arg 1]
  | `Floor -> `Pattern [`Kwd "la"; `Func "parte entera por defecto"; `Kwd "de"; `Arg 1]
  | `Random2 -> `Pattern [`Kwd "un"; `Func "número aleatorio"; `Kwd "entre"; `Arg 1; `Kwd "y"; `Arg 2]
  | `Date -> `Pattern [`Kwd "la"; `Func "fecha"; `Kwd "de"; `Arg 1]
  | `Time -> `Pattern [`Kwd "la"; `Func "hora"; `Kwd "de"; `Arg 1]
  | `Year -> `Pattern [`Kwd "el"; `Func "año"; `Kwd "de"; `Arg 1]
  | `Month -> `Pattern [`Kwd "el"; `Func "mes"; `Kwd "de"; `Arg 1]
  | `Day -> `Pattern [`Kwd "el"; `Func "día"; `Kwd "de"; `Arg 1]
  | `Hours -> `Pattern [`Kwd "las"; `Func "horas"; `Kwd "de"; `Arg 1]
  | `Minutes -> `Pattern [`Kwd "los"; `Func "minutos"; `Kwd "de"; `Arg 1]
  | `Seconds -> `Pattern [`Kwd "los"; `Func "segundos"; `Kwd "de"; `Arg 1]
  | `TODAY -> `Pattern [`Func "hoy"]
  | `NOW -> `Pattern [`Func "ahora"]
  | `And -> `Infix " y "
  | `Or -> `Infix " o "
  | `Not -> `Prefix "no es verdad que "
  | `EQ -> `Infix " = "
  | `NEQ -> `Infix " ≠ "
  | `GT -> `Infix " > "
  | `GEQ -> `Infix " ≥ "
  | `LT -> `Infix " < "
  | `LEQ -> `Infix " ≤ "
  | `BOUND -> `Pattern [`Arg 1; `Kwd "tiene"; `Kwd "un"; `Func "valor"]
  | `IF -> `Pattern [`Arg 2; `Func "si"; `Arg 1; `Func "caso contrario"; `Arg 3]
  | `IsIRI -> `Pattern [`Arg 1; `Kwd "es"; `Kwd "una"; `Func "IRI"]
  | `IsBlank -> `Pattern [`Arg 1; `Kwd "es"; `Kwd "un"; `Func "nodo anónimo"]
  | `IsLiteral -> `Pattern [`Arg 1; `Kwd "es"; `Kwd "un"; `Func "literal"]
  | `IsNumeric -> `Pattern [`Arg 1; `Kwd "es"; `Kwd "un"; `Func "número"]
  | `StrStarts -> `Pattern [`Arg 1; `Func "comienza por"; `Arg 2]
  | `StrEnds -> `Pattern [`Arg 1; `Func "termina en"; `Arg 2]
  | `Contains -> `Pattern [`Arg 1; `Func "contiene"; `Arg 2]
  | `REGEX -> `Pattern [`Arg 1; `Func "coincide con la expresión regular"; `Arg 2]
  | `LangMatches -> `Pattern [`Arg 1; `Kwd "tiene"; `Kwd "un"; `Func "idioma"; `Kwd "que"; `Func "coincida con"; `Arg 2]
 
  method order_highest = "en orden descendente"
  method order_lowest = "en orden ascendente"

  method matches = "contiene"
  method after = "después"
  method before = "antes"
  method interval_from = "desde"
  method interval_to = "hasta"
  method higher_or_equal_to = "mayor o igual a"
  method lower_or_equal_to = "menor o igual a"
  method interval_between = "entre"
  method interval_and = "y"
  method language = "idioma"
  method datatype = "tipo de datos"
  method matching = "que contiene"

  method give_me = "dame"
  method there_is = "hay"
  method it_is_true_that = "es verdad que"
  method where = "donde"
  method undefined = "indefinido"

  method tooltip_open_resource = "Abrir el recurso en una nueva ventana"
  method tooltip_delete_current_focus = "Haga clic en la X roja para eliminar el foco actual"
  method tooltip_remove_element_at_focus = "Eliminar el elemento en el foco actual de consulta"
  method tooltip_focus_on_property = "Insertar un foco sobre la propiedad para refinarla"
  method tooltip_duplicate_focus = "Insertar una copia de el foco actual"
  method tooltip_or = "Insertar una alternativa en el foco actual"
  method tooltip_optionally = "Hacer al foco actual opcional"
  method tooltip_not = "Aplicar una negación en el foco actual"
  method tooltip_any = "Ocultar la columna del foco actual en la tabla de resultados"
  method tooltip_sample = "Vuelva a colocar la agregación de una muestra con el fin de seleccionar otro agregador"
  method tooltip_aggreg = "Totalizar la columna del foco actual en la tabla de resultados" (* pour chaque valuation des autres colonnes *)
  method tooltip_func = "Aplicar esta función en el foco actual"
  method tooltip_input_name = "Introduzca un nombre (nuevo) para el resultado de la expresión"
  method tooltip_foreach_result = "Calcular la agregación para cada resultado de la consulta asociada"
  method tooltip_foreach = "Calcular la agregación para cada valor de esta entidad"
  method tooltip_aggreg_id = "Insertar una nueva columna de agregación para esta entidad"
  method tooltip_highest = "Ordenar la columna del foco actual en forma descendente"
  method tooltip_lowest = "Ordenar la columna del foco actual en forma ascendente"
  method tooltip_header_hide_focus = "Haga clic en el encabezado de la columna para ocultar el foco"
  method tooltip_header_set_focus = "Haga clic en el encabezado de la columna para poner el foco en él"

  method msg_permalink = "La siguiente URL apunta al Endpoint y consulta actuales (Ctrl+C, Enter para copiar)."
  method result_results = "resultado", "resultados"
  method entity_entities = "entidad", "entidades"
  method concept_concepts = "concepto", "conceptos"
  method modifier_modifiers = "modificador", "modificadores"
end
