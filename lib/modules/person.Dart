class Person{

final   int id ; 
final  String name ;
final  String email ;


Person({
 required this.id,
 required this.name,
required this.email,});



 Map<String,dynamic> toMap(){
   return {
     'id':this.id,
     'name':this.name,
     'email':this.email,
   };
 } 

 factory Person.fromMap(Map<String,dynamic> map){
   return Person(
     id:map['id'],
     name:map['name'],
     email:map['email'],
   );
 }

 @override
  String toString() {
    return 'Person(id:$id,name:$name,email:$email)';
  }
}