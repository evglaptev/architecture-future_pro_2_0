| Событие | Источник (bounded context) | Подписчики | Содержание (минимальный контракт) |
| --- | --- | --- | --- |
| `PatientRegistered` | Patient Care / PatientProfile | Customer 360, Lending, Data Mesh | `patient_id`, `demographics`, `consent_flags`, `registered_at` |
| `ClinicalCaseOpened` | Patient Care / TherapyCase | Diagnostics AI, Pharma Supply, Data Mesh | `case_id`, `patient_id`, `care_plan`, `estimated_cost`, `domain_version` |
| `ClinicalObservationCaptured` | Patient Care / TherapyCase | Diagnostics AI, Data Mesh | `case_id`, `observation_type`, `payload_ref`, `captured_at`, `producer` |
| `AIReportPublished` | Diagnostics AI / AIStudy | Patient Care, Data Mesh, Compliance | `study_id`, `case_id`, `model_version`, `confidence`, `report_uri` |
| `DrugBatchReceived` | Pharma Supply / DrugShipment | Patient Care, Data Mesh, Compliance | `shipment_id`, `case_id`, `batch_no`, `expiry`, `cold_chain_status` |
| `CreditApplicationCreated` | Lending / Loan Origination | Risk, Payments, Data Mesh | `application_id`, `patient_id`, `amount`, `score`, `channel` |
| `CreditContractCreated` | Lending / CreditContract | Payments, Data Mesh, Customer 360 | `contract_id`, `patient_id`, `principal`, `interest_rate`, `term`, `currency` |
| `PaymentAuthorized` | Payments / PaymentOrder | Lending, Data Mesh | `payment_id`, `contract_id`, `amount`, `method`, `authorized_at` |
| `PaymentSettled` | Payments / PaymentOrder | Lending, Data Mesh, Customer 360 | `payment_id`, `status`, `settled_at`, `fee`, `processor_reference` |
| `DataProductPublished` | Data Mesh / DataProduct | Self-service Portal, Compliance, Downstream apps | `product_id`, `domain`, `version`, `schema_ref`, `owner`, `sla` |
| `DataQualityAlertRaised` | Data Mesh / Monitoring | Domain teams, Compliance | `product_id`, `severity`, `failed_check`, `detected_at` |
| `CustomerSegmentUpdated` | Customer 360 / Segmentation | Patient Care, Lending, Marketing | `segment_id`, `criteria_hash`, `members_delta`, `valid_from` |

