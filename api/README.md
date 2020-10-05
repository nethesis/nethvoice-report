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
   ```json
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
  ```json
  {}
  ```
  **Body response**
  ```json
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
   ```json
  {}
  ```
  **Body response**
  ```json
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
  ```json
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
  ```json
  {}
  ```
  **Body response**
  ```json
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

- `POST` `/api/searches`

  Used to save a custom search

  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {
    "name": "check",
    "section": "data",
    "view": "agent",
    "filter": {
      "queue": "401",
      "time": {
        "time_range": "day",
        "value": "monday"
      },
      "name": "Edoardo",
      "agent": "5555",
      "null_call": true
    }
  }
  ```
  **Body response**
  ```json
  {
    "message": "search saved successfully"
  }
  ```

- `DELETE` `/api/searches/:search_id`

  Used to save a custom search

  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {}
  ```
  **Body response**
  ```json
  {
    "message": "search deleted successfully"
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
  ```json
  {}
  ```
  **Body response**
  ```json
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

- `GET` `/api/authorizations`

  Used to retrieve all user's authorizations

  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {}
  ```
  **Body response**
  ```json
  {
    "authorizations": {
      "username": "X",
      "queues": [
        "4444",
        "4443"
      ],
      "groups": [
        "development",
        "support",
        "marketing"
      ],
      "agents": [
        "Michele",
        "Scatolini"
      ]
    }
  }
  ```

- `GET` `/api/phonebook`

  Used to retrieve all saved numbers in phonebook

  **Header request**
  ```
  Authorization: Bearer your_JWT_token
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {}
  ```
  **Body response**
  ```json
  {
    "Contact Name One": {
      "homephones": [
        ""
      ],
      "workphones": [
        "00395558888777"
      ],
      "cellphones": [
        ""
      ]
    },
    "Contact Name Two": {
      "homephones": [
        ""
      ],
      "workphones": [
        "00395558222444"
      ],
      "cellphones": [
        ""
      ]
    },
    ...
  }
  ```

- `GET` `/api/settings`

  Used to retrieve all admin settings

  **Header request**
  ```
  Authorization: Bearer your_JWT_token (only admin or X user)
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {}
  ```
  **Body response**
  ```json
  {
    "settings": {
      "start_hour": "10:00",
      "end_hour": "18:00"
    }
  }
  ```

- `PUT` `/api/settings`

  Used to update admins settings

  **Header request**
  ```
  Authorization: Bearer your_JWT_token (only admin or X user)
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {
    "start_hour": "10:00",
    "end_hour": "18:00"
  }
  ```
  **Body response**
  ```json
  {
    "message": "settings updated successfully"
  }
  ```

- `GET` `/api/query_tree`

  Used to retrieve all queries saved in file system

  **Header request**
  ```
  Authorization: Bearer your_JWT_token (only admin or X user)
  Content-Type: application/json
  ```
  **Body request**
  ```json
  {}
  ```
  **Body response**
  ```json
  {
    "query_tree": {
      "dashboard": {
        "default": [
          "graph_call_distribution_per_queue",
          "zone_comune_provincia_regione"
        ]
      },
      "data": {
        "agent": [
          "graph_call_distribution_per_queue",
          "other_query",
          "query"
        ],
        "call": [
          "query"
        ],
        "caller": [
          "query"
        ],
        "ivr": [
          "query"
        ],
        "session": [
          "query"
        ],
        "summary": [
          "query"
        ],
        "test": [
          "queryyy"
        ]
      },
      "distribution": {
        "geographic": [
          "query"
        ],
        "hourly": [
          "query"
        ]
      },
      "graphs": {
        "agent": [
          "query"
        ],
        "area": [
          "query"
        ],
        "avg_duration": [
          "query"
        ],
        "avg_wait": [
          "query"
        ],
        "hour": [
          "query"
        ],
        "load": [
          "query"
        ],
        "queue_position": [
          "query"
        ]
      },
      "performance": {
        "default": [
          "query"
        ]
      }
    }
  }
  ```