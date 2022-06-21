import 'package:dio/dio.dart';
import 'package:getx_dio/Model/list_postmodel.dart';
import 'package:getx_dio/Model/post_model.dart';

class RemoteService {
  final Dio dio;
  static const String url = "https://jsonplaceholder.typicode.com/posts";

  RemoteService(this.dio);

  getAllPost(int page) async {
    const int _limit = 10;
    return await dio.get("$url?_limit=$_limit&_page=$page").then((values) {
      if (values.statusCode == 200) {
        List<PostModel> data = [];
        values.data.forEach((eachValue) {
           data.add(PostModel.fromMap(eachValue));
        });
        return ListPage(grandTotalCount: values.data.length, itemList: data);
      }
    });
  }




}
