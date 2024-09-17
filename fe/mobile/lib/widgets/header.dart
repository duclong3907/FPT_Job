import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  width: 100,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                    color: Color.fromARGB(255, 110, 59, 228),
                  ),
                  child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.png')),
                ),
              ),
              const Image(
                image: AssetImage('assets/images/techjobs_logo.png'),
                height: 40,
              ),
              const Image(
                image: AssetImage('assets/images/bell.png'),
                width: 100,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Find Your\nDream Job',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                  color: Color.fromARGB(255, 110, 59, 228),
                ),
              ),
              Image(
                image: AssetImage('assets/images/plane.png'),
                width: 100,
              ),
            ],
          ),
        ),
      ],
    );
  }
}