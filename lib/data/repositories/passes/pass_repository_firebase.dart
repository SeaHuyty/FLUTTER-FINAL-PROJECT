import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velo_toulouse_redesign/models/pass_model.dart';
import '../../dtos/pass_dto.dart';
import 'pass_repository.dart';

class PassRepositoryFirebase implements PassRepository {
  final String _url = 'https://select-pass-default-rtdb.asia-southeast1.firebasedatabase.app/pass.json';

  @override
  Future<List<PassModel>> getAvailablePasses() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      return data.entries.map((entry) {
        return PassDto.fromSnapshot(entry.key, entry.value);
      }).toList();
    } else {
      throw Exception('Could not load passes from Firebase');
    }
  }

  @override
  Future<PassModel?> getPassById(String passId) async {
    return null;
  }
}