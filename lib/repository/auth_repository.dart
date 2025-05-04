import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../resources/constants/constants.dart';
import '../resources/utils.dart';

class AuthRepository {
  AuthRepository._privateConstructor();
  static final AuthRepository instance = AuthRepository._privateConstructor();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> signup({required UserModel user}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password,
      );

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        UserModel newUser = user.copyWith(id: firebaseUser.uid);
        await _firestore.collection('users').doc(newUser.id).set(newUser.toFirestore());

        return right(null);
      } else {
        return left(Failure('User creation failed.'));
      }
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Unknown error'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> login({required UserModel user}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password,
      );

      DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user?.uid).get();
      if (!doc.exists) return left(Failure('User data not found'));

      return right(UserModel.fromFirestore(doc));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Unknown error'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> continueWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return left(Failure('Google Sign-In aborted'));
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential;
      try {
        userCredential = await _auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          return left(Failure('This email is already registered with a different sign-in method'));
        }
        rethrow;
      }

      User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return left(Failure('Google authentication failed'));
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      UserModel user = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? 'guest@example.com',
        userType: UserType.google,
        name: firebaseUser.displayName,
        img: firebaseUser.photoURL,
      );

      // Only create user document if it doesn't exist
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(firebaseUser.uid).set(user.toFirestore());
        await Utils.uploadNotificationToFirebase(
          title: 'Account Created',
          body: 'Your account created successfully.',
        );
      } else {
        await Utils.uploadNotificationToFirebase(
          title: 'Account Logged in',
          body: 'Your account logged in successfully.',
        );
        user = UserModel.fromFirestore(userDoc);
      }

      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Google Sign-In failed'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Failed to send reset email'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> checkEmailExist({required String email}) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();

      final exists = doc.docs.isNotEmpty;
      return right(exists);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Failed to send reset email'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid logout() async {
    try {
      await _auth.signOut();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
