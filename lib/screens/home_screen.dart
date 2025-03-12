import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and determine device type
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final bool isDesktop = screenSize.width > 1200;

    // Responsive values
    final double horizontalPadding = isDesktop ? 80 : (isTablet ? 40 : 20);
    final double verticalSpacing = isDesktop ? 40 : (isTablet ? 30 : 24);

    // Responsive text sizes
    final double headerFontSize = isDesktop ? 22 : (isTablet ? 20 : 18);
    final double subHeaderFontSize = isDesktop ? 18 : (isTablet ? 16 : 14);
    final double routineTitleFontSize = isDesktop ? 24 : (isTablet ? 22 : 20);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF005DC8),
                  Color(0xFF004AAE),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalSpacing,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 800 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top margin
                          SizedBox(height: verticalSpacing),
                          
                          // Header with user info and notification
                          Row(
                            children: [
                              CircleAvatar(
                                radius: isDesktop ? 35 : (isTablet ? 30 : 25),
                                backgroundImage:
                                    const AssetImage('assets/profile.jpg'),
                              ),
                              SizedBox(width: horizontalPadding * 0.2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nice to see you again,',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: subHeaderFontSize,
                                      ),
                                    ),
                                    Text(
                                      'John Marcus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size:
                                      isDesktop ? 35 : (isTablet ? 30 : 25),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: verticalSpacing),

                          // Today's routine card
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            padding: EdgeInsets.all(horizontalPadding * 0.5),
                            child: Column(
                              children: [
                                Text(
                                  "Today's routine",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: routineTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: verticalSpacing),
                                Container(
                                  width: double.infinity,
                                  height: screenSize.height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(height: verticalSpacing * 0.8),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.5,
                                      vertical: verticalSpacing * 0.3,
                                    ),
                                  ),
                                  child: Text(
                                    'Start',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: subHeaderFontSize,
                                    ),
                                  ),
                                ),
                                SizedBox(height: verticalSpacing * 0.5),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF003366),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: verticalSpacing * 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      'My workouts',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: subHeaderFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Weekly schedule section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            padding: EdgeInsets.all(horizontalPadding * 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Weekly schedule header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Weekly schedule',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: headerFontSize,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'October 10-16',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: subHeaderFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Just 1 workout more !',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: subHeaderFontSize * 0.8,
                                          ),
                                        ),
                                        SizedBox(
                                            width: horizontalPadding * 0.2),
                                        Container(
                                          width: isDesktop
                                              ? 50
                                              : (isTablet ? 45 : 40),
                                          height: isDesktop
                                              ? 50
                                              : (isTablet ? 45 : 40),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: 0.75,
                                                backgroundColor:
                                                    Colors.white24,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFF7BA69A),
                                                ),
                                                strokeWidth: 4,
                                              ),
                                              Text(
                                                '3/4',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      subHeaderFontSize * 0.8,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: verticalSpacing),

                                // Day cards
                                // Use spaceEvenly so cards don't get too small.
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(7, (i) {
                                    // Fixed width for day cards to avoid shrinking
                                    final double cardWidth = isDesktop
                                        ? 60
                                        : (isTablet ? 55 : 50);

                                    return Container(
                                      width: cardWidth,
                                      padding: EdgeInsets.all(
                                        horizontalPadding * 0.1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: i == 3
                                            ? const Color(0xFF003366)
                                            : Colors.white.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${10 + i}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: subHeaderFontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            [
                                              'Mon',
                                              'Tue',
                                              'Wed',
                                              'Thu',
                                              'Fri',
                                              'Sat',
                                              'Sun'
                                            ][i],
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize:
                                                  subHeaderFontSize * 0.8,
                                            ),
                                          ),
                                          if (i < 3)
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 4),
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF7BA69A),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: verticalSpacing),

                          // Health Care section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            padding: EdgeInsets.all(horizontalPadding * 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Health Care',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: verticalSpacing * 0.8),
                                Row(
                                  children: [
                                    // Day Activity Container
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding * 0.2,
                                        vertical: verticalSpacing * 0.4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF003366),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Day Activity',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: subHeaderFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: verticalSpacing * 0.2),
                                          Icon(
                                            Icons.fitness_center,
                                            color: Colors.white,
                                            size: isDesktop
                                                ? 35
                                                : (isTablet ? 30 : 25),
                                          ),
                                          SizedBox(height: verticalSpacing * 0.2),
                                          Text(
                                            '450',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: headerFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'kcal',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: subHeaderFontSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: horizontalPadding * 0.3),
                                    // Sleep Time Section
                                    Expanded(
                                      child: Container(
                                        // Increased padding for Sleep Time card
                                        padding: EdgeInsets.symmetric(
                                          horizontal: horizontalPadding * 0.4,
                                          vertical: verticalSpacing * 0.4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Sleep Time',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: headerFontSize,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        horizontalPadding *
                                                            0.1,
                                                    vertical: verticalSpacing *
                                                        0.1,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                            0xFF7BA69A)
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    '7:30h',
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xFF7BA69A),
                                                      fontSize:
                                                          subHeaderFontSize,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: verticalSpacing * 0.2),
                                            Text(
                                              "You're awesome!",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: subHeaderFontSize,
                                              ),
                                            ),
                                            SizedBox(height: verticalSpacing * 0.3),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: 0.9,
                                                backgroundColor:
                                                    Colors.white24,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFF7BA69A),
                                                ),
                                                minHeight:
                                                    verticalSpacing * 0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
