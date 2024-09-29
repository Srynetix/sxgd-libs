extends MarginContainer

@onready var _host_button := %HostButton as Button
@onready var _join_client1_button := %JoinClient1Button as Button
@onready var _join_client2_button := %JoinClient2Button as Button
@onready var _show_logs := %ShowLogs as Button
@onready var _show_tree := %ShowTree as Button


func _ready() -> void:
	_host_button.pressed.connect(func():
		var server := SxNetworkNodes.ServerPeer.new()
		server.port = 12340
		server.max_clients = 16
		add_child(server)

		_host_button.disabled = true
	)

	_join_client1_button.pressed.connect(func():
		var client := SxNetworkNodes.ClientPeer.new()
		client.name = "Client1"
		client.server_address = "localhost"
		client.server_port = 12340
		add_child(client)

		_join_client1_button.disabled = true
	)

	_join_client2_button.pressed.connect(func():
		var client := SxNetworkNodes.ClientPeer.new()
		client.name = "Client2"
		client.server_address = "localhost"
		client.server_port = 12340
		add_child(client)

		_join_client2_button.disabled = true
	)

	_show_logs.pressed.connect(func():
		DebugTools.show_tools()
		DebugTools.show_specific_panel(DebugTools.PanelType.Logs)
	)

	_show_tree.pressed.connect(func():
		DebugTools.show_tools()
		DebugTools.show_specific_panel(DebugTools.PanelType.Graph)
	)
