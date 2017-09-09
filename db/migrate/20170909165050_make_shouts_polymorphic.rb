class MakeShoutsPolymorphic < ActiveRecord::Migration[5.0]
  class Shout < ApplicationRecord
    belongs_to :content, polymorphic: true
  end
  class TextShout < ApplicationRecord; end
  def change
    change_table(:shouts) do |t|
      t.string :content_type
      t.integer :content_id
      t.index [:content_type, :content_id]
    end
    Shout.reset_column_information
    reversible do |dir|
      Shout.find_each do |shout|
        dir.up do
          text_shout = TextShout.create(body: shout.body)
          shout.update(content_type: "TextShout", content_id: text_shout.id)
        end
        dir.down do
          shout.update(body: shout.content.body)
          shout.content.destroy
        end
      end
    end
    remove_column :shouts, :body, :string
  end
end
