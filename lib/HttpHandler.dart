import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'Links.dart';

class HttpHandler {
  static const String _ROOT_URL = 'https://www.givethumb.com/tutorial/Api';
  static const String _GET_LINKS = 'getLinks';
  static const String _DELETE_LINKS = 'deleteLinks';
  static const String _ADD_LINKS = 'addLink';


  static Future<List<Links>> getLinks() async {

    try{
      http.Response response = await http.get('$_ROOT_URL/$_GET_LINKS');

      //Server return 200 ok response
      if(response.statusCode == 200){

        //parse the JSON
        Iterable result = convert.jsonDecode(response.body);
        return result.map((link) => Links.fromJSON(link)).toList();
      }else{
        throw Exception('Failed to fitch the links');
      }
    }catch(e){
      return e;
    }
  }









  //deleting links function
  static Future<bool> deleteLink(String link_id) async{
    try{
      var map = Map<String, dynamic>();
      map['l_id'] = link_id;

      http.Response response = await http.post('$_ROOT_URL/$_DELETE_LINKS', body: map);

      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return e;
    }
  }


  //Add new Links function
  static Future<bool> addLinks(String title, String link) async{

      var map = Map<String, dynamic>();
      map['title'] = title.toString();
      map['link'] = link.toString();

      try{
        http.Response response = await http.post('$_ROOT_URL/$_ADD_LINKS', body: map);
        print('URL-API $_ROOT_URL/$_ADD_LINKS');
        print('reposonse ${response.body}');
        if(response.statusCode == 200){
          return true;
        }else{
          return false;
        }

    }catch(e){
      return e;
    }
  }

}



