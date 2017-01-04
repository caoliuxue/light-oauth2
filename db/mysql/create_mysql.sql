DROP DATABASE IF EXISTS oauth2;
CREATE DATABASE oauth2;
USE oauth2;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id VARCHAR(32) NOT NULL,
  user_type VARCHAR(16) NOT NULL,  -- admin, customer, employee, partner
  first_name VARCHAR(32) NOT NULL,
  last_name VARCHAR(32) NOT NULL,
  email VARCHAR(64) NOT NULL,
  password VARCHAR(1024) NOT NULL,
  create_dt DATE NOT NULL,
  update_dt DATE,
  PRIMARY KEY (user_id)
)
ENGINE=INNODB;

CREATE UNIQUE INDEX email_idx ON users(email);

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
  client_id VARCHAR(36) NOT NULL,
  client_type VARCHAR(10) NOT NULL,  -- server, mobile, service, standalone, browser etc
  client_secret VARCHAR(22) NOT NULL,
  client_name VARCHAR(32) NOT NULL,
  client_desc VARCHAR(2048),
  scope VARCHAR(1024),
  redirect_url VARCHAR(1024),
  authenticate_class VARCHAR(256),
  owner_id VARCHAR(32) NOT NULL,
  create_dt DATE NOT NULL,
  update_dt DATE,
  PRIMARY KEY (client_id),
  FOREIGN KEY (owner_id) REFERENCES users(user_id)
)
ENGINE=INNODB;

DROP TABLE IF EXISTS services;
CREATE TABLE services (
  service_id VARCHAR(32) NOT NULL,
  service_type VARCHAR(8) NOT NULL,  -- api, ms
  service_name VARCHAR(32) NOT NULL,
  service_desc VARCHAR(1024),
  scope VARCHAR(1024),
  owner_id VARCHAR(32) NOT NULL,
  create_dt DATE NOT NULL,
  update_dt DATE,
  PRIMARY KEY (service_id),
  FOREIGN KEY (owner_id) REFERENCES users(user_id)
)
ENGINE=INNODB;

INSERT INTO users (user_id, user_type, first_name, last_name, email, password, create_dt)
VALUES('admin', 'admin', 'admin', 'admin', 'admin@cibc.com', '1000:5b39342c202d37372c203132302c202d3132302c2034372c2032332c2034352c202d34342c202d31362c2034372c202d35392c202d35362c2039302c202d352c202d38322c202d32385d:949e6fcf9c4bb8a3d6a8c141a3a9182a572fb95fe8ccdc93b54ba53df8ef2e930f7b0348590df0d53f242ccceeae03aef6d273a34638b49c559ada110ec06992', NOW());

INSERT INTO clients (client_id, client_secret, client_type, client_name, client_desc, scope, redirect_url, owner_id, create_dt)
VALUES('f7d42348-c647-4efb-a52d-4c5787421e72', 'f6h1FTI8Q3-7UScPZDzfXA', 'server', 'PetStore Web Server', 'PetStore Web Server that calls PetStore API', 'petstore.r petstore.w', 'http://localhost:8080/authorization', 'admin', NOW());

INSERT INTO services (service_id, service_type, service_name, service_desc, scope, owner_id, create_dt)
VALUES ('AACT0001', 'ms', 'Account Service', 'A microservice that serves account information', 'a.r b.r', 'admin', NOW());
