import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:house_to_motive/views/screens/writeReview.dart';


class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final List<Map<String, dynamic>> data = [
    {
      'image': 'assets/model1.jpg',
      'name': 'Ken',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'rate': "5.0",
      'time': '10/5/2023',
    },
    {
      'image': 'assets/model2.jpg',
      'name': 'Nalli',
      'description': "Mauris sed eget nunc lacus veldt amet vel.. Mauris sed eget n",
      'rate': "4.0",
      'time': '10/12/2023',
    },
    {
      'image': 'assets/model2.jpg',
      'name': 'Zeeshan',
      'description': "Great! Thank you soo much",
      'rate': "3.5",
      'time': '10/12/2022',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(height: size.height / 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: const <InlineSpan>[
                    TextSpan(
                      text: '3 Reviews  ( ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(Icons.star, color: Color(0xffFFB600), size: 18),
                    ),
                    TextSpan(
                      text: '4.9 rating )',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                      onTap: (){
                        showBottomSheetSlider(context);
                      },
                      child: SvgPicture.asset('assets/svgs/home/Group 1171274839.svg')),
                  // SizedBox(width: size.width / 20),
                  // ShaderMask(
                  //   shaderCallback: (Rect bounds) {
                  //     return const LinearGradient(
                  //       colors: [Color(0xffFF0092), Color(0xff216DFD)],
                  //     ).createShader(bounds);
                  //   },
                  //   child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                  // ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              // padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                double rate = double.parse(data[index]['rate']);
                return InkWell(
                  onTap: () {
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(
                    // builder: (context) => ProfileChatScreen(userId: '',)),
                    // );
                  },
                  child: GestureDetector(
                    onTap: () {
                    showBottomSheetSlider(context);
                  },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(data[index]["image"]),
                      ),
                      title: Text(
                        data[index]['name'],
                        style: const TextStyle(fontSize: 14, color: Color(0xff8A8B8F), fontWeight: FontWeight.bold),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [SizedBox(height: size.height/90,),
                          Text(
                            data[index]['description'],
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          SizedBox(height: size.height/80,),
                          Text(
                            data[index]['time'],
                            style: const TextStyle(color: Color(0xff8A8B8F), fontSize: 12),
                          ),
                        ],
                      ),

                      trailing: Container(
                        width: size.width/10, // Set a specific width for the trailing widget
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Color(0xffFFB600), size: 13),
                            Text(
                              data[index]['rate'],
                              style: const TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}


void showBottomSheetSlider(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          children: [
            Expanded(child: writeReview()),
            // Add your content here
          ],
        ),
      );
    },
  );
}