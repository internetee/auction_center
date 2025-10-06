class LetsMakeThisShit < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :when_this_shit_happens, :datetime
  end
end
