import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> uploadToIPFS(File file) async {
  await dotenv.load(fileName: ".env");
  final apiKeyQuicknodeIPFS = dotenv.env['QUICKNODE_API_URL_IPFS'].toString();
  const apiUrl = 'https://api.quicknode.com/ipfs/rest/v1/s3/put-object';
  String fileName = file.path.split('/').last;
  final random = Random();
  final hash = List.generate(8, (index) => random.nextInt(10)).join();
  final hashedFileName = '${hash}_${fileName}';
  try {
    print("inside the try catch");
    final headers = {
      'x-api-key': apiKeyQuicknodeIPFS,
    };
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('Body', file.path))
      ..fields['Key'] = hashedFileName
      ..fields['ContentType'] = 'text';
    final response = await http.Response.fromStream(await request.send());
    final jsonResponse = jsonDecode(response.body);
    final cid = jsonResponse['pin']['cid'];

    return cid;
  } catch (e) {
    return null;
  }
}