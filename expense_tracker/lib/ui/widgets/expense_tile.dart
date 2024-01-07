import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
              width: 352,
              height: 68,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 352,
                      height: 68,
                      decoration: const BoxDecoration(color: Color(0xFF424242)),
                    ),
                  ),
                  const Positioned(
                    left: 244.44,
                    top: 38,
                    child: SizedBox(
                      width: 75.29,
                      height: 24,
                      child: Text(
                        '-100',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFFEF5350),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 27.38,
                    top: 38,
                    child: Container(
                      width: 217.07,
                      height: 24,
                      child: Stack(
                        children: [
                          const Positioned(
                            left: 5.34,
                            top: 4,
                            child: SizedBox(
                              width: 211.73,
                              child: Text(
                                'Notes',
                                style: TextStyle(
                                  color: Color(0xFFECEFF1),
                                  fontSize: 8,
                                  fontFamily: 'Lekton',
                                  fontWeight: FontWeight.w400,
                                  height: 0.31,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 217.07,
                              height: 24,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 0.50, color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 27.38,
                    top: 25,
                    child: Container(
                      width: 100.71,
                      height: 8,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 79.20,
                            top: 0,
                            child: Container(
                              width: 21.51,
                              height: 8,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    left: 5.87,
                                    top: 0,
                                    child: SizedBox(
                                      width: 15.64,
                                      height: 8,
                                      child: Text(
                                        'tag 4 ',
                                        style: TextStyle(
                                          color: Color(0xFFB0BEC5),
                                          fontSize: 6,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 1,
                                    child: Container(
                                      width: 5.87,
                                      height: 6,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 5.87,
                                              height: 6,
                                              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 52.80,
                            top: 0,
                            child: Container(
                              width: 21.51,
                              height: 8,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    left: 5.87,
                                    top: 0,
                                    child: SizedBox(
                                      width: 15.64,
                                      height: 8,
                                      child: Text(
                                        'tag 3 ',
                                        style: TextStyle(
                                          color: Color(0xFFB0BEC5),
                                          fontSize: 6,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 1,
                                    child: Container(
                                      width: 5.87,
                                      height: 6,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 5.87,
                                              height: 6,
                                              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 26.40,
                            top: 0,
                            child: Container(
                              width: 21.51,
                              height: 8,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    left: 5.87,
                                    top: 0,
                                    child: SizedBox(
                                      width: 15.64,
                                      height: 8,
                                      child: Text(
                                        'tag 2',
                                        style: TextStyle(
                                          color: Color(0xFFB0BEC5),
                                          fontSize: 6,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 1,
                                    child: Container(
                                      width: 5.87,
                                      height: 6,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 5.87,
                                              height: 6,
                                              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 21.51,
                              height: 8,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    left: 5.87,
                                    top: 0,
                                    child: SizedBox(
                                      width: 15.64,
                                      height: 8,
                                      child: Text(
                                        'tag 1',
                                        style: TextStyle(
                                          color: Color(0xFFB0BEC5),
                                          fontSize: 6,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 1,
                                    child: Container(
                                      width: 5.87,
                                      height: 6,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 5.87,
                                              height: 6,
                                              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 197.51,
                    top: 7,
                    child: Container(
                      width: 123.20,
                      height: 18,
                      child: Stack(
                        children: [
                          const Positioned(
                            left: 0,
                            top: 0,
                            child: SizedBox(
                              width: 108.53,
                              height: 18,
                              child: Text(
                                'Category',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 111.47,
                            top: 1,
                            child: Container(
                              width: 11.73,
                              height: 12,
                              padding: const EdgeInsets.only(top: 2, left: 0.98, right: 0.98),
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 27.38,
                    top: 8,
                    child: SizedBox(
                      width: 148.62,
                      height: 18,
                      child: Text(
                        'Expense Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        )
      ],
    );
  }
}