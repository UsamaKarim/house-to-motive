import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:house_to_motive/views/screens/ratingstarScreen.dart';

class writeReview extends StatefulWidget {
  const writeReview({Key? key}) : super(key: key);

  @override
  State<writeReview> createState() => _writeReviewState();
}

class _writeReviewState extends State<writeReview> {
  final List<Map<String, dynamic>> data = [
    {
      'image': 'assets/model1.jpg',
      'name': 'Ken',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'rate': "(5.0)",
      'time': '10/5/2023',
    },
    {
      'image': 'assets/model1.jpg',
      'name': 'Nalli',
      'description':
          "Mauris sed eget nunc lacus velit amet vel.. Mauris sed eget n",
      'rate': "(4.8)",
      'time': '10/12/2023',
    },
    {
      'image': 'assets/model1.jpg',
      'name': 'Zeeshan',
      'description': "Great! Thank you soo much",
      'rate': "(4.9)",
      'time': '10/12/2022',
    },
    {
      'image': 'assets/model1.jpg',
      'name': 'Zeeshan',
      'description': "Great! Thank you soo much",
      'rate': "(4.9)",
      'time': '10/12/2022',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const <InlineSpan>[
                  TextSpan(
                    text: '3 Reviews',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '  ( ',
                    style: TextStyle(
                      color: Color(0xff7390A1),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.star, color: Color(0xffFFB600), size: 14),
                  ),
                  TextSpan(
                    text: ' 4.9 rating)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7390A1),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/Cross icon.svg"),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              double rate = double.parse(
                data[index]['rate'].replaceAll('(', '').replaceAll(')', ''),
              );
              return Container(
                height: size.height / 7,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(data[index]["image"]),
                  ),
                  title: Text(
                    data[index]['name'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff8A8B8F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height / 90),
                      Text(
                        data[index]['description'],
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(height: size.height / 80),
                      Text(
                        data[index]['time'],
                        style: TextStyle(
                          color: Color(0xff8A8B8F),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    width: size.width / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: size.width / 90),
                        Icon(Icons.star, color: Color(0xffFFB600), size: 14),
                        Text(
                          data[index]['rate'],
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            fixedSize: Size(300, 50),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            _showBottomSheetSlider(context);
          },
          child: Text(
            "Write a Review",
            style: TextStyle(color: Color(0xff025BBF)),
          ),
        ),
        SizedBox(height: 20, width: 20),
      ],
    );
  }

  void _showBottomSheetSlider(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: const [
              Expanded(child: ratingstarScreen()),
              // Add your content here
            ],
          ),
        );
      },
    );
  }
}
