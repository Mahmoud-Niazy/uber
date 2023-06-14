import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio ;
  static Init(){
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
        validateStatus: (statusCode){
          if(statusCode == null){
            return false;
          }
          if(statusCode == 422){ // your http status code
            return true;
          }else{
            return statusCode >= 200 && statusCode < 300;
          }
        },
      ),
    );
  }

  static Future<Response> GetData({
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

  static Future<Response> DeleteData(
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

  static Future<Response> PostData ({
    required String url,
    Map<String,dynamic>? query ,
    dynamic data ,
    // String? token,

  })async{

    dio.options.headers= {
      'Content-Type' : 'application/json' ,
      'Authorization': 'key=AAAAWbrUMew:APA91bGdoONCURVyrG3Ivt_80uAPDvpnjr8XrDkW77qb9rJOBEsE2ldsUnccXVZgYaALADoYmQTz0BoBqdqma5Db1d1cQQQohLGu2fxBip2eF3w4mR63yO75lf2FQergtr0-5ZY03bEY',

    };

    return await dio.post(
      url,
      queryParameters: query,
      data: data ,
    );
  }

  static Future<Response> PutData({
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
