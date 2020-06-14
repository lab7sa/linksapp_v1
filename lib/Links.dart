class Links{
  final String l_id;
  final String title;
  final String link;

  Links({this.l_id, this.title, this.link});

  factory Links.fromJSON(Map<String, dynamic> json){
    return Links(
        l_id: json['l_id'],
        title: json['title'],
        link: json['link']
    );
  }
}