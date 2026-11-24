# Инструкция. Задание 5 — Scaling: изменить число реплик

**Цель:** научиться масштабировать приложение и увидеть, что Service
подхватывает новые поды автоматически.

**Понадобится:** задания 3–4 выполнены (deployment 3/3, service работает).

---

## Ход работы

### Шаг 1. Исходное состояние

```bash
kubectl get deployment calc-app -n demo
kubectl get pods -n demo
```
Ожидается: `READY 3/3`, три пода.

### Шаг 2. Наблюдение в реальном времени

Откройте **второй терминал** и запустите в нём:
```bash
kubectl get pods -n demo -w
```
Оставьте работать — вы будете видеть все изменения живьём.

### Шаг 3. Масштабирование вверх

В первом терминале:
```bash
kubectl scale deployment calc-app --replicas=5 -n demo
```

Во втором терминале наблюдайте: два новых пода проходят
`Pending → ContainerCreating → Running` за несколько секунд.

```bash
kubectl get deployment calc-app -n demo
```
Ожидается: `READY 5/5`.

### Шаг 4. Service узнал о новых подах сам

```bash
kubectl describe service calc-app -n demo | grep Endpoints
```
Ожидается: **5 адресов** в Endpoints. Вы ничего не меняли в Service —
связь по labels обновилась автоматически.

✔ **Контрольная точка:** можете объяснить, почему Service не пришлось
перенастраивать.

### Шаг 5. Масштабирование вниз

```bash
kubectl scale deployment calc-app --replicas=2 -n demo
```
Во втором терминале: три пода уходят в `Terminating`.

### Шаг 6. Декларативный способ

Откройте `templates/deployment.yaml`, измените `replicas:` на 3
(вернём исходное) и примените:
```bash
kubectl apply -f templates/deployment.yaml
kubectl get deployment calc-app -n demo
```
Ожидается: снова `3/3`.

✔ **Контрольная точка:** вы отмасштабировали двумя способами —
императивным (`scale`) и декларативным (`apply`).

### Шаг 7. Эксперимент: нехватка ресурсов (по желанию)

```bash
kubectl scale deployment calc-app --replicas=50 -n demo
kubectl get pods -n demo | grep Pending | head -3
kubectl describe pod <pending-под> -n demo | grep -A2 Events
```
Ожидается: часть подов в `Pending`, в Events — `Insufficient cpu`.
Верните 3 реплики: `kubectl scale ... --replicas=3`.

---

## Что сдать в отчёте

1. Вывод Endpoints при 5 репликах
2. Ответ: чем императивный `kubectl scale` отличается от декларативного
   `apply`? Какой способ правильный для production и почему?
3. (по эксперименту) что происходит с подами, которым не хватило ресурсов?

## Частые проблемы

| Симптом | Решение |
|---|---|
| Поды Pending после scale | нехватка ресурсов ноды — уменьшите replicas |
| `-w` мешает работать | второй терминал или Ctrl+C и обычный `get pods` |

## Уборка (выполнить в конце занятия, после задания 7)

```bash
kubectl delete namespace demo
```
