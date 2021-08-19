# Mini Socmed API

This repo contains code for generasi GIGIH Final Project in the Backend track Intermediate Level. The problem for this project is to make a social media API. Like other social media, users can make a post with hashtags and one attachment, also users can comment and many details.

## ERD schema

For the database I build schema like in the `database_schema` folder. I provide an imported sql with name `socmed_db.sql`.

### Note for ERD & Database

I write some notes for you easier to understand my erd and database schema.

- for field `created_time` I use the type `TIMESTAMP`. I think this type is easier for me if I want to group data by time.
- field `attachment` stores the path where the attachment file is stored. For now the extension that can be save for attachment file is `.jpg`, `.png`, `.gif`, `.mp4` and other extension outside picture and video format.
- field `tag` contains the hashtag in lowercase.

## Prerequisite to run application locally

To run this app you need to install some dependencies below:

- install Ruby, for developing this app I use ruby 3.0
- install sinatra

```sh
gem install sinatra
```

- install mysql2

```sh
gem install mysql2
```

- import the database that I have provided. file `socmed_db.sql`
- setting the environtment variable. please make sure the value of the environment variable matches your database environment.

```sh
export DB_HOST_1=localhost
export DB_USERNAME_1=root_dio
export DB_PASSWORD_1=root_dio
export DB_NAME_1=socmed_db
```

- clone this repo and run this command to start the app

```sh
ruby app.rb
```

## Test

for testing I use rspec and simplecov. Please make sure you already installed it.

```sh
gem install rspec
```

```sh
gem install simplecov
```

to run the test you can run by command below. (actually i prefer to use format document in rspec)

```sh
rspec -f d
```

to test endpoint you can go to API documentation and import the url from there or you can import the collection from exported collection in `documentation/postman` folder.

## API Documentation

I create API documentation with postman. You can easily import it from `documentation/postman` folder

In postman I use some global variable. Please make sure you provide it in your postman.

### Postman Global variables

| name     | initial value                       | type   |
| -------- | ----------------------------------- | ------ |
| base_url | http://35.247.153.229:4567 (ip GCP) | string |
| user_id  | 1                                   | int    |
| tag      | tag                                 | string |
| post_id  | 1                                   | int    |

or you can easily import the global variable in `documentation/postman` folder
