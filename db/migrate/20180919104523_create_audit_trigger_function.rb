class CreateAuditTriggerFunction < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      --- Create function for creating audit tables
      CREATE SCHEMA IF NOT EXISTS audit;

      --- Create function for creating audit tables
      CREATE OR REPLACE FUNCTION create_audit_table(t_name varchar(30))
        RETURNS VOID AS
      $func$
      BEGIN

      EXECUTE format(
        'CREATE TABLE IF NOT EXISTS %I.%I (
           object_id          bigint,
           action TEXT NOT NULL CHECK (action IN (%L, %L, %L, %L)),
           recorded_at        timestamp without time zone,
           old_record         jsonb,
           new_record         jsonb
        )',
        'audit',
        t_name,
        'INSERT',
        'DELETE',
        'UPDATE',
        'TRUNCATE'
      );

      END
      $func$ LANGUAGE plpgsql;

      SELECT(create_audit_table('users'));

      --- Create the actual audit trigger function
      CREATE OR REPLACE FUNCTION process_user_audit() RETURNS TRIGGER AS $process_user_audit$
        BEGIN
          IF (TG_OP = 'INSERT') THEN
            INSERT INTO audit.users (object_id, action, recorded_at, old_record, new_record)
            VALUES (NEW.id, 'INSERT', now(), '{}', to_json(NEW)::jsonb);
            RETURN NEW;
          ELSEIF (TG_OP = 'UPDATE') THEN
            INSERT INTO audit.users (object_id, action, recorded_at, old_record, new_record)
            VALUES (NEW.id, 'UPDATE', now(), to_json(OLD)::jsonb, to_json(NEW)::jsonb);
            RETURN NEW;
          ELSEIF (TG_OP = 'DELETE') THEN
            INSERT INTO audit.users (object_id, action, recorded_at, old_record, new_record)
            VALUES (OLD.id, 'DELETE', now(), to_json(OLD)::jsonb, '{}');
            RETURN OLD;
          END IF;
          RETURN NULL;
        END
      $process_user_audit$ LANGUAGE plpgsql;

      --- Create the actual trigger
      CREATE TRIGGER process_user_audit
      AFTER INSERT OR UPDATE OR DELETE ON users
      FOR EACH ROW EXECUTE PROCEDURE process_user_audit();
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
    DROP TRIGGER IF EXISTS process_user_audit;
    DROP FUNCTION IF EXISTS process_user_audit;
    DROP TABLE IF EXISTS audit.users;
    DROP FUNCTION IF EXISTS create_audit_table(varchar(30));
    DROP SCHEMA IF EXISTS audit;
    SQL

    execute(sql)
  end
end
