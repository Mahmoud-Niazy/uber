import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio ;
  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/',
        receiveDataWhenStatusError: true ,
        // connectTimeout: Duration(
        //   milliseconds: 50000,
        // ),
        // receiveTimeout: Duration(
        //   milliseconds: 50000,
        // ),
        contentType: 'application/json',
        // validateStatus: (statusCode){
        //   if(statusCode == null){
        //     return false;
        //   }
        //   if(statusCode == 422){ // your http status code
        //     return true;
        //   }else{
        //     return statusCode >= 200 && statusCode < 300;
        //   }
        // },
      ),
    );
  }

  static Future<Response> getData({
    required String url ,
    Map<String,dynamic>? query ,
    String? token ,

  })async{
    dio.options.headers ={
      'Content-Type' : 'application/json' ,
      'Authorization': 'Bearer $token',
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData(
      {
        required String url,
        Map<String,dynamic>? query ,
        dynamic data ,
        String? token ,
      }
      )async{
    dio.options.headers= {
      'Content-Type' : 'application/json' ,
      'Authorization': token,
    };

    return await dio.delete(url);
  }

  static Future<Response> postData ({
    required String url,
    Map<String,dynamic>? query ,
    dynamic data ,
    // String? token,

  })async{

    dio.options.headers= {
      'Content-Type' : 'application/json' ,
      'Authorization': 'key=',

    };

    return await dio.post(
      url,
      queryParameters: query,
      data: data ,
    );
  }

  static Future<Response> putData({
    required String url,
    required dynamic data ,
    required String token ,
  })async{
    dio.options.headers= {
      'Content-Type' : 'application/json' ,
      'Authorization': token,
    };
    return await dio.put(
      url,
      data: data,
    );
  }


}
