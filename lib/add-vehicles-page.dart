import 'package:flutter/material.dart';
import 'api.dart';

class AddVehiclesPage extends StatefulWidget {
	const AddVehiclesPage({ super.key });

	final String title = 'Add Vehicles';

	@override
	State<AddVehiclesPage> createState() => _AddVehiclesPageState();
}

class _AddVehiclesPageState extends State<AddVehiclesPage> {
	List<Vehicle> _vehicles = [];

	void _onVehicleDeletePressed(int index) {
		setState(() {
			_vehicles.removeAt(index);
		});
	}

	void _onNewVehiclePressed() {
		Navigator.pushNamed(context, '/new').then((result) {
			if (result != null) {
				setState(() {
					_vehicles.add(result as Vehicle);
				});
			}
		});
	}

	void _onClearPressed() {
		setState(() {
			_vehicles.clear();
		});
	}

	void _onComparePressed() {
		Navigator.pushNamed(context, '/comparison', arguments: _vehicles);
	}

	@override
	Widget build(BuildContext context) {
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
							child: ListView.builder(
								itemCount: _vehicles.length,
								itemBuilder: (_, int index) {
									final vehicle = _vehicles[index];

									return ListTile(
										leading: Image.network(
											'${vehicle.photo}',
											width: 64,
											fit: BoxFit.contain
										),
										title: Text('${vehicle.year} ${vehicle.make} ${vehicle.model}'),
										trailing: IconButton(
											icon: const Icon(Icons.delete),
											onPressed: () { _onVehicleDeletePressed(index); }
										)
									);
								}
							)
						),
						Padding(
							padding: EdgeInsets.all(16.0),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									FilledButton(
										child: const Text('New Vehicle'),
										onPressed: _onNewVehiclePressed
									),
									SizedBox(width: 16.0),
									FilledButton(
										child: const Text('Clear'),
										onPressed: _vehicles.length > 0 ? _onClearPressed : null
									),
									SizedBox(width: 16.0),
									FilledButton(
										child: const Text('Compare'),
										onPressed: _vehicles.length > 0 ? _onComparePressed : null
									)
								]
							)
						)
					]
				)
			)
		);
	}
}
