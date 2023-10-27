import '../../helpers/import_helper.dart';

class LeaderboardItem extends StatelessWidget {
  final String username;
  final int totalScore;
  final int position;

  const LeaderboardItem({
    required this.username,
    required this.totalScore,
    required this.position,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (position == 1) {
      backgroundColor = ColorHelper.firstPlaceColor;
    } else if (position == 2) {
      backgroundColor = ColorHelper.primaryColor;
    } else if (position == 3) {
      backgroundColor = ColorHelper.thirdPlaceColor;
    } else {
      backgroundColor = ColorHelper.secondaryColor;
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$position',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$totalScore',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
