class Registros{
  String? gameid;
  String? userid;
  String? image;
  String? comment;
  String? commentid;
  String? gamename;
  String? gamertag;
  String? rank;
  String? user;
  String? username;
  String? email;
  String? juegofavorito;
  String? imagen;

  Registros(this.gameid, this.userid, this.image, this.comment, this.commentid, this.gamename, this.gamertag, this.rank, this.user, this.username, this.email, this.juegofavorito,this.imagen);

  Registros.fromJson(Map<String, dynamic> json){
    gameid = json['gameid'].toString();
    userid = json['userid'].toString();
    image = json['image'].toString();
    comment = json["comment"].toString();
    commentid = json["commentid"].toString();
    gamename = json['gamename'].toString();
    gamertag = json['gamertag'].toString();
    imagen=json['imagen'].toString();
    rank = json['rank'].toString();
    user = json['user'].toString();
    username = json['username'].toString();
    email = json['email'].toString();
    juegofavorito = json['juegofavorito'].toString();
  }
}