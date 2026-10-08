CREATE TYPE media_enum AS ENUM('IMAGE', 'VIDEO');

CREATE TABLE IF NOT EXISTS report_medias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id UUID NOT NULL,
  sort_order INTEGER NOT NULL,
  media media_enum NOT NULL, -- DEFAULT 'IMAGE'
  created_at TIMESTAMP DEFAULT now() NOT NULL,
  updated_at TIMESTAMP DEFAULT now() NOT NULL,
  deleted_at TIMESTAMP,

  CONSTRAINT fk_report_medias_reports
  FOREIGN KEY (report_id)
  REFERENCES reports(id)
  ON DELETE CASCADE
);
