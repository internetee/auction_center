class SetRoleConstraints < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      ALTER TABLE public.users
      ADD CONSTRAINT users_roles_are_known
        CHECK (roles <@ ARRAY['participant'::VARCHAR, 'administrator'::VARCHAR]);
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
      ALTER TABLE public.users DROP CONSTRAINT users_roles_are_known;
    SQL

    execute(sql)
  end
end
