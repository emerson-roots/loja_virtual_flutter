abstract class QuerySqlite {

  static const String createTableHome = '''
  CREATE TABLE IF NOT EXISTS Home (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image TEXT NOT NULL,
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    pos INTEGER NOT NULL
);
''';

  static const String createTableProducts = '''
CREATE TABLE Products (
    id TEXT NOT NULL,
    title TEXT NOT NULL,
    icon TEXT NOT NULL
);
''';

  static const String createTablePlaces = '''
CREATE TABLE Places (
    id TEXT NOT NULL,
    address TEXT NOT NULL,
    image TEXT NOT NULL,
    lat TEXT NOT NULL,
    long TEXT NOT NULL,
    phone TEXT NOT NULL,
    title TEXT NOT NULL
);
''';

  static const String createTableUsers = '''
  CREATE TABLE Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    address TEXT NOT NULL
);

  ''';


  static const String insertsHome = '''
  INSERT INTO Home (image, x, y, pos) VALUES
('https://images.pexels.com/photos/206434/pexels-photo-206434.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=350', 3, 3, 0),
('https://img.freepik.com/free-photo/young-beautiful-woman-business-suit_1303-17709.jpg?t=st=1736013814~exp=1736017414~hmac=6ca784395a67ddeeda2e10fd65da287f6dbf19231a28dae0d8b82336f80575e8&w=740', 2, 2, 1),
('https://img.freepik.com/free-photo/happy-attractive-woman-standing-gray-looking-camera_231208-9141.jpg?t=st=1736017931~exp=1736021531~hmac=d7b8b6ef236ef01934758b5b1d0d04e47d4711cfca8218f5a4b536ea505b9729&w=740', 2, 1, 2),
('https://img.freepik.com/free-photo/long-haired-girl-hat-looking-shoulder-with-surprised-face-expression_197531-7371.jpg?t=st=1736018261~exp=1736021861~hmac=d126d072f8eb9385a566371f3625150ac8bcb7d22aaa21c6e0447ba472dfaa7c&w=1380', 2, 1, 3),
('https://img.freepik.com/free-photo/medium-shot-woman-sitting-chair_23-2149392849.jpg?t=st=1736017733~exp=1736021333~hmac=ebb57e7172bffec1961618d95903e768daabf987af5fee24a5eef875c664e96b&w=1380', 2, 2, 4);

  ''';

  static const String insertsProductsCategory = '''
  INSERT INTO Products (id, title, icon) VALUES 
('blusas', 'Blusas', 'https://media.istockphoto.com/id/1218433118/pt/foto/womens-light-blouse-isolated-on-white-background.jpg?s=2048x2048&w=is&k=20&c=B97pRQviyylnbkfGLM1A6NU-Psv7d6icjSYe0BSLVMA='),
('bones', 'Bonés', 'https://images.pexels.com/photos/844867/pexels-photo-844867.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
('calcas', 'Calças', 'https://images.pexels.com/photos/603022/pexels-photo-603022.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
('camisetas', 'Camisetas', 'https://images.pexels.com/photos/4066292/pexels-photo-4066292.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');

  ''';


  static const String insertsPlaces = '''
  INSERT INTO Places (id, address, image, lat, long, phone, title) VALUES
('1','Rua Tupiniquins', 'https://images.pexels.com/photos/3812433/pexels-photo-3812433.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', '-23.9809', '-46.3119', '(22) 22222-2222', 'Loja Santos'),
('2','Av. Paulista', 'https://images.pexels.com/photos/7679682/pexels-photo-7679682.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', '-23.5652', '-46.0521', '(11) 11111-1111', 'Loja Av. Paulista');

  ''';



  static const String insertsUser = '''
  INSERT INTO Users (email, password, name, address) VALUES
('teste@teste.com', '123456', 'Conta Teste', 'Rua dos Testes, 123');
  ''';
}