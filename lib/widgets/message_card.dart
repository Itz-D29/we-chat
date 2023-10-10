import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wechat/controllers/auth_controller.dart';
import 'package:wechat/models/Message.dart';
import 'package:wechat/utility/dialogs.dart';
import 'package:wechat/utility/my_date_util.dart';

import '../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {

    bool isMe = AuthController.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: (){
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage());
  }


  Widget _blueMessage() {
    print('Blue_Message');
    print('Time${MyDateUtil.getFormattedTime(context: context, time: widget.message.sent)}');
    if (widget.message.read.isEmpty) {
      AuthController.updateMessageReadStatus(widget.message);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 221, 245, 255),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
          margin: EdgeInsets.symmetric(
              vertical: mq.height * .01, horizontal: mq.width * .04),
          padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
          child: widget.message.type == Type.text
              ? Text(
                  widget.message.msg,
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                )
              : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2,),
                  ),
                    imageUrl: widget.message.msg,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image,
                      size: 70,
                    ),
                  ),
              ),
        ),
        Padding(
          padding: EdgeInsets.only(left: mq.width * .03),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    print('Green_Message');
    print(MyDateUtil.getFormattedTime(
        context: context, time: widget.message.sent));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 218, 255, 176),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30)),
          ),
          margin: EdgeInsets.symmetric(
              vertical: mq.height * .01, horizontal: mq.width * .04),
          padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
          child: widget.message.type == Type.text
              ? Text(
                  widget.message.msg,
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                )
              : widget.message.type == Type.image ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2,),
                    ),
                    imageUrl: widget.message.msg,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image,
                      size: 70,
                    ),
                  ),
          ) : ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2,),
              ),
              imageUrl: widget.message.msg,
              errorWidget: (context, url, error) => const Icon(
                Icons.video_call,
                size: 70,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: mq.width * .02,
            ),
         (widget.message.read.isNotEmpty) ?
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ) :  const Icon(
               Icons.done_all_rounded,
              color: Colors.grey,
              size: 20,
              ),
            const SizedBox(width: 1),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(color: Colors.black, fontSize: 13),
            ),
            SizedBox(
              width: mq.width * .04,
            ),
          ],
        ),
      ],
    );
  }


  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(

            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8)
                ),
              ),

              widget.message.type == Type.text
                  ? _OptionItem(
                    icon: const Icon(Icons.copy,color: Colors.blue,size: 26,),
                    name : 'Copy Text',
                    onTap: () async{
                      await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value) {
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, 'Text Copied');
                      });
                    }
                  )
                  : _OptionItem(
                    icon: const Icon(Icons.save,color: Colors.blue,size: 26,),
                    name : 'Save Image',
                    onTap: () async{
                      try{
                        await GallerySaver.saveImage(widget.message.msg, albumName: 'We Chat').then((success) {
                          Navigator.pop(context);
                          if(success !=null && success) {
                            Dialogs.showSnackbar(context, 'Image Successfully Save');
                          }
                        });
                      }catch(e){
                        Exception('SavingImage$e');
                      }
                    }
              ),
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              if(widget.message.type == Type.text && isMe)
               _OptionItem(
                  icon: const Icon(Icons.edit,color: Colors.blue,size: 26,),
                  name : 'Edit Message',
                  onTap: () {}
              ),

              if(widget.message.type == widget.message.type && isMe)
              _OptionItem(
                  icon: const Icon(Icons.delete_forever,color: Colors.red,size: 26,),
                  name : 'Delete Message',
                  onTap: () async{
                    await AuthController.deleteMessage(widget.message).then((value){
                      Navigator.pop(context);
                    });
                  }
              ),

              if(isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye,color: Colors.blue,),
                  name : 'Sent At: ${MyDateUtil.getFormattedTime(context: context, time: widget.message.sent)}',
                  onTap: () {}
              ),

              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye_outlined,color: Colors.green),
                  name : widget.message.read.isEmpty ? 'Read At: Not seen yet' :'Read At: ${MyDateUtil.getFormattedTime(context: context, time: widget.message.read)}' ,
                  onTap: () {}
              ),

            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {

  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem({required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding:  EdgeInsets.only(
            left: mq.width * .05,
            top:  mq.height * .015,
            bottom: mq.height * .01),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text('    $name',
                  style: const TextStyle(color: Colors.black54,fontSize: 15,letterSpacing: 0.5),)),

          ],
        ),
      ),
    );
  }
}

