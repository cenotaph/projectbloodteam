# ActionController::Base.class_eval do
#   # Assumes a per-application/request view prioritization, not per-controller
#   cattr_accessor :application_view_path
#   self.view_paths = %w(app/views
#                        app/views/generic
#                        app/views/classic
#                        app/views/flume).map do |path| Rails.root.join(path).to_s end
# end
 
# ActionView::PathSet.class_eval do
#   def each_with_application_view_path(&block)
#     application_view_path = ActionController::Base.application_view_path
#  
#     if application_view_path
#       # remove and prepend the view path in question to the array BEFORE proceeding with the 'each' operation
#       (select do |item|
#         item.to_s == application_view_path
#       end + reject do |item|
#         item.to_s == application_view_path
#       end).each(&block)
#     else
#       each_without_application_view_path(&block)
#     end
#   end
#  
#   # as usual, lets play nice with anything else in the call chain.
#   alias_method_chain :each, :application_view_path
# end