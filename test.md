### 5. Формирование исходящего запроса

Хаб создаёт новый HTTP-запрос в целевую систему:

- **URL:** `targetUrl` из конфигурации интеграции
- **HTTP-метод:** `targetMethod`
- **Тело:** исходное тело запроса системы-источника (без изменений)
- **Заголовки:** извлечённые на шаге 4
- **Параметры запроса:** см. раздел [Работа с параметрами запроса](#51-работа-с-параметрами-запроса)

#### 5.1. Работа с параметрами запроса

Integration Hub поддерживает работу как со статическими, так и с динамическими параметрами в `incomingPath` и `targetUrl`. Это позволяет гибко маршрутизировать запросы и передавать значения из пути входящего запроса в целевую систему.

##### Типы параметров

**1. Статические параметры**

Параметры с фиксированным значением, указанные непосредственно в `targetUrl`. Они всегда передаются в целевую систему без изменений.

**Пример:**
targetUrl: https://api.example.com/v1/invoice?format=json&version=2

Итоговый URL всегда будет содержать:
?format=json&version=2


**2. Динамические параметры**

Параметры, значения которых извлекаются из `incomingPath` и подставляются в `targetUrl`. Обозначаются фигурными скобками `{}`.

**Пример:**
incomingPath: /issues/{id}
targetUrl: https://api.example.com/tickets/{id}

Запрос: GET /issues/123
Итоговый URL: https://api.example.com/tickets/123


##### Механизм работы с динамическими параметрами

**Шаг 1. Извлечение значений из `incomingPath`**

Хаб анализирует фактический путь входящего запроса и извлекает значения, которые соответствуют динамическим параметрам (обозначенным в фигурных скобках `{}`).

**Пример:**
Конфигурация интеграции:
incomingPath: /requests/source/target/issues/{issueId}/statuses/{statusId}

Фактический запрос:
GET /requests/source/target/issues/123/statuses/456

Извлечённые значения:
{
issueId: "123",
statusId: "456"
}

**Шаг 2. Поиск переменных в `targetUrl`**

Хаб находит все динамические параметры в `targetUrl` (также обозначенные в фигурных скобках `{}`). Поиск выполняется как в пути, так и в query-параметрах.

**Пример:**
targetUrl: https://api.example.com/issues/{issueId}/statuses/{statusId}?mode={mode}

Найденные переменные:
[ "issueId", "statusId", "mode" ]


**Шаг 3. Подстановка значений**

Хаб сопоставляет имена переменных из `targetUrl` со значениями, извлечёнными из `incomingPath`, и формирует итоговый URL.

**Пример:**
Извлечённые значения: { issueId: "123", statusId: "456" }
targetUrl: https://api.example.com/issues/{issueId}/statuses/{statusId}

Итоговый URL:
https://api.example.com/issues/123/statuses/456


**Шаг 4. Формирование query-параметров**

В целевую систему отправляются только те query-параметры, которые указаны в `targetUrl`. Механизм динамической подстановки для query-параметров идентичен механизму для параметров пути.

**Пример с динамическим query-параметром:**
Конфигурация:
incomingPath: /issues/{id}?source={source}
targetUrl: https://api.example.com/tickets/{id}?status=active&mode={mode}

Фактический запрос:
GET /issues/123?source=okdesk

Извлечённые значения: { id: "123", source: "okdesk" }

Итоговый URL:
https://api.example.com/tickets/123?status=active&mode={mode}


**Пример с полной подстановкой:**
Конфигурация:
incomingPath: /orders/{orderId}?status={status}&source={source}
targetUrl: https://api.example.com/purchases/{orderId}?mode=test&status={status}

Фактический запрос:
GET /orders/123?status=completed&source=okdesk

Извлечённые значения: { orderId: "123", status: "completed", source: "okdesk" }

Итоговый URL:
https://api.example.com/purchases/123?mode=test&status=completed

**Обратите внимание:**
- Query-параметр `source=okdesk` из `incomingPath` **не попал** в итоговый URL, потому что он не указан в `targetUrl`
- Query-параметр `status=completed` из `incomingPath` **подставлен** в `targetUrl`, потому что он там указан как `{status}`
- Query-параметр `mode=test` из `targetUrl` **сохранён** как статический