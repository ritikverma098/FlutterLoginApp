import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_rep/src/entities/entities.dart';
import 'package:user_rep/src/models/my_user.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }): _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;


  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');
  @override
  Stream<User?> get user{
    return _firebaseAuth.authStateChanges().map((firebaseUser){
      final user = firebaseUser;
      return user;
    });
  }



  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try{
     UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
         email: myUser.email,
         password: password
     );
     myUser = myUser.copyWith(id: user.user!.uid);
     return myUser;
    }catch (e){
      log(e.toString());
      rethrow;
    }

  }

  @override
  Future<void> signIn(String email, String password) async {

    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    }catch(e){
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logout() async{
    try{
        await _firebaseAuth.signOut();
    }catch(e){
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try{
      await _firebaseAuth.sendPasswordResetEmail(
          email: email);
    }catch(e)
    {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try{
      return userCollection.doc(myUserId).get().then((value) =>
      MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!))
      );
    }catch(e)
    {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async{
    try{
      log("DATA:${user.toEntity().toDocument()}");
      await userCollection.doc(user.id).set(user.toEntity().toDocument());
    }catch(e){
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String file, String userID) async {
    try{
      File imageFile = File(file);
      Reference firebaseStorageRef = FirebaseStorage
          .instance.ref().child('$userID/pp/${userID}_lead');
      await firebaseStorageRef.putFile(imageFile);
      String url = await firebaseStorageRef.getDownloadURL();
      await userCollection.doc(userID).update({'picture':url});
      return url;
    }catch(e)
    {
      log(e.toString());
      rethrow;
    }
  }

}