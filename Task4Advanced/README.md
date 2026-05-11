## Task4Advanced Deliverables

| Файл | Описание |
| --- | --- |
| `bounded-contexts.puml` | Карта доменов Future 2.0 и связи между bounded contexts |
| `event-storming.puml` | Event Storming c основными событиями и реакциями доменов |
| `aggregates.md` | Перечень агрегатов, инвариантов и команд по доменам |
| `events.md` | Каталог доменных событий и их контрактов |
| `justification.md` | Обоснование перехода к событийной архитектуре вместо Camel/DWH |

Главные идеи: доменное владение (Patient Care, Fintech, Pharma, AI), единый поток событий Kafka, Data Mesh как слой публикации дата-продуктов и self-service BI, а также жёсткое управление политиками доступа и качеством данных.

