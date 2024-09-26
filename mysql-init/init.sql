-- Создание базы данных для разработки
CREATE DATABASE IF NOT EXISTS ccc_development;

-- Создание базы данных для тестирования
CREATE DATABASE IF NOT EXISTS ccc_test;

-- Предоставление всех привилегий на базы данных пользователю ccc_user
GRANT ALL PRIVILEGES ON ccc_development.* TO 'ccc_user'@'%';
GRANT ALL PRIVILEGES ON ccc_test.* TO 'ccc_user'@'%';

-- Применение привилегий
FLUSH PRIVILEGES;
