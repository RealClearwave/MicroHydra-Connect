import 'package:flutter/material.dart';
import 'package:mhconnect/common/color_extension.dart';

class DeviceRow extends StatelessWidget {
  final Map lObj;
  const DeviceRow({super.key, required this.lObj});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: TColor.primaryLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  lObj["icon"] as IconData? ?? Icons.phone_iphone,
                  color: TColor.primary,
                  size: 30,
                ),
              ),
             const SizedBox(width: 8,), 
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lObj["name"].toString(),
                      textAlign: TextAlign.left,
                      style:  TextStyle(
                          color: TColor.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),

                     const SizedBox(
                      height: 8,
                    ), 

                    Text(
                      lObj["sub_name"].toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.unselect.withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),

              const SizedBox(
                width: 4,
              ), 


              Text(
                      lObj["speed"].toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: TColor.unselect,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),


               const SizedBox(
                width: 8,
              ), 
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.only(left: 50),
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
