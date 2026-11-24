# Инструкция. Задание 2 — Pod: запустить приложение

**Цель:** запустить первый под, исследовать его и понять, почему «голый» под —
это ещё не production.

**Понадобится:** работающий кластер (задание 1), шаблон `templates/pod.yaml`.

---

## Ход работы

### Шаг 1. Сборка и загрузка образа

```bash
# выполняйте из корня репозитория (там лежат app/ и templates/)
docker build -t calc-app:v1 app/
minikube image load calc-app:v1
```

Ожидается: загрузка завершилась без ошибок.

### Шаг 2. Запуск пода

```bash
kubectl run calc-pod --image=calc-app:v1 --image-pull-policy=Never --port=5000
kubectl get pods -w
```
Наблюдайте смену статусов: `Pending → ContainerCreating → Running`.
Выйдите из наблюдения: `Ctrl+C`.

```bash
kubectl get pods -o wide
```
Ожидается:
```
NAME       READY   STATUS    RESTARTS   AGE   IP           NODE
calc-pod   1/1     Running   0          30s   10.244.0.3   minikube
```
Запишите в отчёт IP пода — он пригодится позже.

✔ **Контрольная точка:** под в статусе `Running`, READY `1/1`.

### Шаг 3. Диагностика пода

```bash
kubectl describe pod calc-pod
```
Найдите секцию **Events** внизу: `Scheduled → Pulled → Created → Started`.
Это хронология создания пода.

```bash
kubectl logs calc-pod
```
Ожидается: лог запуска Flask (`Running on http://0.0.0.0:5000`).

```bash
kubectl exec -it calc-pod -- /bin/sh
```
Вы внутри контейнера. Выполните `ls`, посмотрите файлы приложения,
выйдите: `exit`.

### Шаг 4. Проверка работы приложения

```bash
kubectl port-forward calc-pod 5000:5000 &
curl "http://localhost:5000/calc?op=mul&a=6&b=7"
curl http://localhost:5000/health
kill %1
```
Ожидается:
```
{"result":42.0}
{"status":"ok"}
```

✔ **Контрольная точка:** приложение отвечает через port-forward.

### Шаг 5. Заполнение шаблона манифеста

Откройте `templates/pod.yaml`, заполните все места `<ВПИШИТЕ ...>`.
Проверьте до применения:
```bash
kubectl apply -f templates/pod.yaml --dry-run=client -o yaml
```

### Шаг 6. Удаление пода

```bash
kubectl delete pod calc-pod
kubectl get pods
```
Ожидается: список пуст. **Под не восстановился** — за голым подом
никто не следит. Это главный вывод задания.

---

## Что сдать в отчёте

1. Вывод `kubectl get pods -o wide` с работающим подом
2. Ответ приложения на `/calc?op=mul&a=6&b=7`
3. Ответ: почему после удаления под не восстановился?

## Частые проблемы

| Симптом | Решение |
|---|---|
| `ImagePullBackOff` в describe | нет `minikube image load` или `imagePullPolicy` не `Never` |
| `CrashLoopBackOff` | смотрите `kubectl logs calc-pod` |
| port-forward занят | другой процесс держит 5000: `kill %1` / `docker ps` |
