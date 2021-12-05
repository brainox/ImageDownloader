final String tablesImages = 'images';

class ImageFields {
  static final List<String> values = [
    // Add all fiels
    id, urlString, imageNumber
  ];

  static final String id = '_id';
  static final String urlString = 'urlString';
  static final String imageNumber = 'imageNumber';
}

class ImageModel {
  final int? id;
  final String urlString;
  final int imageNumber;

  const ImageModel({
    this.id,
    required this.urlString,
    required this.imageNumber,
  });

  @override
  String toString() {
    return 'ImageModel{id: $id, urlString: $urlString, imageNumber: $imageNumber}';
  }

  ImageModel copy({
    int? id,
    String? urlString,
    int? imageNumber,
  }) =>
      ImageModel(
          id: id ?? this.id,
          urlString: urlString ?? this.urlString,
          imageNumber: imageNumber ?? this.imageNumber);

  static ImageModel fromJson(Map<String, Object?> json) => ImageModel(
      id: json[ImageFields.id] as int?,
      urlString: json[ImageFields.urlString] as String,
      imageNumber: json[ImageFields.imageNumber] as int);

  Map<String, Object?> toJson() => {
        ImageFields.id: id,
        ImageFields.urlString: urlString,
        ImageFields.imageNumber: imageNumber,
      };
}
