class CreateTimetracks < ActiveRecord::Migration
  def change
    create_table :timetracks do |t|
      t.text :description
      t.integer :amount_in_minutes
      t.integer :employee_id
      t.date :log_date

      t.timestamps null: false
    end
  end
end
