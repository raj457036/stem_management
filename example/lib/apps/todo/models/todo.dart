import 'dart:convert';

class Todo {
  final int id;
  final String content;
  final bool pinned;

  Todo({
    required this.id,
    required this.content,
    required this.pinned,
  });

  Todo copyWith({
    int? id,
    String? content,
    bool? pinned,
  }) {
    return Todo(
      id: id ?? this.id,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'liked': pinned,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id']?.toInt() ?? 0,
      content: map['content'] ?? '',
      pinned: map['liked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() => 'Todo(id: $id, content: $content, liked: $pinned)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.id == id &&
        other.content == content &&
        other.pinned == pinned;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ pinned.hashCode;
}
