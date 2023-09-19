class BookListModel {
  int? totalPages;
  int? limit;
  int? pageNo;
  List<Rows>? rows;

  BookListModel({this.totalPages, this.limit, this.pageNo, this.rows});

  BookListModel.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
    limit = json['limit'];
    pageNo = json['page_no'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_pages'] = this.totalPages;
    data['limit'] = this.limit;
    data['page_no'] = this.pageNo;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  int? id;
  String? name;
  int? authorId;
  String? authorName;
  int? noOfPages;
  int? publisherId;
  String? publisherName;
  int? categoryId;
  String? categoryName;
  int? publishYear;
  String? image;
  String? pdf;
  int? createdAt;
  int? updatedAt;

  Rows(
      {this.id,
      this.name,
      this.authorId,
      this.authorName,
      this.noOfPages,
      this.publisherId,
      this.publisherName,
      this.categoryId,
      this.categoryName,
      this.publishYear,
      this.image,
      this.pdf,
      this.createdAt,
      this.updatedAt});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    authorId = json['author_id'];
    authorName = json['author_name'];
    noOfPages = json['no_of_pages'];
    publisherId = json['publisher_id'];
    publisherName = json['publisher_name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    publishYear = json['publish_year'];
    image = json['image'];
    pdf = json['pdf'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['author_id'] = this.authorId;
    data['author_name'] = this.authorName;
    data['no_of_pages'] = this.noOfPages;
    data['publisher_id'] = this.publisherId;
    data['publisher_name'] = this.publisherName;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['publish_year'] = this.publishYear;
    data['image'] = this.image;
    data['pdf'] = this.pdf;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
