# Timetracker API

This is Ruby On Rails based JSON API for timetracker application.

Implemented:
1. Token-authentication for employees and managers.
2. Restricted timetracks managing
3. API fully covered with Rspec request tests.

# Documentation

## Authentication

Authentication is implemented using tokens. Meaning, to authenticate you need to include a header "Authorization" with value "Token token=YOUR_TOKEN".

To get the token, either employee or manager should be authenticated.

### Manager authentication

`POST "/api/v1/managers/sign_in"`

```json
"manager": {
  "email": "example@example.com",
  "password": "password"
}
```

if email and password match, returns with status 200

```json
"token":"qweks1k23j231k23"
```

otherwise returns status 400

```json
"error":"Wrong credentials"
```

### Employee authentication

`POST "/api/v1/employees/sign_in"`
```json
"employee": {
  "email": "example@example.com",
  "password": "password"
}
```

if email and password match, returns

```json
"token":"qweks1k23j231k23"
```

otherwise returns with status 400

```json
"error":"Wrong credentials"
```

After receiving the token, you must include it in all the requests `Authorization` header to be recognized by the server.
