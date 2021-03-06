import 'package:cloud_firestore/cloud_firestore.dart';
/// Firebase Database Object

class EventComment {
  String id;
  String parentId;
  int eventId;
  String authorId;
  String authorName;
  String authorPicture;
  String message;
  DateTime date;
  List<EventComment> replies;
  
  // CONSTRUCTORS //
  EventComment.create();
  EventComment({this.eventId, this.authorId, this.authorName, this.authorPicture, this.message, this.date, this.parentId, this.id, this.replies});
  EventComment.fromMap(Map<dynamic, dynamic> map){
    this.id = map['id'];
    this.id = map['parentId'];
    this.eventId = map['eventId'];
    this.authorName = map['authorName'];
    this.authorId = map['authorId'];
    this.authorPicture = map['authorPicture'];
    this.message = map['message'];
    Timestamp temp = map['date'];
    this.date = temp.toDate();
    // this.date = map['date'];
    // this.replies = _serializeReplies(map['replies']);
    }
  EventComment.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.parentId = snapshot?.data['parentId'];
    this.eventId = snapshot?.data['eventId'];
    this.authorName = snapshot?.data['authorName'];
    this.authorId = snapshot?.data['authorId'];
    this.authorPicture = snapshot?.data['authorPicture'];
    this.message = snapshot?.data['message'];
    Timestamp temp = snapshot?.data['date'];
    this.date = temp.toDate();
    // this.replies = _serializeReplies(snapshot?.data['replies']);
    // this.replies = await _serializeRepliesCollecion(snapshot.reference.collection('Replies').getDocuments());
  }


  // METHODS //
  toJson() {
    return {
      "id": id,
      "parentId": parentId,
      "eventId": eventId,
      "authorName": authorName,
      "authorId": authorId,
      "authorPicture": authorPicture,
      "message": message,
      "date": date,
    };
  }
  
  Future<List<EventComment>> getReplies(DocumentSnapshot snapshot) async {
    List<EventComment> result = List<EventComment>();
    List<DocumentSnapshot> documents;
    await snapshot.reference.collection('Replies').getDocuments().then((value) {
      documents = value.documents;
    });
    print(documents);
    if (documents.isNotEmpty) {
      documents.forEach((reply) {
        result.add(EventComment.fromSnapshot(reply));
      });
      this.replies = result;
      return result;
    }
    else {
      this.replies = result;
      return List<EventComment>();
    }
  }

}