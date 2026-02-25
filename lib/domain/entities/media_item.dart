class MediaItem {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String userName;
  final DateTime? dateCreated;

  MediaItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.userName,
    this.dateCreated,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['file'] != null && json['file']['path'] != null) {
      final String imagePath = json['file']['path'];
      imageUrl = 'https://gallery.prod2.webant.ru/get_file/$imagePath';
    }

    return MediaItem(
      id: json['id'],
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: imageUrl,
      userName: json['user']?['displayName'] ?? 'No Name',
      dateCreated: json['dateCreate'] != null
          ? DateTime.tryParse(json['dateCreate'])
          : null,
    );
  }
}
