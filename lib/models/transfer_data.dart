// ignore_for_file: unrelated_type_equality_checks
class FileTransfer {
  String status;
  String message;
  String url;

  FileTransfer({
    String ? status,
    String ? message,
    String ? url,
  })
  :
    status =status ?? "" ,
    message =message ?? "" ,
    url =url ?? "" 
  ;

  factory FileTransfer.fromJson(Map<String, dynamic> json) {
    return FileTransfer(
        status: json['status'].runtimeType == "String" ? json['status']: json['status'].toString(),
        message: json['message'].runtimeType == "String" ? json['message']: json['message'].toString(),
        url: json['fileUrl'].runtimeType == "String" ? json['fileUrl']: json['fileUrl'].toString(),
      );
  }
}
