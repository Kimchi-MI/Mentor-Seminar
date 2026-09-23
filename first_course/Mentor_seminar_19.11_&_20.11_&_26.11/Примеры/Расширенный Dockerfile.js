# Базовый образ Nodejs
FROM node:22 AS app_base

# Метаданные
LABEL maintainer="student@example.com"
LABEL project="demo-app"

# Аргументы для сборки (передаются через docker build --build-arg)
ARG APP_VERSION=1.0.0
ARG NODE_ENV=production

# Переменные окружения
ENV APP_VERSION=$APP_VERSION
ENV NODE_ENV=$NODE_ENV
ENV PORT=3000

# Рабочая директория
WORKDIR /usr/src/app

# Устанавливаем зависимости
COPY package*.json ./
RUN npm install --production

# Копируем исходники
COPY . .

# Монтируемая директория
VOLUME /usr/src/app/logs

# Пользователь (не root)
RUN useradd --create-home appuser
USER appuser

# Открытый порт
EXPOSE 3000

# EntryPoint + CMD
ENTRYPOINT ["node"]
CMD ["server.js"]

# Проверка здоровья контейнера
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
