class CategoryModel {
  int id;
  String image;
  String name;
  CategoryModel({this.id,this.image,this.name});
  factory CategoryModel.fromJson(Map<String,dynamic>json){
    return CategoryModel(
      id: int.tryParse(json['id'].toString()),
      image: json['image'],
      name: json['name']
    );
  }
}
