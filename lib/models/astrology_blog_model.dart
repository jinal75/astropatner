class Blog {
  Blog({required this.id, this.previewImage, required this.title, required this.blogImage, this.blogCategoryId, this.description, required this.author, required this.viewer, required this.createdAt, this.extension});

  int id;
  String title;
  dynamic blogCategoryId;
  String? description;
  String author;
  String blogImage;
  int viewer;
  String createdAt;
  String? extension;
  String? previewImage;
  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"] ?? "",
        blogCategoryId: json["blogCategoryId"] ?? 0,
        description: json["description"] ?? "",
        author: json["author"] ?? "",
        blogImage: json["blogImage"] ?? "",
        viewer: json["viewer"] ?? 0,
        createdAt: json["created_at"],
        extension: json["extension"] ?? "",
        previewImage: json["previewImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "blogCategoryId": blogCategoryId,
        "description": description,
        "author": author,
        "blogImage": blogImage,
        "viewer": viewer,
        "created_at": createdAt,
        "extension": extension,
        "previewImage": previewImage,
      };
}
