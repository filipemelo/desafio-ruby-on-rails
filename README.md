## Documentação da API

### Upload de arquivo CNAB

**Endpoint:** `POST /cnab_files`

**Parâmetros:**
- `cnab_file[file]` (arquivo CNAB, obrigatório)

**Exemplo usando curl:**
```sh
curl -X POST \
	-F "cnab_file[file]=@CNAB.txt" \
	http://localhost:3000/cnab_files
```

**Resposta (redirect):**
- HTTP 302 para `/stores` em caso de sucesso
- HTTP 422 com mensagem de erro em caso de falha

---

### Listar lojas e transações (HTML)

**Endpoint:** `GET /stores`

**Resposta:**
- Página HTML com todas as lojas, donos, saldo e transações importadas

---

### (Opcional) Listar lojas e transações (JSON)

Se desejar expor um endpoint JSON, adicione ao `StoresController`:

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

**Exemplo de resposta:**
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
				"description": "Débito",
				"nature": "Entrada"
			}
		]
	}
]
```

---
---

## Como consumir a API

### Upload de arquivo CNAB

**Endpoint:** `POST /cnab_files`

**Exemplo usando curl:**

```sh
curl -X POST \
	-F "cnab_file[file]=@CNAB.txt" \
	http://localhost:3000/cnab_files
```

### Listar lojas e transações

**Endpoint:** `GET /stores`

Retorna a página HTML com as lojas e transações importadas. Para uma API JSON, seria necessário criar um endpoint adicional.

---
# Desafio Ruby on Rails - CNAB Bycoders_

## Descrição

Aplicação web para importar arquivos CNAB, normalizar e exibir transações financeiras por loja, com totalizador de saldo. Feito em Ruby on Rails 8, PostgreSQL, Docker, RSpec, Rubocop e SimpleCov.

---

## Requisitos

- Ruby 3.2+ (ou use Docker)
- Rails 8.1+
- PostgreSQL
- Docker e Docker Compose (recomendado)

---

## Setup rápido com Docker

```sh
# Build da imagem
docker-compose build

# Suba os containers (web e db)
docker-compose up -d

# Instale as gems (dentro do container)
docker-compose exec web bundle install

# Crie e migre o banco de dados
docker-compose exec web bin/rails db:create db:migrate
```

Acesse: [http://localhost:3000](http://localhost:3000)

---

## Como usar

1. Faça upload do arquivo CNAB.txt na tela principal.
2. Veja as lojas, transações e saldos em "Stores".
3. Use o menu "Configuration" para resetar o banco (digite CONFIRMAR).

---

## Testes e qualidade

- **Rodar testes:**
	```sh
	docker-compose exec web bundle exec rspec
	```
- **Cobertura de código:**
	- Após rodar os testes, abra `coverage/index.html` no navegador.
- **Rodar Rubocop:**
	```sh
	docker-compose exec web bundle exec rubocop -A
	```

---

## API

- **Endpoint para upload:** `POST /cnab_files`
- **Endpoint para lojas:** `GET /stores`
- (Opcional: documente endpoints extras se criar)

---

## Estrutura do projeto

- `app/models` - Models principais: Store, Transaction, CnabFile
- `app/services` - Lógica de importação e parser CNAB
- `app/controllers` - Controllers para upload, stores e configuração
- `spec/` - Testes automatizados (RSpec)

---

## Observações

- O reset do banco limpa todas as lojas e transações e reinicia os IDs.
- O projeto não usa frameworks de CSS populares (apenas CSS vanilla).
- Cobertura de testes >80% (veja em `coverage/index.html`).

---

## Como rodar localmente (sem Docker)

1. Instale Ruby, Rails e PostgreSQL.
2. Clone o projeto e rode:
	 ```sh
	 bundle install
	 rails db:create db:migrate
	 rails server
	 ```

---