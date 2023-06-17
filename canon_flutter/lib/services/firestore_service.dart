import 'package:canon/app/app.locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canon/app/app.logger.dart';
import 'package:canon/constants/app_keys.dart';
import 'package:canon/models/appuser.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../models/case.dart';
import '../models/chat.dart';
import '../models/chat_message.dart';

const tokenDocId = "doctor_token";

class FirestoreService {
  final log = getLogger('FirestoreApi');

  final _authService = locator<FirebaseAuthenticationService>();

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(UsersFirestoreKey);
  final CollectionReference tokenCollection =
      FirebaseFirestore.instance.collection(TokenFirestoreKey);

  // final CollectionReference regionsCollection = FirebaseFirestore.instance.collection(RegionsFirestoreKey);

  Future<bool> createUser({required AppUser user, required keyword}) async {
    log.i('user:$user');
    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson(keyword));
      log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<AppUser?> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      return AppUser.fromData(userData! as Map<String, dynamic>);
    } else {
      log.e("Error no user");
      return null;
    }
  }

  Future<bool> updateToken({required String token}) async {
    log.i('token:$token');
    try {
      final tokenDocument = tokenCollection.doc(tokenDocId);
      await tokenDocument.set({"token": token});
      log.v('token added at ${tokenDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<String?> getToken() async {
    final tokenDoc = await tokenCollection.doc(tokenDocId).get();
    if (!tokenDoc.exists) {
      log.v('We have no token in our database');
      return null;
    }

    final tokenData = tokenDoc.data();
    log.v('User found. Data: $tokenData');

    return (tokenData! as Map<String, dynamic>)['token'];
  }

  final CollectionReference casesCollection =
      FirebaseFirestore.instance.collection(CaseFirestoreKey);

  String getCaseDocumentId() {
    DocumentReference docRef = casesCollection.doc();
    return docRef.id;
  }

  Future<void> addCaseFile(CaseModel caseFile) async {
    try {
      // Create a new document reference
      DocumentReference caseFileRef = casesCollection.doc(caseFile.id);

      // Set the data for the case file
      await caseFileRef.set(caseFile.toMap());

      // Optional: Assign the generated document ID to the case model
      caseFile.id = caseFileRef.id;
    } catch (e) {
      // Handle error while adding the case file
      log.e('Error adding case file: $e');
    }
  }

  Future<List<CaseModel>?> fetchCases({
    int limit = 10,
    required String selectedJurisdiction,
    required String selectedCaseClass,
  }) async {
    try {
      Query query = casesCollection.orderBy('date', descending: true);

      if (selectedCaseClass.isNotEmpty) {
        query = query.where('caseClass', isEqualTo: selectedCaseClass);
      }

      if (selectedJurisdiction.isNotEmpty) {
        query = query.where('jurisdiction', isEqualTo: selectedJurisdiction);
      }

      QuerySnapshot querySnapshot = await query.limit(limit).get();

      final cases = querySnapshot.docs
          .map((doc) => CaseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return cases;
    } catch (e) {
      // Handle error while fetching cases
      log.e('Error fetching cases: $e');
      return null;
    }
  }

  Future<List<AppUser>> searchUsers(String keyword) async {
    log.i("searching for $keyword");
    final query = usersCollection
        .where('keyword', arrayContains: keyword.toLowerCase())
        .where('userRole', isEqualTo: 'lawyer')
        .limit(5);

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => AppUser.fromData(doc.data() as Map<String, dynamic>))
        .toList();
  }

  ///Chat =======================================================================
  final CollectionReference _chatsCollectionReference =
      FirebaseFirestore.instance.collection('chats');

  Future<Chat> createChat(Chat chat) async {
    try {
      final chatRef = _chatsCollectionReference.doc();
      final chatUpdated = Chat(
        id: chatRef.id,
        name: chat.name,
        members: chat.members,
        createdAt: chat.createdAt,
      );
      // final DocumentReference documentReference =
      await chatRef.set(chatUpdated.toJson());
      return chatUpdated;
    } catch (e) {
      log.e('createChat Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateChat(Chat chat) async {
    try {
      await _chatsCollectionReference.doc(chat.id).update(chat.toJson());
    } catch (e) {
      log.e('updateChat Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteChat(Chat chat) async {
    try {
      final instance = FirebaseFirestore.instance;
      final batch = instance.batch();
      var collection =
          instance.collection('chats').doc(chat.id).collection('messages');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      log.i("Deleting message docs");
      await batch.commit();
      log.i("Deleting chats doc");
      await _chatsCollectionReference.doc(chat.id).delete();
    } catch (e) {
      log.e('deleteChat Error: ${e.toString()}');
      rethrow;
    }
  }

  Stream<List<Chat>> getChats() {
    log.i("Getting chats: ${_authService.currentUser!.uid}");
    try {
      return _chatsCollectionReference
          .where('members', arrayContains: _authService.currentUser!.uid)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((DocumentSnapshot documentSnapshot) => Chat.fromJson(
                  documentSnapshot.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      log.e('getChats Error: ${e.toString()}');
      rethrow;
    }
  }

  ///Chat Message========================================================
  Future<String> getChatMessageId(Chat chat) async {
    log.i("Sending message");
    try {
      final messageDocRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chat.id)
          .collection('messages')
          .doc();
      return messageDocRef.id;
    } catch (e) {
      log.e('createChat Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<ChatMessage> addChatMessage(Chat chat, ChatMessage message,
      {String? id}) async {
    log.i("Sending message");
    try {
      final messageDocRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chat.id)
          .collection('messages')
          .doc(id);

      if (id != null) message = message.copyWith(id: messageDocRef.id);

      await messageDocRef.set(message.toJson());
      return message;
    } catch (e) {
      log.e('createChat Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteChatMessage(String chatId, String messageId) async {
    await _chatsCollectionReference
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Stream<List<ChatMessage>> getChatMessagesStream(String chatId) {
    final query = _chatsCollectionReference
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((DocumentSnapshot doc) =>
              ChatMessage.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
