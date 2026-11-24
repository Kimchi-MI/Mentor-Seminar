# Инструкция. Задание 0 — Установка и настройка окружения

**Цель:** установить и проверить все инструменты: Docker, kubectl, minikube.

---

## Что мы ставим и зачем

| Инструмент | Зачем |
|---|---|
| Docker | container runtime — внутри него будет жить наш кластер |
| kubectl | CLI для управления Kubernetes |
| minikube | локальный Kubernetes-кластер в одном контейнере |

---

## macOS

```bash
brew install colima docker docker-compose kubectl minikube
colima start --cpu 4 --memory 6
```

Проверка:
```bash
docker version          # Client и Server без ошибок
kubectl version --client
minikube version
colima status           # Running
```

## Linux (Ubuntu/Debian)

```bash
# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER   # перелогиниться после этого!

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl

# minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

## Windows

- Docker Desktop: https://www.docker.com/products/docker-desktop/
- kubectl и minikube: через `winget install Kubernetes.kubectl`
  и `winget install minikube`, либо по инструкциям с официальных сайтов
- Альтернатива minikube: включить встроенный Kubernetes в Docker Desktop
  (Settings → Kubernetes → Enable)

---

## Проверка: поднимаем кластер

```bash
minikube start --driver=docker
```

Первая загрузка — 5–10 минут (скачивается ~500 МБ), это нормально.
Ожидаемый финал:
```
* Готово! kubectl настроен для использования кластера "minikube"
```

```bash
kubectl get nodes
```
Ожидается:
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   1m    v1.37.0
```

## Финальная проверка: приложение

Из корня репозитория:
```bash
docker build -t calc-app:v1 app/
minikube image load calc-app:v1
```

Если образ собрался и загрузился — вы полностью готовы к занятию.

---

## Что сдать

Скриншот вывода `kubectl get nodes` со статусом `Ready`.

## Частые проблемы

| Симптом | Решение |
|---|---|
| `docker: command not found` после установки | перезапустите терминал |
| `Cannot connect to the Docker daemon` | `colima start` (macOS) / запустите Docker Desktop |
| minikube не стартует, таймауты | мало ресурсов: `colima stop && colima start --cpu 4 --memory 6` |
| `kubectl get nodes` — connection refused | `minikube status` — кластер не поднят; `minikube start` |
| медленная загрузка образа | нормально при первом запуске; проверьте интернет |

## В конце занятия / если что-то пошло не так

```bash
minikube stop       # выключить кластер (состояние сохранится)
minikube delete     # удалить кластер полностью (начать с чистого листа)
```
