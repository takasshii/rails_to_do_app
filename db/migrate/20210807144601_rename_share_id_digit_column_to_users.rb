class RenameShareIdDigitColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :share_id_digit, :share_id
  end
end
