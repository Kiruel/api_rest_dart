// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

List<Article> articlesFromJson(String str) => List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articlesToJson(List<Article> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
    Article({
        required this.title,
        required this.content,
    });

    final String title;
    final String content;

    Article copyWith({
        String? title,
        String? content,
    }) => 
        Article(
            title: title ?? this.title,
            content: content ?? this.content,
        );

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'],
        content: json['content'],
    );

    Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
    };
}
