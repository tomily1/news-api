# README
[![Build Status](https://travis-ci.com/tomily1/news-api.svg?branch=master)](https://travis-ci.com/tomily1/news-api)
[![codecov](https://codecov.io/gh/tomily1/news-api/branch/master/graph/badge.svg?token=ZZGI54MU34)](https://codecov.io/gh/tomily1/news-api)

A simple API for a company’s internal news feed

### Requirements
1. Ruby version 2.7.1
2. Rails 5.2
3. Bundler version 2.1.4


### Technology used
* Language
  1. Ruby
* Framework used
  1. Ruby on Rails
* Development and testing
  1. RSpec Rails
  2. Rubocop
* Database
  1. PostgreSQL

### Setting up
1. clone this respository `git clone git@github.com:tomily1/news-api.git`.
2. Open the cloned directory with `cd news-api`.
3. Run `bundle install` to install dependencies
4. Run `cp -v .env.example .env` to copy over the environment variable
5. Run `rails db:setup` to setup the database (N.B postgresql is used for database)
5. run the app with `rails server`
6. the app will be available on `localhost:3000`

### Live Demonstration

### Endpoints

#### User Login
```
Request: POST "/login"

Parameters:
  body: { email: 'test@camillion.app', password: 'password'}

Response: 
{
    "access_token": "<JWT_LOGIN_TOKEN>",
    "token_type": "Bearer",
    "email": "test@camillion.app"
}
```

#### Logout
```
Request: POST "/logout"

Parameters: 
  header: { 'Authorization': 'Bearer <JWT_LOGIN_TOKEN>'}
  body: none

Response: 
{
  "message": "logged out"
}
```

#### Admin Logout

```
Request: POST "/admin/logout"

Parameters: 
  header: { 'Authorization': 'Bearer <JWT_LOGIN_TOKEN>'}
  body: none

Response: 
{
  "message": "logged out"
}
```

### User signup
```
Request: POST "/user"

Parameters: 
  body: { "email": "t@test.co", "password": "password" }

Response: 
{
  "data": { ...user_data }
}
```

#### Fetch News Posts

```
Request: GET "/posts"

Query params(optional): example: "/posts?page=2&per_page=1"
per_page: number of news posts per page
page: page number to fetch

Parameters: 
  header: { 'Authorization': 'Bearer <JWT_LOGIN_TOKEN>'}
  body: none

Response: 
{
  "data": [{}, {},{}....<news_posts>]
}
```

#### Fetch a News Post

```
Request: GET "/posts/:id"

Parameters: 
  header: { 'Authorization': 'Bearer <JWT_LOGIN_TOKEN>'}

Response: 
{
  "data": {<news_post>}
}
```

#### Admin Login

```
Request: POST "/admin/authentication/login"

Parameters:
  body: { email: 'test@camillion.app', password: 'password'}

Response: 
{
    "access_token": "<ADMIN_JWT_LOGIN_TOKEN>",
    "token_type": "Bearer",
    "email": "test@camillion.app"
}
```


#### Create a new Admin (Super Admin Only)
(Super Admin is automatically created when you run the seeds)

```
Request: POST "/admin/authentication"

Parameters:
  body: { email: 'test123@camillion.app', password: 'password'}

Response: 
{
  "data": {"user_data"}
}
```

#### Create a News Post (Admin Only)

```
Request: POST "/posts"

Parameters: 
  header: { 'Authorization': 'Bearer <ADMIN_JWT_LOGIN_TOKEN>'}
  body: { "title": "title", "content": "content" }

Response: 
{
  "data": {<news_post>}
}
```



### Future Improvements
