abstract class QuerySqlite {

  static const String CATEGORY_TABLE_NAME = 'CategoryProduct';
  static const String PRODUCT_TABLE_NAME = 'Products';
  static const String PRODUCT_IMAGE_TABLE_NAME = 'ProductImages';
  static const String PRODUCT_SIZE_TABLE_NAME = 'ProductSizes';
  static const String CART_PRODUCT_TABLE_NAME = 'CartProduct';

  static const String createTableHome = '''
  CREATE TABLE IF NOT EXISTS Home (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image TEXT NOT NULL,
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    pos INTEGER NOT NULL
);
''';

  static const String createTableCategoryProduto = '''
CREATE TABLE $CATEGORY_TABLE_NAME (
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


  static const String createTableProducts = '''
  CREATE TABLE ${PRODUCT_TABLE_NAME} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT,
    title TEXT,
    description TEXT,
    price REAL
);
  ''';

  static const String createTableProductImages = '''
  CREATE TABLE ${PRODUCT_IMAGE_TABLE_NAME} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER,
    image_url TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE
);

  ''';

  static const String createTableProductSizes = '''
  CREATE TABLE $PRODUCT_SIZE_TABLE_NAME (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER,
    size TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE
);
  ''';


  static const String createTableCartProducts = '''
  CREATE TABLE $CART_PRODUCT_TABLE_NAME (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uid TEXT NOT NULL,
    pid TEXT NOT NULL,
    category TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    size TEXT NOT NULL,
    product_title TEXT NOT NULL,
    product_description TEXT,
    product_price REAL NOT NULL
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
  INSERT INTO $CATEGORY_TABLE_NAME (id, title, icon) VALUES 
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
('test@test.com', '123456', 'Test Account', 'Rua dos Testes, 123');
  ''';

  static const String insertsProducts = '''
  INSERT INTO $PRODUCT_TABLE_NAME (category, title, description, price) VALUES
('camisetas', 'Camiseta Branca', 'Produto de alta qualidade!', 50.99),
('camisetas', 'Camiseta azul', 'Descricao blue', 15.5),
('camisetas', 'Camiseta Verde', 'Um verde de tonalidade tipo musgo', 17.0),
('calcas', 'Calça Jeans', 'Calça tipo Denin', 89.9);

  ''';

  static const String insertsProductImages = '''
  INSERT INTO $PRODUCT_IMAGE_TABLE_NAME (product_id, image_url) VALUES
(1, 'https://images.pexels.com/photos/8217533/pexels-photo-8217533.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
(1, 'https://images.pexels.com/photos/8217291/pexels-photo-8217291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),


(2, 'https://img.freepik.com/free-photo/portrait-smiling-young-man-wearing-fashion-glasses_329181-2141.jpg?t=st=1736013351~exp=1736016951~hmac=1a9067bd3da9cb5f6a0608c0b9e950341e85464b03bff927483442d9d208ad93&w=740'),
(2, 'https://img.freepik.com/free-photo/portrait-smiling-young-man_329181-2144.jpg?t=st=1736013392~exp=1736016992~hmac=4bee37ac7ff7a5e341a5bb94ca88d3f5cf017339056f0d72d75e8ce9f4ea21d7&w=740'),

(3, 'https://img.freepik.com/free-photo/young-woman-with-short-curly-hair-green-t-shirt-happy-positive-winking-showing-thumbs-up-standing-orange-wall_141793-29187.jpg?t=st=1736013453~exp=1736017053~hmac=82393c956727af064089d0b2a4659da3aa78efbe163e4f391a53d43374dbaf05&w=1380'),
(3, 'https://img.freepik.com/free-photo/young-woman-with-short-curly-hair-green-t-shirt-clenching-fists-happy-excited-standing-orange-wall_141793-29183.jpg?t=st=1736013577~exp=1736017177~hmac=6ae0bf11064d44a82db32c4ab03fc10539b5d1fddd3e1c11ec8d5000e84ffdd3&w=1380'),

(4, 'https://img.freepik.com/fotos-gratis/denims_1303-4490.jpg?ga=GA1.1.1465085871.1748478929&w=740'),
(4, 'https://img.freepik.com/fotos-gratis/posicao-mulher-em-escritorio_23-2148180649.jpg');


  ''';

  static const String insertsProducSizes = '''
  INSERT INTO $PRODUCT_SIZE_TABLE_NAME (product_id, size) VALUES
(1, 'P'), (1, 'M'), (1, 'G'), (1, 'GG'), (1, 'XG'), (1, 'XXG'), (1, 'XL'),
(2, 'P'), (2, 'G'), (2, 'XL'),
(3, 'P'), (3, 'M'), (3, 'GG'),
(4, 'P'), (4, 'M'), (4, 'GG');

  ''';

}