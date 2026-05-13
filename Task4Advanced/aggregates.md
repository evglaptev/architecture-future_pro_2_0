| Домен | Агрегат | Границы и инварианты | Ключевые команды/события |
| --- | --- | --- | --- |
| Patient Care | `PatientProfile` | Один профиль на клиента, содержит статусы согласий, документы; инвариант — изменения фиксируются через версионирование и нельзя удалить активные consent | `RegisterPatient`, `UpdateConsent`, события `PatientRegistered`, `ConsentUpdated` |
| Patient Care | `TherapyCase` | Связан с профилем, включает эпизоды лечения, назначенные услуги, сметы; нельзя закрыть кейс пока есть незакрытые услуги | `OpenClinicalCase`, `AttachObservation`, `CloseCase`; события `ClinicalCaseOpened`, `ClinicalObservationCaptured`, `CaseClosed` |
| Diagnostics AI | `AIStudy` | Определяет входные данные, используемую модель и результат; инвариант — каждая версия модели подписана и имеет SLA | `SubmitAIStudy`, `PublishAIReport` |
| Fintech Lending | `CreditApplication` | Содержит KYC, скоринг, запрошенную сумму; нельзя создать контракт пока заявка не в status=APPROVED | `CreateApplication`, `ApproveApplication`; событие `CreditApplicationCreated` |
| Fintech Lending | `CreditContract` | Кредитный договор с графиком; инвариант — сумма платежей графика = сумме тела+процентов | `ActivateContract`, `RescheduleInstalment`; события `CreditContractCreated`, `PaymentScheduleGenerated` |
| Payments | `PaymentOrder` | Ордер со статусами Authorization/Settlement; запрещено повторно авторизовать оплаченный ордер | `AuthorizePayment`, `SettlePayment`; события `PaymentAuthorized`, `PaymentSettled` |
| Pharma Supply | `DrugShipment` | Отгрузка конкретной партии; партия принадлежит одному терапевтическому кейсу; нельзя списать до подтверждения приёмки | `DispatchBatch`, `ReceiveBatch`; события `DrugBatchDispatched`, `DrugBatchReceived` |
| Data Mesh | `DataProduct` | Логическое представление витрины; версия публикуется только при прохождении тестов качества и ревью Data Steward | `PublishDataProduct`, `DeprecateDataProduct`; события `DataProductPublished`, `DataQualityAlertRaised` |
| Customer 360 | `CustomerSegment` | Список клиентов с критериями; инвариант — сегменты управляются декларативно, пересечения фиксируются; | `RecalculateSegment`, событие `CustomerSegmentUpdated` |

