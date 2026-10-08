CREATE TYPE status_enum AS ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED');

CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  report_category_id UUID NOT NULL,
  description TEXT,
  status status_enum NOT NULL DEFAULT 'PENDING',
  street VARCHAR(255) NOT NULL,
  number VARCHAR(255) NOT NULL,
  complement VARCHAR(255),
  neighborhood VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  state VARCHAR(255) NOT NULL,
  postal_code VARCHAR(255) NOT NULL,
  coordinates GEOGRAPHY(POINT,4326) NOT NULL,
  created_at TIMESTAMP DEFAULT now() NOT NULL,
  updated_at TIMESTAMP DEFAULT now() NOT NULL,
  deleted_at TIMESTAMP,

  CONSTRAINT fk_reports_users
  FOREIGN KEY (user_id)
  REFERENCES users(id)
  ON DELETE CASCADE,

  CONSTRAINT fk_reports_report_categories
  FOREIGN KEY (report_category_id)
  REFERENCES report_categories(id)
  ON DELETE RESTRICT
);
