import 'package:flutter/material.dart';
import 'package:moviebookingapp/models/movie.dart';

import '../../../app_colors.dart';

class AddMovieWidget extends StatefulWidget {

  final Function callback;
  final List<String> genres;
  final Movie? movie;

  const AddMovieWidget({super.key, required this.callback, required this.genres, this.movie});

  @override
  State<AddMovieWidget> createState() => _AddMovieWidgetState();
}

class _AddMovieWidgetState extends State<AddMovieWidget> {
  TextEditingController idMovieController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController directorController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  TextEditingController urlMovieController = TextEditingController();

  List<String> selectedGenres = [];

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.movie != null) {
      isEdit = true;
      idMovieController.text = widget.movie!.id;
      titleController.text = widget.movie!.title;
      directorController.text = widget.movie!.Director;
      desController.text = widget.movie!.description;
      imgController.text = widget.movie!.imageUrl;
      urlMovieController.text = widget.movie!.videoUrl;
      selectedGenres.addAll(widget.movie!.genres);
    }
  }


  void _onGenreClick(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.admin_color1,
      padding: EdgeInsets.symmetric(horizontal: 20),
      // height: MediaQuery.of(context).size.height / 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                isEdit ? 'Sửa dữ liệu' : 'Thêm dữ liệu',
                style: TextStyle(fontSize: 18),
              ),
            ),
            isEdit
                ? Text('IdMovie: ${idMovieController.text}')
                : TextField(
              textAlign: TextAlign.start,
              controller: idMovieController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'Movie ID',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: titleController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'Title',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: directorController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'director',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: desController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'des',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: imgController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'Img',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: urlMovieController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'Url movie',
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text('Chọn thể loại:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'BeVietnamPro', fontSize: 16)),
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: widget.genres.map((genre) {
                return GestureDetector(
                  onTap: () => _onGenreClick(genre),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: selectedGenres.contains(genre) ? AppColors.admin_color : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(
                          color: selectedGenres.contains(genre) ? Colors.white : Colors.black,
                          fontSize: 14.0, fontFamily: 'BeVietnamPro'
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                if (titleController.text == '' ||
                    desController.text == '' ||
                    imgController.text == '' ||
                    urlMovieController.text == '' ||
                    directorController.text == '') {
                  return;
                }
                Movie newMovie = Movie(
                    id: idMovieController.text,
                    title: titleController.text,
                    // genres: genresController.text.split(', '),
                    genres: selectedGenres,
                    description: desController.text,
                    imageUrl: imgController.text,
                    Director: directorController.text,
                    videoUrl: urlMovieController.text);

                (isEdit == true) ? widget.callback('EDIT', newMovie) : widget.callback('ADD', newMovie);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.admin_color,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: Text('Đồng ý')),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
