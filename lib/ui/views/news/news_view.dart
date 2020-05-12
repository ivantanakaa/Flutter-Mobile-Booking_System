import 'package:flutter/material.dart';
import 'package:member_apps/base_widget.dart';
import 'package:member_apps/core/viewmodels/views/news/news_view_model.dart';
import 'package:member_apps/service_locator.dart';
import 'package:member_apps/ui/shared_colors.dart';
import 'package:member_apps/ui/views/news/widgets/news_container.dart';

class NewsView extends StatefulWidget {
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: SharedColors.scaffoldColor,
          title: Text(
            "News",
          )),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BaseWidget<NewsViewModel>(
      onModelReady: (NewsViewModel viewModel) async {
        await viewModel.loadNews();
      },
      model: locator<NewsViewModel>(),
      builder:
          (BuildContext context, NewsViewModel viewModel, Widget child) {
        return Container(
          child: ListView.builder(
            itemCount: viewModel.news.length,
            itemBuilder: (BuildContext context, int itemCount) {
              return NewsContainer(
                newsModel: viewModel.news[itemCount],
              );
            },
          ),
        );
      },
    );
  }
}
