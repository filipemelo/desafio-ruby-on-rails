FROM ruby:3.2

# Instala dependências do sistema para Rails e PostgreSQL
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Instala bundler
RUN gem install bundler

# Expõe porta 3000
EXPOSE 3000