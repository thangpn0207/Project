// ignore: import_of_legacy_library_into_null_safe
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/services/repository_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

import '../injection_container.dart';
// ignore: import_of_legacy_library_into_null_safe

class Authentication {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Repository _repository;
  static final _clientIDWeb =
      '52555886797-sd0gdlj8qos7psqquhb4ij0k97b7r641.apps.googleusercontent.com';

  Authentication(this._repository,
      {FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(scopes: <String>[
              'email',
              'https://www.googleapis.com/auth/contacts.readonly',
            ]);

  Future<User> signInWithGoggle() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: _clientIDWeb);

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;
    bool user = await _repository.checkUser(userDetails!.uid);
    if (user == false) {
      UserModel newUser = UserModel(
          id: userDetails.uid,
          email: userDetails.email,
          displayName: userDetails.displayName,
          imgUrl: userDetails.photoURL);
      _repository.registerUser(newUser);
      for (int i = 0; i < 5; i++) {
        await _repository.updateUserChatList(userDetails.uid, i.toString());
      }
    }

    return userDetails;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? userDetails = userCredential.user;
      return userDetails;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('NO user');
      } else if (e.code == 'wrong-password') {
        print('wrong pass');
      }
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String displayName) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserModel?> getUser() async {
    var firebaseUser = _firebaseAuth.currentUser;
    var user =  _repository.getUser(firebaseUser!.uid);
    return user;
  }

  Future<void> updateDisplayName(String displayName) async {
    var user = _firebaseAuth.currentUser;
    user!.updateDisplayName(displayName);
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = _firebaseAuth.currentUser;
    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser!.email ?? '', password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = _firebaseAuth.currentUser;
    firebaseUser!.updatePassword(password);
  }

  Future<void> updatePhotoUrl(String url) async {
    var firebaseUser = _firebaseAuth.currentUser;
    firebaseUser!.updatePhotoURL(url);
  }

  Future<bool> isSignIn() async {
    return _firebaseAuth.authStateChanges() != null;
  }

  Future signOut() async {
    Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }
}
