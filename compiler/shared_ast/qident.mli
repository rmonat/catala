(* This file is part of the Catala compiler, a specification language for tax
   and social benefits computation rules. Copyright (C) 2023 Inria, contributor:
   Louis Gesbert <louis.gesbert@inria.fr>

   Licensed under the Apache License, Version 2.0 (the "License"); you may not
   use this file except in compliance with the License. You may obtain a copy of
   the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
   License for the specific language governing permissions and limitations under
   the License. *)

(** This module defines module names and path accesses, used to refer to
    separate compilation units. *)

type modname = string
(** Expected to be a uident *)

type ident = string
(** Expected to be a lident *)

type path = modname list
type t = path * ident

val compare_path : path -> path -> int
val equal_path : path -> path -> bool
val compare : t -> t -> int
val equal : t -> t -> bool
val format : Format.formatter -> t -> unit

module Set : Set.S with type elt = t
module Map : Map.S with type key = t
