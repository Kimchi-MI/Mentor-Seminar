# Инструкция. Задание 3 — Deployment: управляемое приложение

**Цель:** перейти от голого пода к управляемому workload и увидеть
иерархию Deployment → ReplicaSet → Pod.

**Понадобится:** задание 2, шаблон `templates/deployment.yaml`.

---

## Ход работы

### Шаг 1. Создание namespace

```bash
kubectl create namespace demo
kubectl get namespaces
```
Ожидается: в списке появился `demo`.

### Шаг 2. Заполнение шаблона Deployment

Откройте `templates/deployment.yaml` и заполните все `<ВПИШИТЕ ...>`.
Обратите внимание на комментарии в файле — особенно про совпадение
`selector.matchLabels` и `template.metadata.labels`.

Проверка перед применением:
```bash
kubectl apply -f templates/deployment.yaml --dry-run=client -o yaml
```

### Шаг 3. Применение и наблюдение за rollout

```bash
kubectl apply -f templates/deployment.yaml
kubectl rollout status deployment/calc-app -n demo
```
Ожидается:
```
Waiting for deployment "calc-app" rollout to finish: 0 of 3 updated replicas...
Waiting for deployment "calc-app" rollout to finish: 1 of 3 ...
Waiting for deployment "calc-app" rollout to finish: 2 of 3 ...
deployment "calc-app" successfully rolled out
```

### Шаг 4. Иерархия объектов

```bash
kubectl get all -n demo
```
Ожидается — deployment 3/3, один replicaset, три пода:
```
NAME                       READY   UP-TO-DATE   AVAILABLE
deployment.apps/calc-app   3/3     3            3

NAME                                  DESIRED   CURRENT   READY
replicasets.apps/calc-app-6f4d77fd6   3         3         3

NAME                            READY   STATUS
pod/calc-app-6f4d77fd6-aaaaa    1/1     Running
pod/calc-app-6f4d77fd6-bbbbb    1/1     Running
pod/calc-app-6f4d77fd6-ccccc    1/1     Running
```
Разберите имена подов: `<deployment>-<хэш ReplicaSet>-<хэш пода>`.
Запишите в отчёт, кто кем управляет.

✔ **Контрольная точка:** READY `3/3`, можете показать цепочку
Deployment → ReplicaSet → Pod по именам объектов.

### Шаг 5. Обновление и откат

Симулируем выход новой версии приложения:
```bash
docker tag calc-app:v1 calc-app:v2        # "собрали" версию v2
minikube image load calc-app:v2
kubectl set image deployment/calc-app calc-app=calc-app:v2 -n demo
kubectl rollout status deployment/calc-app -n demo
```
Ожидается: поды по очереди пересоздаются с новым образом (rolling update),
в конце `successfully rolled out`.

```bash
kubectl rollout history deployment/calc-app -n demo
```
Ожидается: две ревизии (№1 — v1, №2 — v2).

```bash
kubectl rollout undo deployment/calc-app -n demo
kubectl rollout status deployment/calc-app -n demo
```
Ожидается: откат на ревизию 1, `successfully rolled out`.

✔ **Контрольная точка:** в `rollout history` две ревизии,
откат выполнен успешно.

---

## Что сдать в отчёте

1. Вывод `kubectl get all -n demo`
2. Скриншот/вывод `rollout history` с двумя ревизиями
3. Ответ: зачем нужен промежуточный ReplicaSet между Deployment и Pod?

## Частые проблемы

| Симптом | Решение |
|---|---|
| `error: selector does not match template labels` | selector и labels шаблона различаются — исправьте на одинаковые |
| `NotFound` при командах | забыли `-n demo` |
| Поды в ImagePullBackOff | вернитесь к заданию 2: image load + Never |
