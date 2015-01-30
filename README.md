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

Common employee object looks like:

```json
"employee": {
  "email": "example@example.com",
}
```

### Update employee

`PATCH "/api/v1/employees/EMPLOYEE_ID"`
```json
"employee": {
  "email": "example@example.com",
}
```

if succceeded returns with status `200` employee object

otherwise returns with status `400`

```json
{"error":"Wrong credentials"}
```

### Delete employee

*only managers can delete employees*
`DELETE "/api/v1/employees/EMPLOYEE_ID"`
if succceeded returns with status `200` employee object

### Display single employee

`GET "/api/v1/employees/EMPLOYEE_ID"`

returns with status `200` employee object

### Display all employees

`GET "/api/v1/employees"`

returns with status `200` array of all employee objects

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

## Timetracks API

*All requests need authentication*

Common timetrack object looks like:

```json
"timetrack":{
  "id":1,
  "description":"text",
  "amount_in_minutes":60,
  "log_date":"YYYY-MM-DD"
}
```

### Display list of timetracks

`GET "/api/v1/timetracks"`
returns array of timetrack objects with status `200`

*NOTE: will return all timetracks if signed in as manager and only employee's timetracks if signed in as employee*

### Display single timetrack

`GET "/api/v1/timetracks/TIMETRACK_ID"`
returns timetrack object with status `200` or an error with status `404`

*NOTE: employee cannot see other employee's timetracks. Managers can see any timetracks*

### Create timetrack

`POST "/api/v1/timetracks"`

```json
"timetrack":{
  "description":"text",
  "amount_in_minutes":60,
  "log_date":"YYYY-MM-DD"
}

```

returns timetrack object with status `200`

If signed in as manager, one can send `employee_id` to assign timetrack to special employee:
```json
"timetrack":{
  "description":"text",
  "amount_in_minutes":60,
  "log_date":"YYYY-MM-DD",
  "employee_id":1
}

```

### Update timetrack

`PATCH "/api/v1/timetracks/TIMETRACK_ID"`

```json
"timetrack":{
  "description":"text",
  "amount_in_minutes":60,
  "log_date":"YYYY-MM-DD"
}

```

returns timetrack object with status `200` or error with status `404`

### Delete timetrack

`DELETE "/api/v1/timetracks/TIMETRACK_ID"`
returns timetrack object with status `200` or error with status `404`
