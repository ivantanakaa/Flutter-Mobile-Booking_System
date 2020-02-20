import 'package:flutter/material.dart';
import 'package:member_apps/ui/shared_colors.dart';

class SharedButton extends StatefulWidget {
  final String text;
  final Widget preWidget;
  final Widget posWidget;
  final Function onTap;
  final double height;
  final EdgeInsetsGeometry margin;
  final bool isDisabled;
  final bool isLoading;

  const SharedButton(
      {Key key,
      this.text,
      this.preWidget,
      this.posWidget,
      this.onTap,
      this.height = 50,
      this.margin,
      this.isDisabled = false,
      this.isLoading = false})
      : super(key: key);

  @override
  _SharedButtonState createState() => _SharedButtonState();
}

class _SharedButtonState extends State<SharedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin:
          widget.margin ?? EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: RaisedButton(
        elevation: (widget.isDisabled || widget.isLoading) ? 0 : 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: (widget.isDisabled || widget.isLoading)
            ? SharedColors.btnDisabledColor
            : SharedColors.primaryColor,
        onPressed:
            (widget.isDisabled || widget.isLoading) ? null : widget.onTap,
        child: (widget.isLoading)
            ? Center(
              child: Container(
                  alignment: Alignment.center,
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(SharedColors.primaryColor),),
                ),
            )
            : Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.preWidget ?? Container(),
                    Text(
                      widget.text,
                      style: TextStyle(color: SharedColors.btnTxtColor),
                    ),
                    widget.posWidget ?? Container()
                  ],
                ),
              ),
      ),
    );
  }
}