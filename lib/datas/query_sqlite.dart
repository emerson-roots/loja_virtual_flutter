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

  static const String insertsHome = '''
  INSERT INTO Home (image, x, y, pos) VALUES
('https://images.pexels.com/photos/206434/pexels-photo-206434.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=350', 3, 3, 0),
('https://img.freepik.com/free-photo/young-beautiful-woman-business-suit_1303-17709.jpg?t=st=1736013814~exp=1736017414~hmac=6ca784395a67ddeeda2e10fd65da287f6dbf19231a28dae0d8b82336f80575e8&w=740', 2, 2, 1),
('https://img.freepik.com/free-photo/happy-attractive-woman-standing-gray-looking-camera_231208-9141.jpg?t=st=1736017931~exp=1736021531~hmac=d7b8b6ef236ef01934758b5b1d0d04e47d4711cfca8218f5a4b536ea505b9729&w=740', 2, 1, 2),
('https://img.freepik.com/free-photo/long-haired-girl-hat-looking-shoulder-with-surprised-face-expression_197531-7371.jpg?t=st=1736018261~exp=1736021861~hmac=d126d072f8eb9385a566371f3625150ac8bcb7d22aaa21c6e0447ba472dfaa7c&w=1380', 2, 1, 3),
('https://img.freepik.com/free-photo/medium-shot-woman-sitting-chair_23-2149392849.jpg?t=st=1736017733~exp=1736021333~hmac=ebb57e7172bffec1961618d95903e768daabf987af5fee24a5eef875c664e96b&w=1380', 2, 2, 4);

  ''';

}