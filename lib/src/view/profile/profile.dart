import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/global/user-data.dart';
import 'package:long_covid_android_ios_pigeons_garmin_connectiq/src/view/profile/edit-profile-screen.dart';

import '../../common/collor.dart';
import '../../common/setting.dart';
import '../../common/title.dart';

import '../login/rouind_button.dart';

import 'package:http/http.dart' as http;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isLoading = true;
  String? firstName;
  String? lastName;
  String? gender;
  DateTime? dateOfBirth;
  String? height;
  String? weight;
  String? profileImageUrl;


  bool positive = false;

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/img/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/img/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData(UserData().username);
  }

  Future<void> fetchUserData(String? username) async {
    String uri = UserData().hostname;
    var url = Uri.parse('$uri/api/user?username=$username');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserData().token}',
        }
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          firstName = data['firstName'];
          lastName = data['lastName'];
          gender = data['gender'];
          dateOfBirth = DateTime.parse(data['dateOfBirth']);
          height = data['height'].toString();
          weight = data['weight'].toString();
          profileImageUrl = gender == "Female" ? "assets/img/female_profile.png" : "assets/img/male_profile.png";
          isLoading = false;
        });
      } else {
        print(response.body);
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate age based on the date of birth
    int age = calculateAge(dateOfBirth!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Image.asset("assets/img/more_btn.png", width: 15, height: 15, fit: BoxFit.contain),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      profileImageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$firstName $lastName",  // Assume these are non-null or handled elsewhere
                          style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(firstName: firstName, lastName: lastName, initialHeight: height, initialWeight: weight, initialDateOfBirth: dateOfBirth)));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${height ?? 'N/A'} cm",  // Check for null, provide a default if necessary
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${weight ?? 'N/A'} kg",  // Check for null, provide a default if necessary
                      subtitle: "Weight",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "$age yo",
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}