import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_hamony/models/design.dart';
import '../../../models/auth_model.dart';
import '../../../services/database_service.dart';

class CardProjectScreen extends StatelessWidget {
  final Design design;

  const CardProjectScreen({
    Key? key, required this.design,
  }) : super(key: key);

  Future<UserModel?> getUserModelFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currentUser');
    if (jsonString != null) {
      final Map<String, dynamic> userMap = json.decode(jsonString);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<void> updateStatus(UserModel currentUser) async {
    Design updatedDesign = design.copyWith(status: 2);
    await DatabaseService().updateDesignInUser(currentUser.email ?? "", updatedDesign);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: getUserModelFromPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No user found'));
        } else {
          UserModel currentUser = snapshot.data!;
          print(" "
              "currentUser ${currentUser.role}");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        design.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  if (design.status == 1 && currentUser.role == 'designer')
                     Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () async =>{
                          updateStatus(currentUser)
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xfffbb448),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: const Text(
                            'Public',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      design.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      design.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}