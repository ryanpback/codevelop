class ChangeIdsInMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column(:messages, :user_id, :integer)
    add_column(:messages, :sender_id, :integer)
  end
end
