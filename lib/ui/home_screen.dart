import 'package:fify/blocs/genre_bloc.dart';
import 'package:fify/blocs/movies_bloc.dart';
import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/services/search.dart';
import 'package:fify/ui/colors.dart';
import 'package:fify/ui/movie_detail.dart';
import 'package:fify/ui/search_detail.dart';
import 'package:fify/ui/see_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

final _typeAheadController = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: bgColor,
        child: const PreloadContent(),
      ),
    );
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  void clear() {
    _typeAheadController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Text(
                  'Search',
                  style: TextStyle(
                    fontFamily: 'SubstanceMedium',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                TypeAheadField(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      style: TextStyle(color: textColor, fontSize: 28),
                      decoration: InputDecoration.collapsed(
                        hintText: "Movies...",
                        hintStyle: TextStyle(color: textColor, fontSize: 28),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    if (pattern.isEmpty) {
                      // Girdi boşsa hiçbir öneri döndürme
                      return [];
                    }
                    // Girdi doluyken API'den önerileri getir
                    return await BackendService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    if (suggestion.results.isEmpty) {
                      return const SizedBox
                          .shrink(); // Öneri yoksa boş bir widget döndür
                    }
                    // suggestion.results listesini göstermek için döngü kullanıyoruz
                    return ListView.builder(
                      itemCount: suggestion.results
                          .length, // Sonuç sayısına göre döngü başlatıyoruz
                      itemBuilder: (context, index) {
                        final movie = suggestion.results[index];
                        return ListTile(
                          tileColor: textColor,
                          selectedTileColor: textColor,
                          leading: movie.posterPath.isNotEmpty
                              ? Image.network(movie.posterPath)
                              : Image.network(
                                  "https://www.subscription.co.uk/time/europe/Solo/Content/Images/noCover.gif"),
                          title: Text(
                            movie.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Release date : " + movie.releaseDate,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    );
                  },
                  onSelected: (suggestion) {
                    clear();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchDetail(product: suggestion),
                    ));
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 0.5,
                  color: textColor,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeAll(
                                  title: 'Popular Movies',
                                  movieStream: bloc.allMovies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const PopularMovies(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        child: const Text(
                          'Top Rated',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeAll(
                                  title: 'Top Rated Movies',
                                  movieStream: bloc.allTopRatedMovies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const TopRatedMovies(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        child: Text(
                          'Recent',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeAll(
                                  title: 'Recent Movies',
                                  movieStream: bloc.allNowPlayingMovies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const RecentMovies(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        child: Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeeAll(
                                  title: 'Upcoming Movies',
                                  movieStream: bloc.allUpcomingMovies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const UpcomingMovies(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PreloadContent extends StatefulWidget {
  const PreloadContent({super.key});

  @override
  State<PreloadContent> createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  @override
  Widget build(BuildContext context) {
    bloc_genres.fetchAllGenres();
    return StreamBuilder(
      stream: bloc_genres.allGenres,
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
        if (snapshot.hasData) {
          return const ContentPage();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ItemsLoad extends StatefulWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  const ItemsLoad(this.snapshot, {Key? key}) : super(key: key);

  @override
  _ItemsLoadState createState() => _ItemsLoadState();
}

class _ItemsLoadState extends State<ItemsLoad> {
  @override
  Widget build(BuildContext context) {
    final sortedMovies = widget.snapshot.data?.results;
    sortedMovies?.sort((a, b) => b.popularity.compareTo(a.popularity));
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, int index) {
        final movie = sortedMovies?[index];
        if (movie == null) {
          return const SizedBox.shrink();
        }
        return Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetail(
                      widget.snapshot.data!.results[index],
                    ),
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 300.0,
                  minWidth: MediaQuery.of(context).size.width * 0.40,
                  maxHeight: 300.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(movie.posterPath),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1, // Başlık en fazla bir satırda gösterilir
                      overflow: TextOverflow
                          .ellipsis, // Fazla metni "..." ile kısaltır
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        );
      },
    );
  }
}

class PopularMovies extends StatefulWidget {
  const PopularMovies({Key? key}) : super(key: key);

  @override
  _PopularMoviesState createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: 300,
            child: ItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class RecentMovies extends StatefulWidget {
  const RecentMovies({Key? key}) : super(key: key);

  @override
  _RecentMoviesState createState() => _RecentMoviesState();
}

class _RecentMoviesState extends State<RecentMovies> {
  bool isRecent = true; // Burada 'isRecent' değişkeni tanımlandı

  @override
  void initState() {
    super.initState();
    if (isRecent) {
      bloc.fetchAllNowPlayingMovies(); // Recent filmleri getirecek
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allNowPlayingMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: 300,
            child: ItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class UpcomingMovies extends StatefulWidget {
  const UpcomingMovies({Key? key}) : super(key: key);

  @override
  _UpcomingMoviesState createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
  void initState() {
    super.initState();
    bloc.fetchAllUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allUpcomingMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: 300,
            child: ItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({super.key});

  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  void initState() {
    super.initState();
    bloc.fetchAllTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allTopRatedMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: 300,
            child: ItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
