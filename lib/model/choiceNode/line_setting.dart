class LineSetting{
  int y;
  int maxSelect;

  LineSetting(this.y, {this.maxSelect = -1});

  Map<String, dynamic> toJson() =>{
    'y' : y,
    'maxSelect' : maxSelect
  };

  LineSetting.fromJson(Map<String, dynamic> json):
      y = json['y'],
      maxSelect = json['maxSelect'];
}