CREATE TABLE IF NOT EXISTS refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  token VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT now() NOT NULL,
  expires_at TIMESTAMP DEFAULT now() NOT NULL,
  deleted_at TIMESTAMP,

  CONSTRAINT fk_refresh_tokens_users
  FOREIGN KEY (user_id)
  REFERENCES users(id)
  ON DELETE CASCADE
);
