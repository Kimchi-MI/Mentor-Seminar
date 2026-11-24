# Инструкция. Задание 7 — Разбор и закрепление

**Цель:** собрать всю картину блока и убедиться, что команды «в руках».

---

## Ход работы

### Шаг 1. Цепочка «от YAML до ответа»

Объясните вслух (себе, соседу или преподавателю) каждое звено:

```
deployment.yaml → kubectl apply → API server → etcd (desired state)
→ scheduler → kubelet → container runtime → Pod Running
→ Service (selector) → Endpoints → curl → {"result": 42.0}
```

Загнулись на каком-то звене — вернитесь к соответствующему заданию.

### Шаг 2. Блиц-опрос

Ответьте письменно (в отчёт), не подглядывая:

1. Чем Pod отличается от контейнера?
2. Зачем нужен ReplicaSet, если есть Deployment?
3. Почему нельзя обращаться к подам напрямую по IP?
4. Что такое desired state и кто его поддерживает?
5. Что изолирует namespace, а что — нет?
6. Под не стартует. Назовите три команды диагностики.

### Шаг 3. Практический чек-лист

Выполните каждую команду **без подглядывания в инструкции**
(приложение снова должно быть развёрнуто; если нет —
`kubectl apply -f templates/deployment.yaml -f templates/service.yaml`):

```
 1. kubectl get nodes
 2. kubectl run ... --image=calc-app:v1        # под быстрой командой
 3. kubectl apply -f templates/deployment.yaml
 4. kubectl get pods -n demo -w                # наблюдение
 5. kubectl describe pod ...                   # диагностика
 6. kubectl logs ...                           # логи
 7. kubectl exec -it ... -- sh                 # внутрь контейнера
 8. kubectl port-forward ...                   # доступ к поду/сервису
 9. kubectl apply -f templates/service.yaml
10. kubectl scale deployment ... --replicas=N
11. kubectl delete pod ...                     # self-healing в действии
12. kubectl rollout status / history           # состояние и история
```

Отметьте в отчёте, сколько команд выполнили без подсказок: ___ из 12.

### Шаг 4. Уборка

```bash
kubectl delete namespace demo
kubectl get all -n demo      # No resources found — всё удалено одной командой
```

---

## Что сдать в отчёте

1. Ответы на шесть блиц-вопросов
2. Результат чек-листа (N из 12)
3. Заполненный бланк `templates/lab-report.md` целиком

## Домашнее задание (по желанию, на дополнительный балл)

1. Добавьте в deployment контейнеру:
   ```yaml
   resources:
     requests: {cpu: 100m, memory: 64Mi}
     limits:   {cpu: 200m, memory: 128Mi}
   ```
   Что меняется при scheduling? (подсказка: `kubectl describe node`)
2. Добавьте `livenessProbe` (httpGet на `/health`, порт 5000) и
   объясните, что она даёт сверх restartPolicy.
3. Переведите приложение в namespace `production`. Что придётся
   поменять в манифестах и командах?
