import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';

class HomeHeaderWidget extends StatefulWidget {
  const HomeHeaderWidget({super.key});

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return  IntrinsicHeight(
        child: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .center,
                      mainAxisSize: .min,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: .start,
                            crossAxisAlignment: .start,
                            mainAxisSize: .min,
                            spacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment: .start,
                                crossAxisAlignment: .start,
                                mainAxisSize: .min,
                                children: [
                                  Text(
                                    'Nifty Bank',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ).expand(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: .start,
                                crossAxisAlignment: .start,
                                mainAxisSize: .min,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                      children: const <TextSpan>[
                                        TextSpan(text: '54,445 '),
                                        TextSpan(
                                          text: '15.6 (13.524)',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ), // Specific style for 'bold'
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ).expand(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // CHANGE THIS PART:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: const VerticalDivider(
                color: Colors.grey,
                thickness: 2,
                width: 10, // The total width the divider widget occupies
                indent: 3, // Empty space at the top
                endIndent: 3, // Empty space at the bottom
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .center,
                      mainAxisSize: .min,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: .start,
                            crossAxisAlignment: .start,
                            mainAxisSize: .min,
                            spacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment: .start,
                                crossAxisAlignment: .start,
                                mainAxisSize: .min,
                                children: [
                                  Text(
                                    'Nifty Bank',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ).expand(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: .start,
                                crossAxisAlignment: .start,
                                mainAxisSize: .min,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                      children: const <TextSpan>[
                                        TextSpan(text: '54,445 '),
                                        TextSpan(
                                          text: '-15.6 (-0.524)',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ), // Specific style for 'bold'
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ).expand(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
