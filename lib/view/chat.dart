import 'package:aqar/controller/chatController.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/chatPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllChats extends StatefulWidget {
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  List<ChatModel> _chats;
  @override
  void initState() {
    
    // _getMyChats();
    super.initState();
  }

  _getMyChats() async {
    if (mounted)
      setState(() {
        _chats = null;
      });
    List<ChatModel> chats = await chatController.getHomeChats();
    if (mounted)
      setState(() {
        _chats = chats.reversed.toList();
        _refreshController.refreshCompleted();
      });
  }

  RefreshController _refreshController = RefreshController();
  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _sc,
      //   appBar: buildCustomAppBar(title: "المحادثات"),
      //   body: SmartRefresher(
      //     controller: _refreshController,
      //     enablePullDown: true,
      //     onRefresh: _getMyChats,
      //     header: BezierCircleHeader(),
      //     footer: CustomRefreshFooter(),
      //     child: Padding(
      //       padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
      //       child: _chats == null
      //           ? Center(child: LoadingBouncingGrid.square())
      //           : _chats.length == 0
      //               ? CustomText(
      //                   "لا توجد محادثات بعد",
      //                   size: 13,
      //                   textAlign: TextAlign.center,
      //                   color: appDesign.hint,
      //                 )
      //               : SingleChildScrollView(
      //                 child: Column(
      //                   children:List.generate(_chats.length, (i) => Slidable(
      //                     child:    ChatTile(chatModel: _chats[i]),
      //                             actionPane: SlidableDrawerActionPane(),
      //                             actions: [
      //                               IconButton(
      //                                   icon: Icon(
      //                                     Icons.delete_forever,
      //                                     color: Colors.red,
      //                                   ),
      //                                   onPressed: () async {
      //                                     await chatController.deletChatContact(
      //                                         context, _chats[i].room);
      //                                     if (mounted)
      //                                       setState(() {
      //                                         _chats.removeAt(i);
      //                                       });
      //                                   })
      //                             ]),
                                
      //                   )
                      
      //                 ),
      //               ),
      //     ),
      //   )
        );
  }
}

class ChatTile extends StatelessWidget {
  ChatModel chatModel;

  ChatTile({
    this.chatModel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          chatController.changeopenedChatId(chatModel.room);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        chatModel: chatModel,
                      )));
        },
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
              color: appDesign.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: ExtendedImage(
                  enableLoadState: true,
                  image: NetworkImage(
                    chatModel.image,
                  ),
                  fit: BoxFit.fill,
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          chatModel.title ?? "",
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        chatModel.published == null
                            ? ""
                            : chatModel.published.split("،").first,
                        style: TextStyle(
                            color: appDesign.hint,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    chatModel.lastMsg ?? "",
                    fontWeight: FontWeight.w600,
                    color: appDesign.hint,
                    size: 16,
                    maxLines: 1,
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
