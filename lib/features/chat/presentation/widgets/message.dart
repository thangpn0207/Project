import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/core/utils/constaints.dart';
import 'package:app_web_project/features/chat/presentation/blocs/message_bloc/message_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/message_bloc/message_state.dart';
import 'package:app_web_project/features/profile/presentation/pages/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'full_photo.dart';

class MessageItem extends StatelessWidget {
  final String userId;
  final ChatMessage message;
  final String beforeMessageTs;
  final String beforeMessageSendBy;

  MessageItem(
      {Key? key,
      required this.message,
      required this.userId,
      required this.beforeMessageTs,required this.beforeMessageSendBy})
      : super(key: key);
  String date = '';

  @override
  Widget build(BuildContext context) {
    bool isMe = userId == message.sendBy;
    bool checkTimeMessBeforeDifferentDate =false;
    String timeSend =
        Constants.millisecondsToFormatString(message.lastMessageTs);
    String time = timeSend;
    if (beforeMessageTs != '') {
      String timeSendBefore =
          Constants.millisecondsToFormatString(beforeMessageTs);
      checkTimeMessBeforeDifferentDate =funcCheckTimeMessBeforeDifferentDate(beforeMessageTs,message.lastMessageTs);
      if (timeSendBefore == timeSend && message.sendBy==beforeMessageSendBy) {
        time = '';
      }
    }else{
      checkTimeMessBeforeDifferentDate =true;
    }
    return BlocBuilder<MessageBLoc, MessageState>(
      builder: (context, state) {
        if (state is MessageStateLoaded) {
          return Container(
            margin: time == ''
                ? EdgeInsets.only(top: 2.h)
                : EdgeInsets.only(top: 10.h),
            child: Column(
              children: [
                checkTimeMessBeforeDifferentDate?driverDate(context,message.lastMessageTs):Container(),
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    isMe
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            userModel: state.userModel,
                                            userId: userId,
                                          )));
                            },
                            child: CachedNetworkImage(
                              imageUrl:
                                  state.userModel.imgUrl!.replaceAll('///', '//'),
                              imageBuilder: (context, imageProvider) => Container(
                                height: 40.h,
                                width: 40.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                    )),
                              ),
                              placeholder: (context, url) => Container(
                                transform: Matrix4.translationValues(0, 0, 0),
                                child: Container(
                                    width: 40.w,
                                    height: 40.h,
                                    child: Center(
                                        child: new CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                    isMe
                        ? Container()
                        : Container(
                            width: kIsWeb?0:1.w,
                          ),
                    Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        time == ''
                            ? Container()
                            : Text(time,style:TextStyle(fontSize: 12.sp,color: Colors.black45),),
                        message.type == 'text'
                            ? textMessage(context, message, isMe)
                            : imageMessage(context, message.message),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget textMessage(context, ChatMessage message, bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: isMe ? HexColor('#f26968') : HexColor('#dfe2d2'),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          )),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65.w,
        minHeight: 40.h,
      ),
      child: Text(
        message.message,
        style: TextStyle(
            fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget imageMessage(context, imageUrlFromFB) {
    return Container(
      width: 160.w,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullPhoto(url: imageUrlFromFB)));
        },
        child: Hero(
          transitionOnUserGestures: true,
          tag: imageUrlFromFB,
          child: CachedNetworkImage(
            imageUrl: imageUrlFromFB,
            imageBuilder: (context, imageProvider) => Container(
              height: 160.h,
              width: 160.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              transform: Matrix4.translationValues(0, 0, 0),
              child: Container(
                  width: 60.w,
                  height: 80.h,
                  child: Center(child: new CircularProgressIndicator())),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            width: 60.w,
            height: 80.h,
            fit: kIsWeb ? BoxFit.fill : BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget driverDate(context,String messTs) {
    String timeSend = checkDay(messTs);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(width: 72.w, child: Divider()),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 11.w),
              child: Text(
                timeSend,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Container(width: 72.w, child: Divider()),
          ),
        ],
      ),
    );
  }

  bool funcCheckTimeMessBeforeDifferentDate(String beforeMessageTs, String messageTs) {
    var dateTimeMessSend = Constants.stringTimeToDate(int.parse(messageTs));
    var dateTimeMessBeforeSend =
        Constants.stringTimeToDate(int.parse(beforeMessageTs));
    var dayBetween =Constants.daysBetween(dateTimeMessBeforeSend, dateTimeMessSend);
    if (dayBetween > 0) {
      return true;
    } else {
      return false;
    }
  }

  String checkDay( String messageTs){
    var now =DateTime.now();
    var dateTimeMessSend = Constants.stringTimeToDate(int.parse(messageTs));
    var dayTsAndNow = Constants.daysBetween(dateTimeMessSend, now);
    if(dayTsAndNow==0){
      return "Today";
    } else if(dayTsAndNow ==1){
      return 'Yesterday';
    }else{

      return Constants.dateYearFormatString(messageTs);
    }
  }
}
