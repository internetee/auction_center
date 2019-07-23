require 'test_helper'
require 'audit_migration'

class AuditMigrationTest < ActiveSupport::TestCase
  def setup
    @instance = AuditMigration.new('post')
  end

  def test_raw_sql_for_create_table
    assert_equal(expected_create_table, @instance.create_table)
  end

  def test_raw_sql_for_create_trigger
    assert_equal(expected_create_trigger, @instance.create_trigger)
  end

  def test_raw_sql_for_drop
    assert_equal(expected_drop, @instance.drop)
  end

  def expected_create_trigger
    <<~SQL
      CREATE OR REPLACE FUNCTION process_post_audit()
      RETURNS TRIGGER AS $process_post_audit$
        BEGIN
          IF (TG_OP = 'INSERT') THEN
            INSERT INTO audit.posts
            (object_id, action, recorded_at, old_value, new_value)
            VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
            RETURN NEW;
          ELSEIF (TG_OP = 'UPDATE') THEN
            INSERT INTO audit.posts
            (object_id, action, recorded_at, old_value, new_value)
            VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
            RETURN NEW;
          ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO audit.posts
            (object_id, action, recorded_at, old_value, new_value)
            VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
            RETURN OLD;
          END IF;
          RETURN NULL;
        END
      $process_post_audit$ LANGUAGE plpgsql;

      --- Create the actual trigger
      CREATE TRIGGER process_post_audit
      AFTER INSERT OR UPDATE OR DELETE ON posts
      FOR EACH ROW EXECUTE PROCEDURE process_post_audit();
    SQL
  end

  def expected_drop
    <<~SQL
      DROP TRIGGER IF EXISTS process_post_audit ON posts;
      DROP FUNCTION IF EXISTS process_post_audit();
      DROP TABLE IF EXISTS audit.posts;
    SQL
  end

  def expected_create_table
    <<~SQL
      CREATE TABLE IF NOT EXISTS audit.posts (
           id                 serial NOT NULL,
           object_id          bigint,
           action TEXT NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE', 'TRUNCATE')),
           recorded_at        timestamp without time zone,
           old_value          jsonb,
           new_value          jsonb
        );


        ALTER TABLE audit.posts ADD PRIMARY KEY (id);
        CREATE INDEX ON audit.posts USING btree (object_id);
        CREATE INDEX ON audit.posts USING btree (recorded_at)
    SQL
  end
end
