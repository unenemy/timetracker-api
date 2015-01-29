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

if email and password match, returns with status `200`

```json
{"token":"qweks1k23j231k23"}
```

otherwise returns status `400`

```json
{"error":"Wrong credentials"}
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
{"token":"qweks1k23j231k23"}
```

otherwise returns with status `400`

```json
{"error":"Wrong credentials"}
```

After receiving the token, you must include it in all the requests `Authorization` header to be recognized by the server.

### Employees registration API

*doesn't require authentication*

`POST "/api/v1/employees"`

```json
"employee": {
  "email": "example@example.com",
  "password": "password",
  "password_confirmation": "password"
}
```

if succeeded returns with status `200`
```json
{
  "employee": {
    "email": "example@example.com",
  }
}
```

otherwise returns with status `422`

```json
{
  "errors": {
    "password": ["Doesn't match confirmation", "Is required"]
  }
}
```

## Employees API

*all actions require authentication*

### Update employee

`PATCH "/api/v1/employees/EMPLOYEE_ID"`
```json
"employee": {
  "email": "example@example.com",
}
```

if succceeded returns with status `200`
```json
"employee": {
  "email": "example@example.com",
}
```

otherwise returns with status `400`

```json
{"error":"Wrong credentials"}
```

### Delete employee

*only managers can delete employees*
`DELETE "/api/v1/employees/EMPLOYEE_ID"`

### Display single employee

`GET "/api/v1/employees/EMPLOYEE_ID"`

returns with status `200`

```json
"employee": {
  "email": "example@example.com",
}
```

### Display all employees

`GET "/api/v1/employees"`

returns with status `200` array of all employees
```json
[
  "employee": {
    "email": "example@example.com",
  },
  "employee": {
    "email": "example@example.com",
  }
]
```

## Managers API

*ONLY managers can manage managers*
*ALL actions require authentication*

Common manager object looks like this:

```json
"employee": {
  "email": "example@example.com",
}

```

### Display all managers

`GET "/api/v1/managers"`
returns with status `200` array of manager objects

### Display single manager

`GET "/api/v1/managers/MANAGER_ID"`
returns with status `200` manager object

### Create manager

`POST "/api/v1/managers"`
```json
"manager": {
  "email": "example@example.com",
  "password": "password",
}
```

returns with status `200` manager object

### Update manager

`PATCH "/api/v1/managers/MANAGER_ID"`
```json
"manager": {
  "email": "example@example.com",
  "password": "password",
}
```
returns with status `200` manager object

### Delete manager

`DELETE "/api/v1/managers/MANAGER_ID"`

returns with status `200` manager object

