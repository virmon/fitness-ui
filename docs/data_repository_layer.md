# Creating a Data Repository

### Main objectives of Data Repository Layer:
1. Send request to external API
2. Receive response from external API
3. Manage serialization/deserialization

The main objective of the Data Repository is to serve as an entry/exit point of data in the app. Anything that is coming from an external source such as a REST API or a third-party API should be handled in this layer.
Additionally, data serialization/deserialization should also be handled here. Convert JSON into an Object before accessing the data in the UI; and convert Object into JSON body before sending a request body to the external sources.

### Requirements
1. a [Data Model](./domain_layer.md) for serializing/deserializing data
2. API endpoint

### How to create a data repository
1. Create a Repository Class
2. Create a Provider

### Example:

### 1. Creating a Repository Class:
### routines/data/routines_repository.dart
```dart
// 1. create a repository class
class RoutinesRepository {
	RoutinesRepository(this.ref);
	Ref ref;

	Future<List<Routine?>> getRoutines() async {
		// access the client API provider
		final client = ref.read(dioProvider);

		// fetch data with GET method
      	final response = await client.get('/api/routines/me');
      	
	  	// data serialization from JSON to Routine Data Model
		final fetchedData = response.data as List;
      	List<Routine>? routines = List<Routine>.from(
          fetchedData.map((routine) => Routine.fromJson(routine)));
		
      	return Future.value(routines);
	}
}
```

### 2. Creating a Provider:

### routines/data/routines_repository.dart
```dart
// In the same file under the class RoutinesRepository

class RoutinesRepository {...}

// create a provider
final routinesRepositoryProvider = Provider<RoutinesRepository>((ref) {
	// return the class constructor and pass the ref as a parameter
  	return RoutinesRepository(ref);
});

// you can create another provider for your specific need (fetch routines)
final routinesListFutureProvider =
    FutureProvider.autoDispose<List<Routine?>>((ref) {
		// example usage of routinesRepositoryProvider
		final routinesRepository = ref.read(routinesRepositoryProvider);
		// access method in RoutinesRepository class
		return routinesRepository.getRoutines();
});

```

## Accessing the providers
In order to access the providers, you will need to have access to `Ref`. Depending on your scenario, you can access the providers with: 
- `ref.read(routinesRepositoryProvider)` - in most cases `read` will do
- `ref.watch(routinesRepositoryProvider)` - used when you are watching a stream of data
- `ref.listen(routinesStateNotifier.notifier)` - used when listening to state changes

## Accessing the providers in the UI Widgets
There are multiple ways to access the provider inside the `Widget`. 
1. extending your Widget to `ConsumerWidget` or `ConsumerStatefulWidget`.
	- If your Widget is `StatelessWidget` extend to `ConsumerWidget`
	- If your Widget is `StatefulWidget` extend to `ConsumerStatefulWidget`
2. Another way is to wrap your widget in a `Consumer` widget

See `ConsumerWidget` example below:

```dart
// extending ConsumerWidget
class RoutinesList extends ConsumerWidget {
  const RoutinesList({super.key});

  @override
  // add WidgetRef argument on the build method
  Widget build(BuildContext context, WidgetRef ref) {
	// access the repository provider and return data as AsyncValue
    AsyncValue<List<Routine?>> routines = ref.read(routinesListFutureProvider);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
			// you can use this common widget for handling AsyncValue data
			AsyncValueWidget(
				// pass the AsyncValue data returned
                value: routines,
				// pass your custom Widget here to display the data
                data: (data) => ListSectionItem(items: data),
              ),
            ],
          ),
        )
      ],
    );
  }
}
```