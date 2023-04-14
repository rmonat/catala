(* This file is part of the Catala compiler, a specification language for tax
   and social benefits computation rules. Copyright (C) 2020 Inria, contributor:
   Alain Delaët <alain.delaet--tixeuil@inria.fr>

   Licensed under the Apache License, Version 2.0 (the "License"); you may not
   use this file except in compliance with the License. You may obtain a copy of
   the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
   License for the specific language governing permissions and limitations under
   the License. *)

open Shared_ast
open Ast
open Catala_utils

type invariant_status = Fail | Pass | Ignore
type invariant_expr = typed expr -> invariant_status
type state = { result : bool; total : int; ok : int }

let state_init = { result = true; total = 0; ok = 0 }

let state_join s1 s2 =
  {
    result = s1.result && s2.result;
    total = s1.total + s2.total;
    ok = s1.ok + s2.ok;
  }

let check_invariant (inv : string * invariant_expr) (p : typed program) : bool =
  let result = ref true in
  let name, inv = inv in

  let state =
    Program.fold_left_exprs p ~init:state_init ~f:(fun state e ->
        let rec f e =
          let r =
            match inv e with
            | Ignore -> state
            | Fail ->
              Cli.error_format "%s failed in %s.\n\n %a" name
                (Pos.to_string_short (Expr.pos e))
                (Print.expr ~debug:true p.decl_ctx)
                e;
              { state with result = false; total = state.total + 1 }
            | Pass -> { state with total = state.total + 1; ok = state.ok + 1 }
          in
          Expr.map_gather e ~join:state_join ~acc:r ~f
        in
        let state, _ = f e in

        state)
  in

  Cli.result_print "Invariant %s\n   checked. result: [%d/%d]" name state.ok
    state.total;
  state.result

(* Structural invariant: no default can have as type A -> B *)
let invariant_default_no_arrow () : string * invariant_expr =
  ( __FUNCTION__,
    fun e ->
      match Marked.unmark e with
      | EDefault _ -> begin
        match Marked.unmark (Expr.ty e) with TArrow _ -> Fail | _ -> Pass
      end
      | _ -> Ignore )

(* Structural invariant: no partial evaluation *)
let invariant_no_partial_evaluation () : string * invariant_expr =
  ( __FUNCTION__,
    fun e ->
      match Marked.unmark e with
      | EApp { f = EOp { op = Op.Log _; _ }, _; _ } ->
        (* logs are differents. *) Pass
      | EApp _ -> begin
        match Marked.unmark (Expr.ty e) with TArrow _ -> Fail | _ -> Pass
      end
      | _ -> Ignore )

(* Structural invariant: no function can return an function *)
let invariant_no_return_a_function () : string * invariant_expr =
  ( __FUNCTION__,
    fun e ->
      match Marked.unmark e with
      | EAbs _ -> begin
        match Marked.unmark (Expr.ty e) with
        | TArrow (_, (TArrow _, _)) -> Fail
        | _ -> Pass
      end
      | _ -> Ignore )

let invariant_app_inversion () : string * invariant_expr =
  ( __FUNCTION__,
    fun e ->
      match Marked.unmark e with
      | EApp { f = EOp _, _; _ } -> Pass
      | EApp { f = EAbs { binder; _ }, _; args } ->
        if Bindlib.mbinder_arity binder = 1 && List.length args = 1 then Pass
        else Fail
      | EApp { f = EVar _, _; _ } -> Pass
      | EApp { f = EApp { f = EOp { op = Op.Log _; _ }, _; args = _ }, _; _ } ->
        Pass
      | EApp { f = EStructAccess _, _; _ } -> Pass
      | EApp _ -> Fail
      | _ -> Ignore )

(** the arity of constructors when matching is always one. *)
let invariant_match_inversion () : string * invariant_expr =
  ( __FUNCTION__,
    fun e ->
      match Marked.unmark e with
      | EMatch { cases; _ } ->
        if
          EnumConstructor.Map.for_all
            (fun _ case ->
              match Marked.unmark case with
              | EAbs { binder; _ } -> Bindlib.mbinder_arity binder = 1
              | _ -> false)
            cases
        then Pass
        else Fail
      | _ -> Ignore )
