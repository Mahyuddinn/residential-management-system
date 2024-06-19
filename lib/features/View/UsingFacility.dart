import 'package:flutter/material.dart';
import 'package:residential_management_system/features/model/UseFacility.dart';

class UsingFacilityPage extends StatefulWidget {
  final UseFacility facilityUsage;

  const UsingFacilityPage({
    Key? key,
    required this.facilityUsage,
  }) : super(key: key);

  @override
  State<UsingFacilityPage> createState() => _UsingFacilityPageState();
}

class _UsingFacilityPageState extends State<UsingFacilityPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}