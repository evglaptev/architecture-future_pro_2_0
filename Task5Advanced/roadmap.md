## Стратегический roadmap внедрения Data Mesh

| Фаза | Период | Цели | Основные роли | Ключевые результаты |
| --- | --- | --- | --- | --- |
| **Пилот** | 0–6 месяцев | Развернуть общую платформу Kafka + Lakehouse, запустить 2 доменных дата-продукта (Patient Care, Lending), подготовить портал self-service v1 | Data Product Owner, Data Engineer, BI Analyst, Platform Team | Каталог схем, базовые политики доступа, первые события `PatientRegistered` и `CreditContractCreated`, портал умеет строить отчёты для пилотных доменов |
| **Широкий запуск** | 6–18 месяцев | Подключить критичные домены (Diagnostics AI, Pharma Supply, Payments), внедрить Data Quality framework, автоматизировать CI/CD для дата-продуктов | Domain Data Engineers, MLOps, Security Architect | 10+ потоковых витрин, SLA/SLO на каждый продукт, автоматические проверки calidad, включены Feature Store и Trino |
| **Поддержка и масштабирование** | 18–36 месяцев | Вывести Camel/DWH из критического пути, распространить Mesh на новые регионы, внедрить FinOps и chargeback по доменам | Data Platform Lead, FinOps Analyst, Data Steward Council | >80% интеграций через события, self-service BI покрывает все бизнес-направления, отчёты в режиме near-real-time, пониженные TCO |

### Дополнительные вехи

- **Enablement**: ежеквартальные bootcamp для Data Product Owner и Data Engineers, проверка навыков.
- **Governance**: запуск Data Steward Council к 3 месяцу, автоматический контроль политик через OPA к 12 месяцу.
- **FinOps**: к 24 месяцу внедрить chargeback по фактическому потреблению ресурсов доменами.

