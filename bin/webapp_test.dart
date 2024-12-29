import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

String deploymentID = "AKfycbxNsl10nFcs...................qYT8uKCwfewK_jTo0wKk";
String scriptUrl = "https://script.google.com/macros/s/$deploymentID/exec";
String sheetID = "19w77cZyG9Iu.............Ibq1HsokUP9Nw";

void main() async {
  Map body = {"sheetID": sheetID, "action": "read"};
  Map dataDict = await triggerWebAPP(url: scriptUrl, body: body);

  int totalRows = dataDict["total_rows"];
  print("Righe: ${totalRows.toString()}");
  List columns = dataDict["columns"];
  print("Colonne: $columns");
  List data = dataDict["data"];
  print("Data:");
  print(data);
}

Future<Map> triggerWebAPP({required String url, required Map body}) async {
  Map dataDict = {};
  Uri urlPost = Uri.parse(url);
  try {
    await http.post(urlPost, body: body).then((response) async {
      if (response.statusCode == 200) {
        dataDict = jsonDecode(response.body);
      } else if (response.statusCode == 302) {
        String redirectedUrl = response.headers['location'] ?? "";
        if (redirectedUrl.isNotEmpty) {
          Uri url = Uri.parse(redirectedUrl);
          await http.get(url).then((response) {
            if (response.statusCode == 200) {
              dataDict = jsonDecode(response.body);
            }
          });
        }
      } else {
        print("StatusCode: ${response.statusCode}");
      }
    });
  } catch (e) {
    print("Error: $e");
  }

  return dataDict;
}
