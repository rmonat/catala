open Shared_ast

type ('e, 'c, 't) mutation_type = ((yes, 'e, 'c) interpr_kind, 't) gexpr boxed -> ((yes, 'e, 'c) interpr_kind, 't) gexpr boxed

val remove_excepts_n : int ref
val remove_excepts : float -> ('e, 'c, 't) mutation_type

val duplicate_excepts_n : int ref
val duplicate_excepts : ('e, 'c, 't) mutation_type

val total_excepts_n : int ref
val apply_mutations : (('e, 'c, 't) mutation_type * float) list -> ((yes, 'e, 'c) interpr_kind, 't) gexpr -> ((yes, 'e, 'c) interpr_kind, 't) gexpr boxed
