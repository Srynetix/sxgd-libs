extends Node
## A simple client helper linked to a [SxNetClientPeer] (with a [SxNetPeerProtocol]).
##
## Exposes `_peer_connected`, `_peer_disconnected`, `_server_disconnected` and `_on_message`
## function you can override to react to server messages.

const SxNetworkClientPeer := preload("res://addons/sxgd-network-nodes/nodes/client-peer.gd")
const SxNetworkPeerProtocol := preload("res://addons/sxgd-network-nodes/nodes/peer-protocol.gd")

## Client peer.
var peer: SxNetworkClientPeer
## Peer protocol.
var protocol: SxNetworkPeerProtocol

func _init(peer_: SxNetworkClientPeer) -> void:
	peer = peer_
	protocol = peer.protocol
	name = "SxNetClientHandler"

func _ready() -> void:
	peer.peer_connected.connect(_peer_connected)
	peer.peer_disconnected.connect(_peer_disconnected)
	peer.connected_to_server.connect(_connected_to_server)
	protocol.on_message_for_client.connect(_on_message)

## Connected to server.
func _connected_to_server() -> void:
	pass

## A peer just connected.
func _peer_connected(id: int) -> void:
	pass

## A peer just disconnected.
func _peer_disconnected(id: int) -> void:
	pass

## React to a server message.
func _on_message(kind: Variant, payload: Variant) -> void:
	pass
