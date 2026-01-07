# 📊 Database Schema – Appointment Booking Application

This document describes the **database design** used in the appointment booking application.
The schema supports user authentication, service catalog browsing, provider selection,
appointment scheduling, history, and summaries, as required by the project specification.

---

## 1. Users & Profiles

Authentication is handled externally (e.g. Supabase Auth).
Additional user information is stored in the `profiles` table.

### `profiles`
| Column | Type | Description |
|------|------|------------|
| `id` | uuid (PK) | User ID (references `auth.users.id`) |
| `name` | text | User first name |
| `surname` | text | User last name |
| `dob` | date | Date of birth |
| `created_at` | timestamptz | Profile creation timestamp |

**Purpose**:  
Stores user profile data required by the application (name, surname, date of birth).

---

## 2. Service Categories

### `categories`
| Column | Type | Description |
|------|------|------------|
| `id` | uuid (PK) | Category identifier |
| `name` | text (UNIQUE) | Category name (e.g. Health, Wellness) |

**Purpose**:  
Groups services into logical categories for easier browsing.

---

## 3. Services

Each service belongs to a category and contains descriptive and pricing information.

### `services`
| Column | Type | Description |
|------|------|------------|
| `id` | uuid (PK) | Service identifier |
| `category_id` | uuid (FK) | References `categories.id` |
| `name` | text | Service name |
| `short_description` | text | Short service description |
| `full_description` | text | Detailed service description |
| `min_duration_minutes` | int | Minimum service duration |
| `max_duration_minutes` | int | Maximum service duration |
| `cost` | numeric(10,2) | Indicative service cost |
| `created_at` | timestamptz | Creation timestamp |

**Purpose**:  
Represents the service catalog shown to users, including duration and cost details.

---

## 4. Service Providers

A service can be offered by one or more providers (e.g. doctors, salons).

### `providers`
| Column | Type | Description |
|------|------|------------|
| `id` | uuid (PK) | Provider identifier |
| `service_id` | uuid (FK) | References `services.id` |
| `display_name` | text | Provider name |
| `location_text` | text | Optional location info |
| `created_at` | timestamptz | Creation timestamp |

**Purpose**:  
Allows selection of a specific provider for a given service.

---

## 5. Provider Availability

Defines weekly availability schedules for providers.

### `provider_availability`
| Column | Type | Description |
|------|------|------------|
| `id` | uuid (PK) | Availability identifier |
| `provider_id` | uuid (FK) | References `providers.id` |
| `weekday` | smallint | Day of week (1=Mon … 7=Sun) |
| `start_time` | time | Start of working hours |
| `end_time` | time | End of working hours |
| `slot_minutes` | int | Duration of appointment slots |
| `created_at` | timestamptz | Creation timestamp |

**Purpose**:  
Used to generate available dates and time slots for booking.

---

## 6. Appointments (Bookings)

Stores all appointments created by users.

### `appointments`
| Column | Type | Description |
|------|------|------------|
| `id` | uuid (PK) | Appointment identifier |
| `user_id` | uuid (FK) | References authenticated user |
| `service_id` | uuid (FK) | References `services.id` |
| `provider_id` | uuid (FK) | References `providers.id` |
| `starts_at` | timestamptz | Appointment start time |
| `ends_at` | timestamptz | Appointment end time |
| `notes` | text | Optional user notes |
| `status` | text | `scheduled`, `cancelled`, `completed` |
| `created_at` | timestamptz | Creation timestamp |
| `updated_at` | timestamptz | Last update timestamp |

**Purpose**:  
Supports appointment creation, modification, cancellation, history, and summaries.

---

## 7. Reporting & History

No additional tables are required for summaries.

The following are computed via queries on `appointments`:
- Total number of appointments
- Total booked time (sum of durations)
- Total cost per period (month/year)
- Appointment history per user

---

## 8. Schema Overview

