
class Tag {
  final int tagId;
  final String name;
  // final int userId;

  Tag({
    required this.tagId,
    required this.name,
    // required this.userId
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tag_id'],
      name: json['tag_name'],
      // userId: json['user_id'],
    );
  }
}

class TagResponse {
  String status;
  String message;
  List<Tag> tags;

  TagResponse({
    String ? status,
    String ? message,
    List<Tag> ? tags
  }) :
    status = status ?? '',
    message = message ?? '',
    tags = tags ?? []
  ;

  factory TagResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return TagResponse(
      status: json['status'],
      message: json['message'],
      tags: data != null ? (data['summaryTags'] as List).map((tags)=> Tag.fromJson(tags)).toList() : []
    );
  }
}


// {
//     "status": "ok",
//     "message": "Get Tags Successfully",
//     "data": {
//         "summaryTags": [
//             {
//                 "tag_id": 1,
//                 "name": "intern",
//                 "user_id": 23
//             },
//             {
//                 "tag_id": 2,
//                 "name": "KMUTT",
//                 "user_id": 23
//             }
//         ]
//     }
// }