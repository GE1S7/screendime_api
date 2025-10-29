# Screendime API

A focused Elixir + Phoenix backend for a digital discipline tool that penalizes users when they visit blocked websites — using their own virtual currency as stakes. This backend serves as the core engine for a browser extension.


---


## Overview

The Screendime API enforces digital self-discipline through the following flow:

1. A browser extension notifies the API when a user visits a website.
2. The API checks if the URL matches any of the user’s blocked patterns.
3. If the visit violates a rule, the API deducts a penalty from the user’s balance.

---


## Key API Endpoints

| Method   | Endpoint                               | Description                                                   |
| -------- | -------------------------------------- | ------------------------------------------------------------- |
| **POST** | `/api/users`                           | Create a new user with a default balance and stake.           |
| **POST** | `/api/users/:user_id/blocked-patterns` | Add a blocked URL pattern (e.g., `youtube.com/*`).            |
| **POST** | `/api/users/:user_id/visits`           | Core endpoint — logs a visit and triggers the penalty engine. |
| **GET**  | `/api/users/:id`                       | Retrieve user details, including balance and stake.           |


## Core Functionality: The Penalty Engine

The API is intentionally designed around a single, atomic request–response cycle.  
All logic (validation, rule-checking, timezone-aware penalty application) occurs in one request.

**Example: Create user setting daily stake to 5.**
```bash
curl -X POST http://localhost:4000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "stake": 5
    }
  }'
```
Expected response (balance = 5 × 30 = 150):
```
{
  "data": {
    "id": 1,
    "balance": 150,
    "joined": "2025-10-29T18:00:00Z",
    "last_penalty": null,
    "recharges_on": "2025-11-28T18:00:00Z",
    "stake": 5
  }
}
```
**Example: Add blocked pattern for User ID 1**
```bash
curl -X POST http://localhost:4000/api/users/1/blocked-patterns \
  -H "Content-Type: application/json" \
  -d '{
    "blocked_pattern": {
      "user_id": 1,
      "url": "youtube.com/*"
    }
  }'
```
Expected response:
```
{
  "data": {
    "id": 1,
    "pattern": "youtube.com/*"
  }
}
```

**Example: A user visits a blocked site and is penalized.**

```bash
curl -X POST http://localhost:4000/api/users/1/visits \
  -H "Content-Type: application/json" \
  -d '{
    "visit": {
      "url": "https://www.youtube.com/watch?v=some-video",
      "timezone": "America/New_York"
    }
  }'
```
Expected response:
```
{
  "status": "penalized",
  "message": "Penalty applied for visiting a blocked site.",
  "new_balance": 95
}
```

The penalty engine handles:

- Duplicate penalties on the same day (skipped in local time)
- Insufficient user balances
- Timezone-based rule evaluation (user gets penalized at most once per day based on their timezone)

---


## Tech Stack

- **Elixir & Phoenix Framework** — Core API logic and HTTP routing
- **Ecto with SQLite3** — Data persistence and querying
- **Timex** — Timezone-aware date/time operations
- **Wildcard** — Flexible URL pattern matching (e.g., `youtube.com/*`)
  Simply adjust your `config/dev.exs` and `config/test.exs` database settings if you prefer SQLite

---


## 🛠️ Run Locally

### **Prerequisites**

- Elixir & Erlang
- SQLite3
- Node.js
- `curl` and `jq` (for testing scripts)

---


### **Setup**

Clone the repository and enter the directory:

```bash
git clone https://github.com/GE1S7/screendime_api.git
cd screendime_api
```

### Install Dependencies and Initialize the Database

Run the setup task, which installs dependencies and sets up the database:

```bash
mix setup
```

### Run the Development Server

Start the Phoenix server:

```bash
mix phx.server
```

The API should now be running at **[http://localhost:4000](http://localhost:4000)**.


---


## Testing the Core Workflow

The project includes simple shell scripts that demonstrate the full API workflow end-to-end.  
Each script simulates a real-world scenario and can be run in sequence.

Make the test scripts executable:

```bash
chmod +x 0*.sh

./01_create_user_and_pattern.sh
./02_test_penalty.sh
./03_test_allowed.sh
```

Each script demonstrates a specific step in the user flow:

01: Create a user and register blocked URL patterns.

02: Visit a blocked URL and trigger a penalty.

03: Visit an allowed URL (no penalty applied).

