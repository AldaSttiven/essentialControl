class Console {
  Console({
    required this.id,
    required this.name,
    required this.image,
    required this.commandList,
  });

  final String? id;
  final String? name;
  final String? image;
  final List<CommandList> commandList;

  factory Console.fromJson(Map<String, dynamic> json) {
    return Console(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      commandList: json["commandList"] == null
          ? []
          : List<CommandList>.from(
              json["commandList"]!.map((x) => CommandList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "commandList": commandList.map((x) => x?.toJson()).toList(),
      };
}

class CommandList {
  CommandList({
    required this.id,
    required this.name,
    required this.image,
    required this.command,
  });

  final int? id;
  final String? name;
  final String? image;
  final String? command;

  factory CommandList.fromJson(Map<String, dynamic> json) {
    return CommandList(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      command: json["command"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "command": command,
      };
}
