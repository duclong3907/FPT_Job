import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        SizedBox(height: 50),
        Row(
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
                color: Color.fromARGB(255, 110, 59, 228),
              ),
              child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 70),
                Text('jobs', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 120),
                Image(
                  image: AssetImage('assets/images/bell.png'),
                  width: 33,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Find Your\nDream Job',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          color: Color.fromARGB(255, 110, 59, 228))),
                  Image(
                    image: AssetImage('assets/images/plane.png'),
                    width: 100,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for job',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: Icon(Icons.filter_list),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text('Recent jobs',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(width: 15),
                  Text('All Jobs',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 30),
              ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 110, 59, 220),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Text('Full Time'),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Text('Remote'),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Text('130k/ Years'),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.bookmark_border_rounded),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/plane.png'),
                                    radius: 30,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    'Product Designer',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                  Text(
                                    'Figma Lab',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.white,
                                    ),
                                    Text('12m ago',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.supervised_user_circle_sharp,
                                      color: Colors.white,
                                    ),
                                    Text('+50 applied',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}
