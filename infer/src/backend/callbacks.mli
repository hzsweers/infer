(*
 * Copyright (c) 2013 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

open! Utils

(** Module to register and invoke callbacks *)

type proc_callback_args = {
  get_proc_desc : Procname.t -> Cfg.Procdesc.t option;
  get_procs_in_file : Procname.t -> Procname.t list;
  idenv : Idenv.t;
  tenv : Tenv.t;
  proc_name : Procname.t;
  proc_desc : Cfg.Procdesc.t;
}

(** Type of a procedure callback:
    - List of all the procedures the callback will be called on.
    - get_proc_desc to get a proc desc from a proc name.
    - Idenv to look up the definition of ids in a cfg.
    - Type environment.
    - Procedure for the callback to act on. *)
type proc_callback_t = proc_callback_args -> unit

type cluster_callback_t =
  Procname.t list ->
  (Procname.t -> Cfg.Procdesc.t option) ->
  (Idenv.t * Tenv.t * Procname.t * Cfg.Procdesc.t) list ->
  unit

(** register a procedure callback *)
val register_procedure_callback : Config.language option -> proc_callback_t -> unit

(** register a cluster callback *)
val register_cluster_callback : Config.language option -> cluster_callback_t -> unit

(** un-register all the procedure callbacks currently registered *)
val unregister_all_callbacks : unit -> unit

(** Invoke all the registered callbacks. *)
val iterate_callbacks : (Procname.t -> unit) -> Cg.t -> Exe_env.t -> unit
