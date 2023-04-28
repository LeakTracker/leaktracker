import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:water_loss_project/constant/constant.dart';

class DefaultButton extends StatelessWidget {
  // Variables
  final String title;
  final bool loading;

  const DefaultButton({
    super.key,
    required this.title,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: COLOR_LIGHT_GREEN,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 15,
                      width: 20,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseSync,
                        colors: [Colors.red, Colors.amber, Colors.green],
                        strokeWidth: 2,
                      ),
                    )
                  ],
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  color: COLOR_GREEN,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
              ),
      ),
    );
  }
}
