import 'package:flutter/material.dart';
import 'package:flutter_toonflix/models/webtoon_detail_model.dart';
import 'package:flutter_toonflix/models/webtoon_epsode_model.dart';
import 'package:flutter_toonflix/services/api_service.dart';
import 'package:flutter_toonflix/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String thumb;
  final String id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoonDetail;
  late Future<List<WebtoonEpisodeModel>> webtoonEpsodes;
  late SharedPreferences prefs;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    webtoonDetail = ApiService.getToonDetail(widget.id);
    webtoonEpsodes = ApiService.getToonEpisodes(widget.id);

    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    final favoriteToons = prefs.getStringList('favoriteToons');
    if (favoriteToons != null) {
      if (favoriteToons.contains(widget.id)) {
        setState(() {
          isFavorite = true;
        });
      }
    } else {
      await prefs.setStringList('favoriteToons', []);
    }
  }

  void onFavoriteTap() async {
    final favoriteToons = prefs.getStringList('favoriteToons');
    if (favoriteToons != null) {
      if (isFavorite) {
        favoriteToons.remove(widget.id);
      } else {
        favoriteToons.add(widget.id);
      }
      await prefs.setStringList('favoriteToons', favoriteToons);
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 30,
              ),
            ),
          ],
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.id,
                      child: Container(
                        width: 250,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              offset: const Offset(10, 10),
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Image.network(widget.thumb),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder(
                  future: webtoonDetail,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.about,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                              "${snapshot.data!.genre} / ${snapshot.data!.age}",
                              style: const TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      );
                    }
                    return const Text("...");
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder(
                  future: webtoonEpsodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (var epsode in snapshot.data!)
                            Episode(
                              epsode: epsode,
                              webtoonId: widget.id,
                            ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
