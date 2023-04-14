import 'dart:convert';

import 'package:firebase_dart/core.dart';
import 'package:firebase_dart/database.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../configurations.dart';

class Users {
  Future<FirebaseApp> initApp() async {
    late FirebaseApp app;

    try {
      app = Firebase.app();
    } catch (e) {
      app = await Firebase.initializeApp(
          options: FirebaseOptions.fromMap(Configurations.firebaseConfig));
    }

    return app;
  }

  Handler get handler {
    var router = Router();

    router.post('/register', (Request request) async {
      var projectData = await request.readAsString();
      if (projectData.isEmpty) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'No data found'}),
            headers: {'Content-Type': 'application/json'});
      }
      final payload = jsonDecode(projectData);
      final uid = payload['id'];
      final email = payload['email'];
      final phone = payload['phone'];
      final name = payload['name'];

      if (uid == null) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'Missing id'}),
            headers: {'Content-Type': 'application/json'});
      } else if (email == null) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'Missing email'}),
            headers: {'Content-Type': 'application/json'});
      } else if (name == null) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'Missing name'}),
            headers: {'Content-Type': 'application/json'});
      } else if (phone == null) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'Missing phone'}),
            headers: {'Content-Type': 'application/json'});
      }

      final app = await initApp();
      final db =
      FirebaseDatabase(app: app, databaseURL: Configurations.databaseUrl);
      final ref = db.reference().child('users');
      await ref.child(uid).set({
        "name": name,
        "email": email,
        "phone": phone
      });

      return Response.ok(jsonEncode({'success': true}),
          headers: {'Content-Type': 'application/json'});
    });

    router.get('/<id>', (request, String id) async {
      var app = await initApp();

      final db =
      FirebaseDatabase(app: app, databaseURL: Configurations.databaseUrl);
      final ref = db.reference().child('users').child(id);

      var responseData;

      await ref.once().then((value) {
        responseData = value.value;
      });

      return Response.ok(json.encode(responseData),
          headers: {'content-type': 'application/json'});
    });

    return router;
  }

}