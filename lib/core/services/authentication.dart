// ignore: import_of_legacy_library_into_null_safe
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

// ignore: import_of_legacy_library_into_null_safe

class Authentication {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final Repository _repository;
  static final _clientIDWeb =
      '52555886797-sd0gdlj8qos7psqquhb4ij0k97b7r641.apps.googleusercontent.com';
  Authentication(this._repository,
      {FirebaseAuth? firebaseAuth,
      GoogleSignIn? googleSignIn,
      FacebookAuth? facebookAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
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

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = userCredential.user;
    bool user = await _repository.checkUser(userDetails!.uid);
    UserModel newUser = UserModel(
        id: userDetails.uid,
        email: userDetails.email,
        displayName: userDetails.displayName,
        imgUrl: userDetails.photoURL);
    if (user == false) {
      await _repository.registerUser(newUser);
      for (int i = 0; i < 5; i++) {
        await _repository.updateUserChatList(userDetails.uid, i.toString());
      }
    } else {
      await _repository.updateUserInfo(newUser);
    }

    return userDetails;
  }

  Future<User> signInWithFacebook() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final LoginResult loginResult = await FacebookAuth.instance.login();
    print(loginResult.status);
    // Create a credential from the access token
    final userData = await FacebookAuth.instance.getUserData();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    // Once signed in, return the UserCredential
    User? userDetails = userCredential.user;
    bool user = await _repository.checkUser(userDetails!.uid);
    UserModel newUser = UserModel(
        id: userDetails.uid,
        email: userData['email'],
        displayName: userData['name'],
        imgUrl: userData['picture']['data']['url']);
    if (user == false) {
      await _repository.registerUser(newUser);
      for (int i = 0; i < 5; i++) {
        await _repository.updateUserChatList(userDetails.uid, i.toString());
      }
    } else {
      await _repository.updateUserInfo(newUser);
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
    var user = _repository.getUser(firebaseUser!.uid);
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

  Future<void> resetPassword(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
