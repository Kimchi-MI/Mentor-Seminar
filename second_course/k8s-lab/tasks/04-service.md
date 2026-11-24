# Инструкция. Задание 4 — Service: стабильный доступ

**Цель:** дать приложению стабильный адрес, независимый от жизни подов,
и проверить доступ изнутри и снаружи кластера.

**Понадобится:** задание 3 выполнено (deployment 3/3), шаблон `templates/service.yaml`.

---

## Ход работы

### Шаг 1. Осмотритесь: чем плохи IP подов

```bash
kubectl get pods -n demo -o wide
```
Запишите IP подов. Эти адреса **временные**: при пересоздании пода
(задание 6) они изменятся. На них нельзя полагаться.

### Шаг 2. Заполнение шаблона Service

Откройте `templates/service.yaml` и заполните `<ВПИШИТЕ ...>`.
Главное — `selector`: он должен совпадать с labels подов из вашего
deployment (см. комментарий в шаблоне).

```bash
kubectl apply -f templates/service.yaml
kubectl get services -n demo
```
Ожидается:
```
NAME       TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
calc-app   NodePort   10.96.x.x      <none>        5000:30500/TCP   5s
```

### Шаг 3. Проверка связи Service → Pod

```bash
kubectl describe service calc-app -n demo
```
Найдите строку **Endpoints** — там должны быть IP всех трёх подов
(те самые из шага 1). Если пусто — selector не совпал с labels подов.

✔ **Контрольная точка:** Endpoints содержит 3 адреса.

### Шаг 4. Доступ изнутри кластера (ClusterIP + DNS)

```bash
kubectl run curl-test --image=curlimages/curl --rm -it --restart=Never -- sh
```
Внутри тестового пода:
```bash
curl "http://calc-app.demo:5000/calc?op=add&a=2&b=3"
exit
```
Ожидается: `{"result":5.0}`.

Обратите внимание: мы обратились по **DNS-имени** `calc-app.demo`
(`<сервис>.<namespace>`), а не по IP.

✔ **Контрольная точка:** ответ по DNS-имени изнутри кластера.

### Шаг 5. Доступ снаружи (NodePort)

```bash
minikube service calc-app -n demo
```
Откроется браузер. **На macOS с docker-драйвером команда держит туннель
и занимает терминал — не закрывайте её.** В другом терминале:
```bash
curl "http://127.0.0.1:<порт-из-вывода>/calc?op=mul&a=6&b=7"
```

Альтернатива без туннеля:
```bash
kubectl port-forward svc/calc-app -n demo 5000:5000 &
curl "http://localhost:5000/health"
kill %1
```

### Шаг 6. Балансировка

```bash
kubectl logs -n demo -l app=calc-app --tail=3 --prefix=true
```
Выполните несколько curl'ов и посмотрите логи ещё раз: по префиксам
`[pod/calc-app-...]` видно, что запросы попадают на **разные** поды.

---

## Что сдать в отчёте

1. Вывод `kubectl get services -n demo` и строку Endpoints из describe
2. Ответ `curl` по DNS-имени из тестового пода
3. Ответ: как Service узнаёт, какие поды живы? (подсказка: selector, Endpoints)

## Частые проблемы

| Симптом | Решение |
|---|---|
| Endpoints пуст | selector сервиса ≠ labels подов в deployment |
| `minikube service` «завис» | это туннель, не баг; curl — из другого терминала |
| DNS не резолвится в тестовом поде | имя должно быть `<svc>.<namespace>`; проверьте `kubectl get svc -n demo` |
