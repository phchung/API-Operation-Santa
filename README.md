# Operation Santa API
This API is required as the middleware for [Operation Santa](https://github.com/carr0lls/operation-santa) to operate.

## Prerequisites
- Postgres
- Ruby on rails

## To run

```sh
bundle install

rake db:setup

# Start server
rails s
```

## Todo
- Family and adopter matching/pairing (pair upon new user registration and upon pair terminations)
- Restrict API endpoints' access by requiring session_token for privileged actions