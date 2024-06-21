import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sounds/components/mydrawer.dart';
import 'package:sounds/model/song_provider.dart';
import 'package:sounds/pages/song_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SongProvider songProvider;

  @override
  void initState() {
    super.initState();
    songProvider = Provider.of<SongProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('P L A Y L I S T'),
      ),
      drawer: const Mydrawer(),
      body: SafeArea(
        child: Consumer<SongProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: value.playList.length,
              itemBuilder: (context, index) {
                final data = value.playList[index];
                return ListTile(
                  onTap: () {
                    songProvider.currentSongIndex = index;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SongPage(),
                      ),
                    );
                  },
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        data.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    data.songName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(data.artistName),
                  trailing: const Icon(Icons.more_vert),
                );
              },
            );
          },
        ),
      ),
    );
  }
}