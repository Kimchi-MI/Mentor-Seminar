# Инструкция. Задание 1 — Кластер: поднять и исследовать Kubernetes

**Цель:** получить работающий локальный кластер и освоить базовые команды kubectl.

**Понадобится:** выполненное [задание 0](00-setup.md) (Docker, kubectl, minikube установлены).

---

## Ход работы

### Шаг 1. Запуск кластера

```bash
minikube start --driver=docker
```

Ожидаемый вывод (в конце):
```
* Готово! kubectl настроен для использования кластера "minikube"
```
Первая загрузка — 5–10 минут (скачивается ~500 МБ). Это нормально.

### Шаг 2. Проверка связи с кластером

```bash
kubectl cluster-info
```
Ожидается:
```
Kubernetes control plane is running at https://127.0.0.1:xxxxx
CoreDNS is running at https://...
```

```bash
kubectl get nodes
```
Ожидается:
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   1m    v1.37.0
```

✔ **Контрольная точка:** статус узла — `Ready`.

### Шаг 3. Исследование узла

```bash
kubectl get nodes -o wide
kubectl describe node minikube | head -30
```

Найдите в выводе describe и запишите в отчёт:
- версию Kubernetes и container runtime
- Capacity: сколько CPU и памяти у ноды
- секцию Conditions — какие проверки здоровья проходит нода

### Шаг 4. Что уже работает в кластере

```bash
kubectl get namespaces
kubectl get pods -A
```

Ожидается — системные поды в статусе Running:
```
kube-system   coredns-...
kube-system   etcd-minikube
kube-system   kube-apiserver-minikube
kube-system   kube-controller-manager-minikube
kube-system   kube-proxy-...
kube-system   kube-scheduler-minikube
```

✔ **Контрольная точка:** вы нашли все четыре компонента control plane
(apiserver, etcd, scheduler, controller-manager) среди подов.

### Шаг 5. Дашборд (по желанию)

```bash
minikube dashboard
```
Откроется веб-интерфейс кластера. Осмотритесь и закройте (Ctrl+C).

---

## Что сдать в отчёте

1. Вывод `kubectl get nodes -o wide`
2. Список системных подов из `kubectl get pods -A`
3. Ответ: сколько нод в вашем кластере и почему именно столько?

## Частые проблемы

| Симптом | Решение |
|---|---|
| `Exiting due to ... docker not running` | запустите Docker: `colima start` |
| `kubectl: command not found` | `brew install kubectl` |
| Кластер стартует очень долго | нехватка ресурсов Docker VM: 4 CPU / 6 ГБ |
