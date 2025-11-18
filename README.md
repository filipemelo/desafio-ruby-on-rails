## API Documentation

### CNAB File Upload

**Endpoint:** `POST /cnab_files`

**Parameters:**
- `cnab_file[file]` (CNAB file, required)

**Example using curl:**
```sh
curl -X POST \
	-F "cnab_file[file]=@CNAB.txt" \
	http://localhost:3000/cnab_files
```

**Response (redirect):**
- HTTP 302 to `/stores` on success
- HTTP 422 with error message on failure

---

### List Stores and Transactions (HTML)

**Endpoint:** `GET /stores`

**Response:**
- HTML page with all stores, owners, balance and imported transactions

---

### (Optional) List Stores and Transactions (JSON)

If you want to expose a JSON endpoint, add to `StoresController`:

```ruby
def index
	@stores = Store.includes(:transactions).order(:name)
	respond_to do |format|
		format.html
		format.json { render json: @stores.as_json(include: :transactions) }
	end
end
```

**Endpoint:** `GET /stores.json`

**Example response:**
```json
[
	{
		"id": 1,
		"name": "BAR DO JOAO",
		"owner": "JOAO MACEDO",
		"transactions": [
			{
				"id": 1,
				"transaction_type": 1,
				"date": "2019-03-01",
				"amount": "142.00",
				"cpf": "09620676017",
				"card": "4753****3153",
				"time": "15:34:53",
				"description": "Debit",
				"nature": "Income"
			}
		]
	}
]
```

---
---

## How to Consume the API

### CNAB File Upload

**Endpoint:** `POST /cnab_files`

**Example using curl:**

```sh
curl -X POST \
	-F "cnab_file[file]=@CNAB.txt" \
	http://localhost:3000/cnab_files
```

### List Stores and Transactions

**Endpoint:** `GET /stores`

Returns the HTML page with stores and imported transactions. For a JSON API, you would need to create an additional endpoint.

---
# Ruby on Rails Challenge - CNAB Bycoders_

## Description

Web application to import CNAB files, normalize and display financial transactions by store, with balance totals. Built with Ruby on Rails 8, PostgreSQL, Docker, RSpec, Rubocop and SimpleCov.

---

## Requirements

- Ruby 3.2+ (or use Docker)
- Rails 8.1+
- PostgreSQL
- Docker and Docker Compose (recommended)

---

## Quick Setup with Docker

```sh
# Build the image
docker-compose build

# Start the containers (web and db)
docker-compose up -d

# Install gems (inside the container)
docker-compose exec web bundle install

# Create and migrate the database
docker-compose exec web bin/rails db:create db:migrate
```

Access: [http://localhost:3000](http://localhost:3000)

---

## How to Use

1. Upload the CNAB.txt file on the main screen.
2. View stores, transactions and balances in "Stores".
3. Use the "Configuration" menu to reset the database (type CONFIRMAR).

---

## Tests and Quality

- **Run tests:**
	```sh
	docker-compose exec web bundle exec rspec
	```
- **Code coverage:**
	- After running tests, open `coverage/index.html` in your browser.
- **Run Rubocop:**
	```sh
	docker-compose exec web bundle exec rubocop -A
	```

---

## API

- **Upload endpoint:** `POST /cnab_files`
- **Stores endpoint:** `GET /stores`
- (Optional: document extra endpoints if you create them)

---

## Project Structure

- `app/models` - Main models: Store, Transaction, CnabFile
- `app/services` - Import logic and CNAB parser
- `app/controllers` - Controllers for upload, stores and configuration
- `spec/` - Automated tests (RSpec)

---

## Notes

- Database reset clears all stores and transactions and restarts IDs.
- The project doesn't use popular CSS frameworks (vanilla CSS only).
- Test coverage >80% (see in `coverage/index.html`).

---

## How to Run Locally (without Docker)

1. Install Ruby, Rails and PostgreSQL.
2. Clone the project and run:
	 ```sh
	 bundle install
	 rails db:create db:migrate
	 rails server
	 ```

---