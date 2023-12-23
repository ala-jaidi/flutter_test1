import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/blog_model.dart';

class BlogServices {
  final String apiUrl;

  BlogServices({required this.apiUrl});

  List<Blog> _blogList = [];
  final _blogStreamController = StreamController<List<Blog>>.broadcast();

  Future<List<Blog>> fetchBlogList() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _blogList = data.map((item) => Blog.fromJson(item)).toList();
        _notifyListeners();
        return _blogList; // Return the list of blogs
      } else {
        throw Exception('Failed to load blog list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching blog list: $e');
    }
  }

  Future<void> createBlog({
    required String titre,
    required String description,
    required String lieu,
    required html.File imageFile,
    required String date,
    required double prix,
  }) async {
    try {
      // Utilize FileReader to read the bytes of the Blob
      var reader = html.FileReader();
      reader.readAsArrayBuffer(imageFile);

      // Wait for the reading to be completed
      await reader.onLoadEnd.first;

      // Check if the image file was successfully loaded
      if (reader.error != null) {
        throw Exception('Error loading image: ${reader.error}');
      }

      // Get the bytes from the reader's result
      var imageData = Uint8List.fromList(reader.result as List<int>);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );

      // Add the image file and other required fields
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageData,
        filename: imageFile.name,
        contentType: MediaType('image', 'png'),
      ));

      request.fields['titre'] = titre;
      request.fields['description'] = description;
      request.fields['lieu'] = lieu;
      request.fields['date'] = date;
      request.fields['prix'] = prix.toString();

      final response = await request.send();

      if (response.statusCode == 201) {
        // Blog created successfully
        await fetchBlogList();
      } else {
        throw Exception('Failed to create blog. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating blog: $e');
    }
  }

  Future<Image> loadImageFromUrl(String imageUrl) async {
    try {
      final fullUrl = 'http://localhost:9097/$imageUrl'; // Prepend the base URL
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        return Image.memory(
          bytes,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain, // Try different fit options
        );
      } else {
        throw Exception('Failed to load image from URL. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading image from URL: $e');
    }
  }

  List<Blog> get blogList => _blogList;

  Stream<List<Blog>> get blogStream => _blogStreamController.stream;

  void _notifyListeners() {
    _blogStreamController.add(_blogList);
  }

  void dispose() {
    _blogStreamController.close();
  }

  void setBlogList(List<Blog> blogList) {
    _blogList = blogList;
    _notifyListeners();
  }

  Future<void> updateBlog({
    required int blogId,
    required String titre,
    required String description,
    required String lieu,
    html.File? imageFile,
    required String date,
    required double prix,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$apiUrl/$blogId'),
      );

      // Si un nouveau fichier image est fourni, ajoutez-le à la requête
      if (imageFile != null) {
        var reader = html.FileReader();
        reader.readAsArrayBuffer(imageFile);
        await reader.onLoadEnd.first;

        if (reader.error != null) {
          throw Exception('Error loading image: ${reader.error}');
        }

        var imageData = Uint8List.fromList(reader.result as List<int>);

        // Ajoutez l'image au formulaire
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageData,
          filename: imageFile.name,
          contentType: MediaType('image', 'png'),
        ));
      }

      // Ajoutez les autres champs au formulaire
      request.fields['titre'] = titre;
      request.fields['description'] = description;
      request.fields['lieu'] = lieu;
      request.fields['date'] = date;
      request.fields['prix'] = prix.toString();

      // Envoyez la requête
      var response = await request.send();

      if (response.statusCode == 200) {
        // Mettez à jour la liste des blogs après la mise à jour réussie
        await fetchBlogList();
      } else {
        throw Exception('Failed to update blog. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating blog: $e');
    }
  }

  Future<void> deleteBlog(int blogId) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$blogId'));

      if (response.statusCode == 200) {
        await fetchBlogList();
      } else {
        throw Exception('Failed to delete blog. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting blog: $e');
    }
  }

  // Ajout d'une méthode pour vider le StreamController
  void clearBlogList() {
    _blogList.clear();
    _notifyListeners();
  }
}
