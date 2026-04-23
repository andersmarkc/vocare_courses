class AddIntroToLessons < ActiveRecord::Migration[8.1]
  def change
    add_column :lessons, :intro, :text
  end
end
