import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_models/auth_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Build Your',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    const Row(children: [
                      Text(
                        'Future.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Color.fromARGB(255, 110, 59, 228)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Build ',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      )
                    ]),
                    const Row(children: [
                      Text(
                        'Your',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Dream',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Color.fromARGB(255, 110, 59, 228),
                        ),
                      )
                    ]),
                    Row(children: [
                      InkWell(
                        onTap: () {
                          if(authViewModel.isLoggedIn.value){
                            Navigator.pushNamed(context, '/main');
                          } else{
                            Navigator.pushNamed(context, '/register');
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black26),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: const Center(child: Text('Register')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          if(authViewModel.isLoggedIn.value){
                            Navigator.pushNamed(context, '/main');
                          } else{
                            Navigator.pushNamed(context, '/login');
                          }

                        },
                        child: Container(
                          height: 55,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 110, 59, 228),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: const Center(
                              child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 100,
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/main');
                  },
                  child: Container(
                    height: 55,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 110, 59, 228),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          bottomLeft: Radius.circular(45)),
                    ),
                    child: const Center(
                        child: Text(
                      'Browse Jobs',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
