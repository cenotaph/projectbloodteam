class Importbacklog < ActiveRecord::Base
  belongs_to :import
  belongs_to :pbtentry, polymorphic: true
end
