import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';

  setUp(() async{
    await TestProcess.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
  });

  test('Root', () async {
    final response = await get(Uri.parse(host + '/'));
    expect(response.statusCode, 200);
    expect(response.body, 'Hello, World!\n');
  });

  test('POST articles', () async {
    final response = await post(
      Uri.parse(host + '/articles'),
      body: '{"title":"My super article","content":"My super content"}',
    );
    expect(response.statusCode, 200);
    expect(response.body,
        '{"title":"My super article","content":"My super content"}');
  });

  test('POST articles with empty string', () async {
    final response = await post(
      Uri.parse(host + '/articles'),
    );
    expect(response.statusCode, 400);
  });

  test('GET articles', () async {
    final response = await get(
      Uri.parse(host + '/articles'),
    );
    expect(response.statusCode, 200);
    expect(response.body, '[{"title":"My super article","content":"My super content"}]');
  });

  test('404', () async {
    final response = await get(Uri.parse(host + '/foobar'));
    expect(response.statusCode, 404);
  });
}
