class ListModel {
  ListModel(this.label);

  String label;

  ListModel.fromJson(Map<String, dynamic> json) : label = json['label'];

  Map<String, dynamic> toJson(){
    return {
      'label': label,
    };
  }
}