part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel homeViewModel;

  // Controller untuk input berat barang
  final weightController = TextEditingController();

  // Daftar pilihan kurir yang tersedia
  final List<String> courierOptions = ["jne", "pos", "tiki", "lion", "sicepat"];
  String selectedCourier = "jne";

  // ID provinsi dan kota untuk lokasi asal dan tujuan
  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  int? selectedProvinceDestinationId;
  int? selectedCityDestinationId;

  @override
  void initState() {
    super.initState();
    // Inisialisasi ViewModel dan load data provinsi jika belum dimulai
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    if (homeViewModel.provinceList.status == Status.notStarted) {
      homeViewModel.getProvinceList();
    }
  }

  // Membersihkan TextEditingController ketika dihapus dari widget tree untuk mencegah memory leak
  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Card untuk form input data pengiriman
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Section pilihan kurir dan berat barang
                        Row(
                          children: [
                            // Dropdown pilihan kurir
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                // Membuat daftar item dropdown dari opsi kurir yang tersedia
                                items: courierOptions
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c.toUpperCase()),
                                        ))
                                    .toList(),
                                // Mengubah nilai selectedCourier saat user memilih opsi baru
                                onChanged: (v) => setState(
                                    () => selectedCourier = v ?? "jne"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Input berat barang dalam gram
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Berat (gr)'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Section Origin (Asal pengiriman)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Origin",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            // Dropdown provinsi asal
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.provinceList.status ==
                                      Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.black)),
                                    );
                                  }
                                  if (vm.provinceList.status == Status.error) {
                                    return Text(
                                        vm.provinceList.message ?? 'Error',
                                        style:
                                            const TextStyle(color: Colors.red));
                                  }

                                  final provinces = vm.provinceList.data ?? [];
                                  if (provinces.isEmpty) {
                                    return const Text('Tidak ada provinsi');
                                  }

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Pilih provinsi'),
                                    items: provinces
                                        .map((p) => DropdownMenuItem<int>(
                                            value: p.id, child: Text(p.name ?? '')))
                                        .toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId =
                                            null; // Reset kota saat provinsi berubah
                                      });
                                      if (newId != null) {
                                        vm.getCityOriginList(
                                            newId); // Load kota berdasarkan provinsi
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Dropdown kota asal
                            Expanded(
                              // `notifyListeners()` pada HomeViewModel memicu rebuild pada widget ini sehingga perlu menggunakan Consumer
                              child: Consumer<HomeViewModel>(
                                // Berisi objek yang merepresentasikan lokasi widget dalam widget tree untuk mengakses widget turunannya; Objek state/data sebagai instance dari HomeViewModel; Child widget opsional yang tidak bergantung pada ViewModel
                                builder: (context, vm, _) {
                                  if (vm.cityOriginList.status ==
                                      Status.notStarted) {
                                    return const Text('Pilih provinsi dulu',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey));
                                  }

                                  if (vm.cityOriginList.status ==
                                      Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.black)),
                                    );
                                  }

                                  if (vm.cityOriginList.status ==
                                      Status.error) {
                                    return Text(
                                        vm.cityOriginList.message ?? 'Error',
                                        style:
                                            const TextStyle(color: Colors.red));
                                  }

                                  if (vm.cityOriginList.status ==
                                      Status.completed) {
                                    final cities = vm.cityOriginList.data ?? [];

                                    if (cities.isEmpty) {
                                      return const Text('Tidak ada kota',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey));
                                    }

                                    // Validasi value yang dipilih masih ada di daftar kota
                                    final validIds = cities
                                        .map((c) => c.id)
                                        .toSet(); // Mengumpulkan semua cityId yang valid dari daftar kota
                                    final validValue =
                                        validIds.contains(selectedCityOriginId)
                                            ? selectedCityOriginId
                                            : null;

                                    return DropdownButton<int>(
                                      isExpanded: true,
                                      value: validValue,
                                      hint: const Text('Pilih kota'),
                                      items: cities
                                          .map((c) => DropdownMenuItem<int>(
                                                value: c.id,
                                                child: Text(c.name ?? ''),
                                              ))
                                          .toList(),
                                      onChanged: (newId) {
                                        setState(() {
                                          selectedCityOriginId = newId;
                                        });
                                      },
                                    );
                                  }

                                  // Jika tidak ada kondisi yang terpenuhi, kembalikan widget kosong
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Section Destination (Tujuan pengiriman)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Destination",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            // Dropdown provinsi tujuan
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.provinceList.status ==
                                      Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.black)),
                                    );
                                  }
                                  if (vm.provinceList.status == Status.error) {
                                    return Text(
                                        vm.provinceList.message ?? 'Error',
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12));
                                  }

                                  final provinces = vm.provinceList.data ?? [];
                                  if (provinces.isEmpty) {
                                    return const Text('Tidak ada provinsi');
                                  }

                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceDestinationId,
                                    hint: const Text('Pilih provinsi'),
                                    items: provinces
                                        .map((p) => DropdownMenuItem<int>(
                                            value: p.id, child: Text(p.name ?? '')))
                                        .toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceDestinationId = newId;
                                        selectedCityDestinationId =
                                            null; // Reset kota saat provinsi berubah
                                      });
                                      if (newId != null) {
                                        vm.getCityDestinationList(
                                            newId); // Load kota berdasarkan provinsi
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Dropdown kota tujuan
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  if (vm.cityDestinationList.status ==
                                      Status.notStarted) {
                                    return const Text('Pilih provinsi dulu',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey));
                                  }

                                  if (vm.cityDestinationList.status ==
                                      Status.loading) {
                                    return const SizedBox(
                                      height: 40,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.black)),
                                    );
                                  }

                                  if (vm.cityDestinationList.status ==
                                      Status.error) {
                                    return Text(
                                        vm.cityDestinationList.message ??
                                            'Error',
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12));
                                  }

                                  if (vm.cityDestinationList.status ==
                                      Status.completed) {
                                    final cities =
                                        vm.cityDestinationList.data ?? [];

                                    if (cities.isEmpty) {
                                      return const Text('Tidak ada kota',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey));
                                    }

                                    // Validasi value yang dipilih masih ada di list
                                    final validIds =
                                        cities.map((c) => c.id).toSet();
                                    final validValue = validIds
                                            .contains(selectedCityDestinationId)
                                        ? selectedCityDestinationId
                                        : null;

                                    return DropdownButton<int>(
                                      isExpanded: true,
                                      value: validValue,
                                      hint: const Text('Pilih kota'),
                                      items: cities
                                          .map((c) => DropdownMenuItem<int>(
                                                value: c.id,
                                                child: Text(c.name ?? ''),
                                              ))
                                          .toList(),
                                      onChanged: (newId) {
                                        setState(() {
                                          selectedCityDestinationId = newId;
                                        });
                                      },
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Tombol untuk menghitung ongkir
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validasi semua field sudah terisi
                              if (selectedCityOriginId != null &&
                                  selectedCityDestinationId != null &&
                                  weightController.text.isNotEmpty &&
                                  selectedCourier.isNotEmpty) {
                                final weight =
                                    int.tryParse(weightController.text) ?? 0;
                                // Validasi berat harus lebih dari 0
                                if (weight <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Berat harus lebih dari 0'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }
                                // Panggil API untuk cek ongkir
                                homeViewModel.checkShipmentCost(
                                  selectedCityOriginId!.toString(),
                                  "city",
                                  selectedCityDestinationId!.toString(),
                                  "city",
                                  weight,
                                  selectedCourier,
                                );
                              } else {
                                // Tampilkan pesan error jika ada field yang kosong
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lengkapi semua field!'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(16)),
                            child: const Text("Hitung Ongkir",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Card untuk menampilkan hasil ongkir
                Card(
                  color: Colors.blue[50],
                  elevation: 2,
                  child: Consumer<HomeViewModel>(
                    builder: (context, vm, _) {
                      // Tampilkan hasil sesuai status dari API
                      switch (vm.costList.status) {
                        case Status.loading:
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.black)),
                          );
                        case Status.error:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(vm.costList.message ?? 'Error',
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          );
                        case Status.completed:
                          if (vm.costList.data == null ||
                              vm.costList.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child:
                                  Center(child: Text("Tidak ada data ongkir.")),
                            );
                          }
                          // Tampilkan list ongkir dalam bentuk card
                          return ListView.builder(
                            shrinkWrap:
                                true, // Membuat ListView hanya sebesar kontennya
                            physics:
                                const NeverScrollableScrollPhysics(), // Nonaktifkan scroll pada ListView agar mengikuti scroll parent
                            itemCount: vm.costList.data?.length ??
                                0, // Jumlah item berdasarkan data ongkir
                            itemBuilder: (context, index) => CardCost(
                                vm.costList.data!.elementAt(
                                    index)), // Gunakan CardCost untuk setiap item
                          );
                        default:
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: Text(
                                    "Pilih kota dan klik Hitung Ongkir terlebih dulu.",
                                    style: TextStyle(color: Colors.black))),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Overlay loading untuk proses background
          Consumer<HomeViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Container(
                  color: Colors.black,
                  child: const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
