class AddCommentToStatusHistories < ActiveRecord::Migration[7.2]
  def change
    add_column :status_histories, :comment, :string
  end
end
