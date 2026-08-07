class_name DialogueResource
extends Resource
## Compiled output of the .sh dialogue format (Stage 7).
##
## A flat dictionary of nodes; each node is a list of ops the runner executes in
## order. Kept deliberately dumb — all the cleverness lives in the parser, so the
## runtime is fast and the compiler can be rewritten without touching playback.

## node_id -> Array[Dictionary]
@export var nodes: Dictionary = {}
## node_id -> Array[Dictionary] of @require conditions
@export var requirements: Dictionary = {}
## node_ids marked @once
@export var once_nodes: Array[StringName] = []

enum Op { LINE, CHOICE, GOTO, WRITE, EIGHT, CUE, END, BEAT, INTERRUPT }


func has_node_id(id: StringName) -> bool:
	return nodes.has(id)


func ops(id: StringName) -> Array:
	return nodes.get(id, [])


func requires(id: StringName) -> Array:
	return requirements.get(id, [])
