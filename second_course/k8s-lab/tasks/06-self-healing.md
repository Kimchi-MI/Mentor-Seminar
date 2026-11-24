# Инструкция. Задание 6 — Self-healing: самовосстановление

**Цель:** убедиться, что контроллеры Kubernetes сами возвращают кластер
к желаемому состоянию — на двух уровнях: под и контейнер.

**Понадобится:** задания 3–5 выполнены (deployment 3/3).

---

## Ход работы

### Шаг 1. Подготовка наблюдения

Откройте **второй терминал** и запустите в нём:
```bash
kubectl get pods -n demo -w
```

### Шаг 2. Удаляем под (симуляция потери пода)

В первом терминале:
```bash
kubectl get pods -n demo                    # выберите имя любого пода
kubectl delete pod <имя-пода> -n demo
```

Во втором терминале сразу видно, как под уходит в `Terminating`,
а ReplicaSet создаёт новый: `Pending → ContainerCreating → Running`.

```bash
kubectl get pods -n demo
```
Ожидается: снова 3 пода Running, но у нового пода **другое имя и другой IP**.

✔ **Контрольная точка:** под пересоздан автоматически, без вашего участия.

### Шаг 3. «Падает» процесс в контейнере (симуляция сбоя приложения)

Запустим рядом демо-под, чьё приложение падает через 3 секунды после старта:
```bash
kubectl run crash-demo --image=python:3.12-slim --restart=Always -n demo -- \
  python3 -c "import time; time.sleep(3); exit(1)"
```

Подождите ~30 секунд и смотрите:
```bash
kubectl get pods -n demo
```
Ожидается:
```
crash-demo   0/1   Error     3 (50s ago)   71s
```
Колонка **RESTARTS** растёт: kubelet снова и снова перезапускает упавший
контейнер. Статус перейдёт в `CrashLoopBackOff` — это нарастающая пауза
между перезапусками (backoff), а не поломка кластера.

> Почему не `kill 1` внутри пода приложения? Процесс с PID 1 в контейнере
> защищён ядром от сигналов изнутри — отдельный падающий под показывает
> тот же механизм restartPolicy надёжнее.

Уберите демо-под:
```bash
kubectl delete pod crash-demo -n demo
```

✔ **Контрольная точка:** вы видите разницу двух механизмов:
пересоздание пода (ReplicaSet, шаг 2) vs перезапуск контейнера
(kubelet + restartPolicy, шаг 3).

### Шаг 4. Хронология событий

```bash
kubectl get events -n demo --sort-by=.lastTimestamp | tail -10
```
Найдите события ваших экспериментов: `Killing`, `Scheduled`, `Created`,
`Started`, `BackOff`.

### Шаг 5. Граница самовосстановления

```bash
kubectl delete deployment calc-app -n demo
kubectl get pods -n demo
```
Ожидается: поды удаляются и **не восстанавливаются** — желаемое
состояние теперь «нет deployment». Kubernetes восстанавливает не
«всё подряд», а именно desired state.

Верните приложение:
```bash
kubectl apply -f templates/deployment.yaml
kubectl rollout status deployment/calc-app -n demo
```

---

## Что сдать в отчёте

1. Скриншот терминала с `-w` в момент пересоздания пода
2. Вывод `kubectl get pods` с растущим RESTARTS у crash-demo
3. Ответы: кто восстанавливает под, а кто — контейнер?
   Почему после удаления deployment ничего не восстановилось?

## Частые проблемы

| Симптом | Решение |
|---|---|
| crash-demo не появляется | проверьте `kubectl describe pod crash-demo -n demo` |
| Под не пересоздался | удалили «голый» под из задания 2, а не под deployment'а |
