--List
CREATE TABLE lists(id integer primary key autoincrement, title VARCHAR(255), category_id INTEGER,last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP, isShare BOOLEAN DEFAULT '0' NOT NULL);
INSERT INTO `lists` (`title`, `category_id`) VALUES ('默认列表', 1);

--Category
CREATE TABLE categories(id INTEGER, name VARCHAR(255), last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO `lists` (`title`, `category_id`) VALUES ('默认列表', 1);