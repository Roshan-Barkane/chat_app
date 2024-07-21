import 'package:flutter/cupertino.dart';

import '../models/massage.dart';

class MassageCard extends StatefulWidget {
  const MassageCard({super.key, required this.message});
  final Massage message;

  @override
  State<MassageCard> createState() => _MassageCardState();
}

class _MassageCardState extends State<MassageCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // Sender or another user massage
  Widget _blueMessage() {
    return Container();
  }

  // our or user massage
  Widget _greenMessage() {
    return Container();
  }
}
