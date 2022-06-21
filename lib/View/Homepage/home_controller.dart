import 'package:get/get.dart';
import 'package:getx_dio/Model/list_postmodel.dart';
import 'package:getx_dio/Model/post_model.dart';
import 'package:getx_dio/Service/remote_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeController extends GetxController with StateMixin<List<PostModel>> {
  final RemoteService remoteService;

  HomeController(this.remoteService);
  late PagingController pagingController;
  RxList<PostModel> dataList = <PostModel>[].obs;
  RxInt limit = 9.obs;
  RxBool showLoading = false.obs;
  int page = 1;
  RxBool hasMore = false.obs;

  @override
  void onInit() {
    super.onInit();
   // scrollController = ScrollController();
    pagingController = PagingController<int, PostModel>(firstPageKey: page);
    pagingController.addPageRequestListener(
      ((pageKey) {
        _fetchKey(pageKey);
        // limitDataFetch(page);
      }),
    );

  }



  Future<void> _fetchKey(int pageKey) async {
    try {
      ListPage newPage = await remoteService.getAllPost(pageKey);
      final previouslyFetchdItemsCount = newPage.itemList.length;
      final isLastPage = newPage.isLastPage(previouslyFetchdItemsCount);
      final newItems = newPage.itemList;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void onClose() {
    super.onClose();
  //  scrollController.dispose();
    pagingController.dispose();
  }
}
