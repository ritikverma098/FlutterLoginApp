import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_rep/post_rep.dart';
import 'package:post_rep/src/models/post.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

import 'post_repo.dart';

class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection('posts');
  @override
  Future<Post> createPost(Post post) async {
    try{
      post.postId = const Uuid().v1();
      post.createdAt = DateTime.now();
      await postCollection.doc(post.postId).set(post.toEntity().toDocument());
      return post;
    }catch(e){
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Post>> getPost() {
    try{
      return postCollection.get().then((value) => value.docs.map((e) =>
          Post.fromEntity(PostEntity.fromDocument(e.data()))
      ).toList());
    }
    catch(e){
      log(e.toString());
      rethrow;
    }
  }

}