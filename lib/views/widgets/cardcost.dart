part of 'widgets.dart';

class CardCosts extends StatefulWidget {
  final Costs costs;
  // final Cost detail;
  const CardCosts(this.costs);

  @override
  State<CardCosts> createState() => _CardCostsState();
}

class _CardCostsState extends State<CardCosts> {
  @override
  Widget build(BuildContext context) {
    Costs cost = widget.costs;
    // Cost d = widget.detail;
    return Card(
      color: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/morales.jpg'),
        ),
        title:
            // for(var j in cost ?? [])
            Text(
          "${cost.description} (${cost.service})",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i in cost.cost ?? [])
              Text(
                "Biaya: Rp.${i.value},00",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            for (var i in cost.cost ?? [])
              Text(
                "Estimasi Sampai: ${i.etd} Hari",
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}