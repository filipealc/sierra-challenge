# Sierra Challenge API

This Ruby on Rails API provides functionality to create warehouses and customers, calculate the distance between them, and secure endpoints with bearer token authentication.

## Getting Started

To get started with the Sierra Challenge API, follow these steps:

### Prerequisites

- Ruby (version as specified in `.ruby-version` or `Gemfile`)
- Rails (compatible version with the Ruby version used)
- Docker and Docker Compose (for containerized environments)

### Setup

1. Clone the repository to your local machine:

```bash
git clone https://github.com/filipealc/sierra-challenge.git
cd sierra-challenge
```

2. Clone the .env,sample and set the right keys to it

```bash
cp .env.example .env
```

3. Build the Docker containers:

```bash
docker-compose build
```

4. Start the Docker containers:

```bash
docker-compose up -d
```

5. Create and set up the development and test databases:

```bash
docker-compose exec web rails db:create db:migrate
docker-compose exec web rails db:create db:migrate RAILS_ENV=test
```

## Running Tests

To run the test suite, execute the following command:

```bash
docker-compose exec web rails test
```

Or, to run a specific test file:

```bash
docker-compose exec web rails test test/path/to/your_test.rb
```

## Using the API

### Generating a Token

Before accessing the secured endpoints, you need to generate a token:

```bash
curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' http://localhost:3000/authenticate
```

Use the returned token as a bearer token in the `Authorization` header for subsequent requests.

### Creating a Warehouse

To create a warehouse, send a POST request with the warehouse details:

```bash
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer your_token" -d '{"warehouse":{"name":"Main Warehouse","location":"Rod. Jorn. Manoel de Menezes, 2001 - Praia Mole, Florianópolis - SC, 88061-700"}}' http://localhost:3000/warehouses
```

### Creating a Customer

To create a customer, send a POST request with the customer details:

```bash
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer your_token" -d '{"customer":{"name":"John","address":"R. Francisco Cândido Xavier, 702 - Campeche, Florianópolis - SC, 88066-027"}}' http://localhost:3000/customers
```

### Calculating Distance

To calculate the distance between a warehouse and a customer, send a GET request:

```bash
curl -X GET -H "Authorization: Bearer your_token" http://localhost:3000/warehouses/:warehouse_id:/distance_to_customer/:customer_id:
```

Replace `:warehouse_id:` with the warehouse ID and `:customer_id:` with the customer ID.

## Notes

- Replace `localhost:3000` with the appropriate domain or IP address if not running locally.
- Replace `your_token` with the actual token received from the authentication endpoint.
- This API is for demonstration purposes.

## Technical Decisions

- Useful info on the most important decisions:
  - The decision on where to store the route for calculating the distance (or whatever action) is important here if we follow the REST guidelines, we could either set it at the customer or the warehouse models, but, it's important to note that the real decision is to put it into a model/resource because we should be resource oriented, also, if we take the path to create a new controller for every action then we would have tons of controllers inflating the API with a lot of lose endpoints.
  - Second big decision is, should a customer "own" a warehouse? per the requirements we were asked to 'Users should be able to Create Customers' and 'Users of the API should be able to Create Warehouses' but never detailed a correlation between them, thus, this provides a lot of room for different kind of implementations, we could create a Customer 1 - N Warehouses or the opposite, or, either, a tertiary table that would hold a N - N relationship. To keep it simple we just did no relation at all and allowed the distance calculation endpoint to be the 'main' resource we wanted working.
  - Third, we choose to keep controllers simple, no business logic there and added a services folder to keep the calculation itself, should also be noted that this is not yet ideal, we should have a proper google integration service and separately the distance calculator that would use it so we would be able to re-use the g-integration in other places.
  - Forth, we choose the distance endpoint from google GEM instead of the distance_matrix just because it was more straightforward, for a real use case we should use the proper API endpoint that would correspond to our needs.
  - Fifth, at app/controllers/authentication_controller.rb#26 we set our expiration token to 1.minute just to be easy to test if the expiration validation was being done.
