(* This file is part of the Catala compiler, a specification language for tax
   and social benefits computation rules. Copyright (C) 2020 Inria, contributor:
   Denis Merigoux <denis.merigoux@inria.fr>

   Licensed under the Apache License, Version 2.0 (the "License"); you may not
   use this file except in compliance with the License. You may obtain a copy of
   the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
   License for the specific language governing permissions and limitations under
   the License. *)

(** Scope language to default calculus translator *)

val translate_program :
  Ast.program -> Dcalc.Ast.untyped Dcalc.Ast.program * Dependency.TVertex.t list
(** Usage [translate_program p] returns a tuple [(new_program, types_list)]
    where [new_program] is the map of translated scopes. Finally, [types_list]
    is a list of all types (structs and enums) used in the program, correctly
    ordered with respect to inter-types dependency. *)
