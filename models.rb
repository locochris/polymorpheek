require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :fathers do |t|
    t.string :name
  end

  create_table :mothers do |t|
    t.string :name
  end

  create_table :children do |t|
    t.references :parentable, polymorphic: true
    t.string :type
    t.string :name
  end
end

module Parentable
  def self.included(mod)
    mod.has_many :children, as: :parentable
  end
end

class Father < ActiveRecord::Base
  include Parentable
end

class Mother < ActiveRecord::Base
  include Parentable
end

class Child < ActiveRecord::Base
  belongs_to :parentable, polymorphic: true

  def inspect
    "#<#{self.class.name}[#{id}] #{name.inspect}>"
  end
end

class Boy < Child
end

class Girl < Child
end
