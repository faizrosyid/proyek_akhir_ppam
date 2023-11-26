import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir/models/slider_model.dart';

class Sliderr{
  List<SliderrModel> sliderr=[];


  Future<void> getSliderr() async{
    String url="https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=1fdc03cd06644ce98b0f5e28fd933b62";
    var response= await http.get(Uri.parse(url));
    var jsonData= jsonDecode(response.body);

    if(jsonData['status'] == 'ok'){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"] != null && element['description'] != null){
          SliderrModel sliderrModel = SliderrModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          sliderr.add(sliderrModel);
        }
      });
    }

  }
}