--List
CREATE TABLE lists(id INTEGER, title VARCHAR(255), category_id INTEGER,last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO `lists` (`id`, `title`, `category_id`) VALUES (1, 'test', 1);
INSERT INTO `lists` (`id`, `title`, `category_id`) VALUES (2, 'test2', 2);

--Category
CREATE TABLE categories(id INTEGER, name VARCHAR(255), last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP);