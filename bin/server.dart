import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'article.dart';

List<Article> articles = [];

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/articles', _getArticlesHandler)
  ..post('/articles', _postArticleHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Future<Response> _postArticleHandler(Request request) async {
  String body = await request.readAsString();

  try {
    Article article = articleFromJson(body);
    articles.add(article);
    return Response.ok(articleToJson(article));
  } catch (e) {
    return Response(400);
  }
}

Response _getArticlesHandler(Request request) {
  return Response.ok(articlesToJson(articles));
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
