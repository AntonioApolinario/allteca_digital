bash
cat > README.md << 'EOF'
# 📚 Biblioteca Digital API

Uma API RESTful e GraphQL completa para gerenciamento de biblioteca digital com autenticação JWT.

## 🚀 Começando Rápido

### Pré-requisitos
- Docker e Docker Compose
- Git

### Instalação e Execução

```bash
git clone <url-do-repositorio>
cd backend
docker compose up --build -d
docker compose exec app rails db:create db:migrate
Acesse: http://localhost:3001

🛠 Comandos do Sistema
Gerenciamento de Containers
bash
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f app
docker compose restart app
docker compose down -v
docker compose build --no-cache
Banco de Dados
bash
docker compose exec app rails db:create db:migrate
docker compose exec app rails db:migrate
docker compose exec app rails db:rollback
docker compose exec app rails db:reset
docker compose exec app rails db:migrate:status
docker compose exec app rails db:seed
docker compose exec db psql -U postgres -d biblioteca_digital_development
Testes
bash
docker compose exec app bundle exec rspec
docker compose exec app bundle exec rspec spec/models
docker compose exec app bundle exec rspec spec/controllers
docker compose exec app bundle exec rspec spec/requests
docker compose exec app bundle exec rspec spec/policies
docker compose exec app bundle exec rspec --format documentation
docker compose exec app COVERAGE=true bundle exec rspec
Desenvolvimento
bash
docker compose exec app rails console
docker compose exec app rails console --sandbox
docker compose exec app rails routes
docker compose exec app rails routes | grep materials
docker compose exec app bundle install
docker compose exec app bundle update
docker compose exec app bundle exec rubocop
docker compose exec app bundle exec brakeman
🔐 Como Usar a API
Autenticação
Login:

bash
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "auth": {
      "email": "usuario@exemplo.com",
      "password": "senha123"
    }
  }'
Verificar usuário:

bash
curl -X GET http://localhost:3001/api/v1/auth/me \
  -H "Authorization: Bearer <seu-token>"
Gerenciar Autores
Listar autores:

bash
curl http://localhost:3001/api/v1/authors
Criar autor pessoa:

bash
curl -X POST http://localhost:3001/api/v1/authors \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "author": {
      "type": "Person",
      "name": "Machado de Assis",
      "birth_date": "1839-06-21"
    }
  }'
Criar autor instituição:

bash
curl -X POST http://localhost:3001/api/v1/authors \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "author": {
      "type": "Institution", 
      "name": "Universidade de São Paulo",
      "city": "São Paulo"
    }
  }'
Gerenciar Materiais
Listar materiais:

bash
curl http://localhost:3001/api/v1/materials
Buscar materiais:

bash
curl "http://localhost:3001/api/v1/materials/search?q=programming"
Criar livro:

bash
curl -X POST http://localhost:3001/api/v1/materials \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "material": {
      "type": "Book",
      "title": "Dom Casmurro",
      "description": "Romance clássico brasileiro",
      "status": "publicado",
      "author_id": 1,
      "isbn": "9788535902771",
      "page_count": 256
    }
  }'
Criar artigo:

bash
curl -X POST http://localhost:3001/api/v1/materials \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "material": {
      "type": "Article",
      "title": "Ciência de Dados Aplicada",
      "description": "Artigo sobre data science",
      "status": "publicado",
      "author_id": 1,
      "doi": "10.1000/xyz123"
    }
  }'
Criar vídeo:

bash
curl -X POST http://localhost:3001/api/v1/materials \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "material": {
      "type": "Video", 
      "title": "Tutorial Ruby on Rails",
      "description": "Vídeo tutorial completo",
      "status": "publicado",
      "author_id": 1,
      "duration_minutes": 45
    }
  }'
Buscar Livro por ISBN
bash
curl -X POST http://localhost:3001/api/v1/books/isbn \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "isbn": "9788535902771",
    "author_id": 1
  }'
🔮 GraphQL
Acesse: http://localhost:3001/graphql

Queries
Listar materiais:

graphql
query {
  materials {
    edges {
      node {
        id
        title
        status
        author {
          name
        }
      }
    }
  }
}
Buscar materiais:

graphql
query {
  materials(search: "programming", status: "publicado") {
    edges {
      node {
        title
        description  
        specificAttributes
      }
    }
  }
}
Informações do usuário:

graphql
query {
  me {
    email
    materialsCount
  }
}
Mutations
Criar material:

graphql
mutation {
  createMaterial(input: {
    type: "Book"
    title: "Novo Livro"
    status: "rascunho" 
    authorId: 1
    isbn: "9781234567897"
    pageCount: 300
  }) {
    id
    title
  }
}
Criar autor:

graphql
mutation {
  createAuthor(input: {
    type: "Person"
    name: "Novo Autor"
    birthDate: "1980-01-01"
  }) {
    id
    name
    type
  }
}
🗃 Estrutura do Banco
Tabelas Principais
users

id, email, encrypted_password, created_at, updated_at

authors (STI)

id, type (Person/Institution), name, birth_date, city, created_at, updated_at

materials (STI)

id, type (Book/Article/Video), title, description, status, user_id, author_id, isbn, page_count, doi, duration_minutes, created_at, updated_at

📊 Endpoints Disponíveis
REST API
GET /api/v1/materials - Listar materiais

GET /api/v1/materials/search - Buscar materiais

POST /api/v1/materials - Criar material

GET /api/v1/materials/:id - Ver material

PUT /api/v1/materials/:id - Atualizar material

DELETE /api/v1/materials/:id - Excluir material

GET /api/v1/authors - Listar autores

POST /api/v1/authors - Criar autor

POST /api/v1/books/isbn - Criar livro por ISBN

POST /api/v1/auth/login - Login

GET /api/v1/auth/me - Informações do usuário

GraphQL
Queries: materials, material, authors, author, me

Mutations: createMaterial, updateMaterial, deleteMaterial, createAuthor

🐛 Solução de Problemas
Erros Comuns
Container não inicia:

bash
docker compose logs app
docker compose build --no-cache
Porta ocupada:

bash
sudo lsof -i :3001
# Ou edite docker-compose.yml para usar outra porta
Erro de banco:

bash
docker compose exec app rails db:reset
docker compose down -v
docker compose up --build -d
Token JWT inválido:

bash
# Verifique a chave secreta
docker compose exec app rails runner "puts ENV['DEVISE_JWT_SECRET_KEY']"
🚀 Deploy em Produção
Variáveis de Ambiente
bash
DATABASE_URL=postgresql://user:pass@host:5432/dbname
DEVISE_JWT_SECRET_KEY=chave-super-secreta
RAILS_ENV=production
RAILS_MASTER_KEY=chave-master-rails
Comandos de Deploy
bash
bundle install
rails db:migrate
rails assets:precompile
bundle exec rails server -p $PORT
📞 Suporte
Logs da aplicação:

bash
docker compose logs -f app
Health check:

bash
curl http://localhost:3001/up
Testar banco:

bash
docker compose exec app rails runner "puts ActiveRecord::Base.connection.active?"
✨ Sistema pronto para uso! Acesse http://localhost:3001/api-docs para documentação interativa completa.
