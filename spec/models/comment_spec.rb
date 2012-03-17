# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  commentable_id   :integer         default(0)
#  commentable_type :string(255)     default("")
#  title            :string(255)     default("")
#  body             :text            default("")
#  subject          :string(255)     default("")
#  user_id          :integer         default(0), not null
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime
#  updated_at       :datetime
#

