import 'package:flutter/material.dart';
import 'api.dart';

class CompareVehiclesPage extends StatefulWidget {
	const CompareVehiclesPage({ super.key });

	final String title = 'Compare Vehicles';

	@override
	State<CompareVehiclesPage> createState() => _CompareVehiclesPageState();
}

class _CompareVehiclesPageState extends State<CompareVehiclesPage> {
	void _onDonePressed() {
		Navigator.pop(context);
	}

	List<DataRow> _buildVehicleDataRows(List<Vehicle> vehicles) {
		return vehicles.map((vehicle) => DataRow(
			cells: <DataCell>[
				DataCell(Image.network(
					'${vehicle.photo}',
					width: 64,
					fit: BoxFit.contain
				)),
				DataCell(Text('${vehicle.year} ${vehicle.make} ${vehicle.model}')),
				DataCell(Text(vehicle.vehicleClass)),
				DataCell(Text(vehicle.cityMPG)),
				DataCell(Text(vehicle.highwayMPG)),
				DataCell(Text(vehicle.combinedMPG)),
				DataCell(Text(vehicle.fuelType))
			]
		)).toList();
	}

	@override
	Widget build(BuildContext context) {
		final vehicles = ModalRoute.of(context)!.settings.arguments as List<Vehicle>;

		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				centerTitle: true,
				title: Text(widget.title),
			),
			body: Center(
				child: Column(
					children: <Widget>[
						Expanded(
							child: ListView(
								scrollDirection: Axis.horizontal,
								padding: const EdgeInsets.all(16.0),
								children: <Widget>[
									DataTable(
										columnSpacing: 16.0,
										columns: <DataColumn>[
											DataColumn(
												label: Text('')
											),
											DataColumn(
												label: Text('Vehicle')
											),
											DataColumn(
												label: Text('Type')
											),
											DataColumn(
												label: Text('City MPG')
											),
											DataColumn(
												label: Text('Highway MPG')
											),
											DataColumn(
												label: Text('Combined MPG')
											),
											DataColumn(
												label: Text('Fuel Type')
											),
										],
										rows: _buildVehicleDataRows(vehicles)
									)
								]
							)
						),
						Padding(
							padding: EdgeInsets.all(16.0),
							child: FilledButton(
								child: const Text('Done'),
								onPressed: _onDonePressed
							)
						)
					]
				)
			)
		);
	}
}
