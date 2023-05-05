import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'advertisements.dart';
import 'users.dart';

class Starter {
  Handler get handler {
    var router = Router();

    router.mount('/users', Users().handler);
    router.mount('/advertisement', Advertisements().handler);

    return router;
  }
}