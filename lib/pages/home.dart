import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir/models/article_model.dart';
import 'package:proyek_akhir/pages/all_news.dart';
import 'package:proyek_akhir/pages/article_view.dart';
import 'package:proyek_akhir/pages/category_news.dart';
import 'package:proyek_akhir/services/data.dart';
import 'package:proyek_akhir/services/news.dart';
import 'package:proyek_akhir/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/models/category_model.dart';
import '/models/slider_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<SliderrModel> sliders = [];
  List<ArticleModel> articles = [];
  int activeIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    categories = getCategories();
    getSliderr();
    getNewsData();
    super.initState();
  }

  getNewsData() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }

  getSliderr() async {
    Sliderr sliderrclass = Sliderr();
    await sliderrclass.getSliderr();
    sliders = sliderrclass.sliderr;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Veteran"),
            Text(
              "Post",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
            )
          ],
        ),
        elevation: 0.0,
      ),
      body: _loading? Center(child: CircularProgressIndicator()) :
      SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 70,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              image: categories[index].image,
                              categoryName: categories[index].categoryName,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Breaking News",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.5),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: "Breaking")));
                            },
                            child: Text(
                              "View all",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.deepOrangeAccent,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.deepOrangeAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CarouselSlider.builder(
                      itemCount: 7,
                      itemBuilder: (context, index, realIndex) {
                        String? linkgambar = sliders[index].urlToImage;
                        String? judul = sliders[index].title;
                        return buildImage(linkgambar!, index, judul!);
                      },
                      options: CarouselOptions(
                          height: 200,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(child: buildIndicator()),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending News",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.5),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AllNews(news: "Trending")));
                            },
                            child: Text(
                              "View all",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.deepOrangeAccent,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.deepOrangeAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return BlogTile(
                              url: articles[index].url!,
                                desc: articles[index].description!,
                                title: articles[index].title!,
                                imageUrl: articles[index].urlToImage!);
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImage(String image, int index, String title) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleView(blogUrl: sliders[index].url!),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: 200,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              imageUrl: image,
            ),
          ),
          Container(
            height: 250,
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(top: 144),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );


  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 7,
        effect: ScrollingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: Colors.deepOrangeAccent),
      );
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;

  CategoryTile({this.image, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(image,
                    width: 120, height: 70, fit: BoxFit.cover)),
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.black38, borderRadius: BorderRadius.circular(6)),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imageUrl, title, desc, url;

  BlogTile({required this.desc, required this.title, required this.imageUrl, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Text(
                            desc,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
