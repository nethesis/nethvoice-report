# API
- `POST` `/api/login`

  Used to login (authenticate) the user
  
  **Body request**
  ```json
  {
    "username": "username",
    "password": "password"
  }
  ```
  **Body response**
   ```
  {
    "code":200,
    "expire":"2020-09-17T11:55:40+02:00",
    "token":"zzzAAAbbbIUzI1NiIsInR5cCI6IkpXVCJ9.zzzAAAbbb2MDAzMzY1NDAsImlkIjoiYWRtaW4iLCJvcmlnX2lhdCI6MTYwMDMzMjk0MCwicXVldWVzIjpbIjQwMiIsIjQwMyJdfQ.zzzAAAbbbXqJeUVhKsMlqckvS_gvV_C5HIZxNV8"
  }
  ```
- `POST` `/api/logout`

  Used to logout the user
  
  **Header request**
  ```json
  Authorization: <Bearer your_JWT_token>
  Content-Type: application/json
   ```
  **Body request**
  ```
  {}
  ```
  **Body response**
  ```
  {
    "code":200
  }
  ```
- `GET` `/api/refresh_token`

  Used to refresh JWT token before expiration
  
  **Header request**
  ```json
  Authorization: Bearer <your_JWT_token>
  Content-Type: application/json
  ```
  **Body request**
   ```
  {}
  ```
  **Body response**
  ```
  {
    "code":200,
    "expire":"2020-09-17T11:55:40+02:00",
    "token":"zzzAAAbbbIUzI1NiIsInR5cCI6IkpXVCJ9.zzzAAAbbb2MDAzMzY1NDAsImlkIjoiYWRtaW4iLCJvcmlnX2lhdCI6MTYwMDMzMjk0MCwicXVldWVzIjpbIjQwMiIsIjQwMyJdfQ.zzzAAAbbbXqJeUVhKsMlqckvS_gvV_C5HIZxNV8"
  }
  ```
- `GET` `/api/queues/:section/:view`

  Used to execute a specific query for a particular section and view
  
  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
    ```
  **URL params**
  ```
  ?filter={json_encoded_filter}
  ?graph=query_name_of_the_graph
  ```
  **Body response**
  ```
  [
    [col1, col2, col3],
    [val1, val2, val3],
    ...
    [valX, valY, valZ]
  ]
  ```
- `GET` `/api/searches`

  Used to retrieve all user's custom searches
  
  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
  ```
  **Body request**
  ```
  {}
  ```
  **Body response**
  ```
  {
   "searches":[
      {
         "name":"search_name",
         "section":"data",
         "view":"agent",
         "filter":{
            "queues":null,
            "groups":null,
            "time":{
               "time_range":"day",
               "value":"monday"
            },
            "name":"company_name",
            "agent":"agent_name",
            "nullCall":true
         }
      }
    ]
  } 
  ```
- `GET` `/api/filters/:section/:view`

  Used to retrieve default filter or override filters
  
  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
  ```
  **Body request**
  ```
  {}
  ```
  **Body response**
  ```
  {
   "filter":{
      "queues":null,
      "groups":null,
      "time":{
         "time_range":"day",
         "value":"monday"
      },
      "name":"Edoardo Override",
      "agent":"5555 override",
      "nullCall":true
    }
  }
  ```
