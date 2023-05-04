import 'dart:convert';

import 'package:firebase_dart/core.dart';
import 'package:firebase_dart/database.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import '../configurations.dart';

class Advertisements {
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
    final router = Router();

    router.post('/show', (Request request) async {
      final requestData = await request.readAsString();
      if (requestData.isEmpty) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'No data found'}),
            headers: {'Content-Type': 'application/json'});
      }

      final payload = jsonDecode(requestData);

      final id = payload['id'];
      final animal = payload['animal'];
      final state = payload['state']; //pierdut gasit
      final uid = payload['id_user'];

      if (animal == null) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'Missing animal data'}),
            headers: {'Content-Type': 'application/json'});
      } else if (id == null) {
        return Response.notFound(
            jsonEncode({'success': false, 'error': 'Missing id'}),
            headers: {'Content-Type': 'application/json'});
      } else if (uid == null) {
        return Response.notFound(
            jsonEncode({'success':false, 'error': 'Missing id_user'}),
                headers: {'Content-Type': 'application/json'});
      } else if (state == null) {
        return Response.notFound(
            jsonEncode({'success':false, 'error': 'Missing state'}),
                headers: {'Content-Type': 'application/json'});
      }

      try {
        final app = await initApp();
        final db =
        FirebaseDatabase(app: app, databaseURL: Configurations.databaseUrl);
        final ref = db.reference().child('animals');
        final newPostKey = ref.push().key;
        await ref.child(newPostKey!).update({
          "nume": "Anghel",
          "rasa": "Pachistanez",
          "detalii": "E prost"
        });

        return Response.ok(jsonEncode({'success': true}),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({'success': false, 'error': e.toString()}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    // router.get('/advertisements/:id', (Request request, Boolean bool) async {
    //   if(bool)
    //     final collection = 'advertisements.true';
    //   else
    //     final collection = 'advertisements.false';
    //   try {
    //
    //     final now = DateTime.now();
    //     final cutoff = now.subtract(Duration(days: 7));
    //     final advertisementSnapshot = await _firestore.collection(collection)
    //         .where('created_at', isGreaterThanOrEqualTo: cutoff)
    //         .get();
    //
    //     return Response.ok(jsonEncode({'success': true, 'advertisement': advertisementSnapshot}),
    //         headers: {'Content-Type': 'application/json'});
    //   } catch (e) {
    //     return Response.internalServerError(
    //         body: jsonEncode({'success': false, 'error': e.toString()}),
    //         headers: {'Content-Type': 'application/json'});
    //   }
    // });
    return router;
  }
}