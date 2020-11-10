import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/model/categoryModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:aqar/view/searchCityFilterModalSheet.dart';
import 'package:aqar/view/searchOrderFilterModalSheet.dart';
import 'package:aqar/view/searchCatFilterModalSheet.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchBody extends StatefulWidget {
  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  @override
  void initState() {
                if(searchBodyController.fromCategoryPage!=null&&searchBodyController.searchCategoryIdFilter!=null)
    searchBodyController.changesearchCategoryIdFilter(searchBodyController.searchCategoryIdFilter);
else
    searchBodyController.changesearchCategoryIdFilter(0);
    searchBodyController.changesearchedCount(0);
    searchBodyController.changesearchedListOfAds([]);
    searchBodyController.changesearchCityIdFilter(0);
    searchBodyController.changesearchOrderIdFilter("all");
    _searchCat();

    super.initState();
  }
  _searchCat() async {
    searchBodyController.changesearchedListOfAds([
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LoadingBouncingGrid.square(),
        ),
      )
    ]);
    List _searched = await homeBodyController.search(
        cityId: searchBodyController.searchCityIdFilter,
        title: _textEditingController.text,
        sort: searchBodyController.searchOrderIdFilter);
    searchBodyController.changesearchedListOfAds(List.generate(
        _searched[1].length,
        (index) => CustomAdCard(adModel: _searched[1][index])));
    searchBodyController.changesearchedCount(_searched[0]);
    searchBodyController.changefromCategoryPage(null);
  }

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  RefreshController _refreshController = RefreshController();
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sc,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  header: BezierCircleHeader(),
                  footer: CustomRefreshFooter(),
                  onLoading: () async {
                    if (searchBodyController.searchedCount != null &&
                        searchBodyController.searchedCount >
                            searchBodyController.searchedListOfAds.length) {
                      List _searched = await homeBodyController.search(
                          sc: _sc,
                          cityId: searchBodyController.searchCityIdFilter,
                          title: _textEditingController.text,
                          sort: searchBodyController.searchOrderIdFilter);

                      searchBodyController.changesearchedListOfAds(
                          searchBodyController.searchedListOfAds
                            ..addAll(List.generate(
                                _searched[1].length,
                                (index) => CustomAdCard(
                                    adModel: _searched[1][index]))));
                      searchBodyController.changesearchedCount(_searched[0]);
                      _refreshController.position
                          .jumpTo(_refreshController.position.minScrollExtent);
                    }
                    _refreshController.loadComplete();
                  },
                  child: Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: _form,
                        child: CustomTextFormField(
                          lable: "ابحث هنا ...",
                          controller: _textEditingController,
                          onSaved: (v) async {
                            print(v);
                            searchBodyController.changesearchedListOfAds([
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LoadingBouncingGrid.square(),
                                ),
                              )
                            ]);
                            List _searched = await homeBodyController.search(
                                sc: _sc,
                                cityId: searchBodyController.searchCityIdFilter,
                                title: _textEditingController.text,
                                sort: searchBodyController.searchOrderIdFilter);
                            searchBodyController.changesearchedListOfAds(
                                List.generate(
                                    _searched[1].length,
                                    (index) => CustomAdCard(
                                        adModel: _searched[1][index])));
                            searchBodyController
                                .changesearchedCount(_searched[0]);
                          },
                          suffixIcon: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) => SearchCatFilterModalSheet(
                                        textEditingController:
                                            _textEditingController,
                                      ));
                            },
                            child: Icon(
                              Icons.tune,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          StreamBuilder<Object>(
                              stream:
                                  searchBodyController.searchCityIdFilterStream,
                              builder: (context, snapshot) {
                                String title = "المدينة";
                                if(searchBodyController.cities!=null){
                                if (snapshot.data != null) {
                                  for (CityModel cityModel
                                      in searchBodyController.cities)
                                    if (cityModel.id == snapshot.data)
                                      title = cityModel.name;
                                }
                                }
                                return FilterButtonWithDesc(
                                  iconData: Icons.arrow_drop_down,
                                  text: title,
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (ctx) =>
                                            SearchCityFilterModalSheet(
                                              textEditingController:
                                                  _textEditingController,
                                            ));
                                  },
                                );
                              }),
                          Spacer(),
                          StreamBuilder<Object>(
                          stream:
                                  searchBodyController.searchOrderIdFilterStream,
                              builder: (context, snapshot) {
                                String title = "الترتيب";
                                if (snapshot.data != null) {
                                      title =(searchBodyController.arrange==null|| searchBodyController.arrange[snapshot.data]=="الكل")?"الترتيب": searchBodyController.arrange[snapshot.data];
                                }
                              return FilterButtonWithDesc(
                                iconData: Icons.arrow_drop_down,
                                text: title,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) => SearchOrderFilterModalSheet(
                                            textEditingController:
                                                _textEditingController,
                                          ));
                                },
                              );
                            }
                          )
                        ],
                      ),
                      StreamBuilder<List<Widget>>(
                          stream: searchBodyController.searchedListOfAdsStream,
                          builder: (context, snapshot) {
                            return Column(
                              children: snapshot.data==null||snapshot.data.length==0 ? [Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text("نتائج البحث",style: TextStyle(
                                  color: Colors.grey
                                ),),),
                              )]:snapshot.data,
                            );
                          }),
                    ],
                  )),
                ))));
  }
}
